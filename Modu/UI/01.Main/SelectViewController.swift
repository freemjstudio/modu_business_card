//
//  SelectViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//
import AVFoundation
import CoreAudio
import Foundation
import UIKit

class SelectViewController: UIViewController, StreamDelegate {
    // socket 통신
    var host_address = "3.35.25.230"
    let host_port = 12000
    var inputStream: InputStream?
    var outputStream: OutputStream?

    var recorder: AVAudioRecorder!
    var player = AVQueuePlayer()
    var levelTimer = Timer()
    
    var audioData = NSData() // audio Data

    func playChirpSound() {
        if let url = Bundle.main.url(forResource: "chirp", withExtension: "m4a") {
            player.removeAllItems()
            player.insert(AVPlayerItem(url: url), after: nil)
            player.play()
        }
    }

    // 명함 전송하기
    @IBAction func SendBtn(_ sender: Any) {
        Stream.getStreamsToHost(withName: host_address, port: host_port, inputStream: &inputStream, outputStream: &outputStream)
        outputStream!.open()
        inputStream?.delegate = self
        let myRunLoop = RunLoop.current
        inputStream?.schedule(in: myRunLoop, forMode: .default)
        inputStream!.open()
        print("current ip: ", host_address)

        record()
        // 여기에 소켓 보내야댐
    //    sendAudioData()
        playChirpSound()
    }

    // 명함 받기
    @IBAction func RecvBtn(_ sender: Any) {
        Stream.getStreamsToHost(withName: host_address, port: host_port, inputStream: &inputStream, outputStream: &outputStream)
        outputStream!.open()
        inputStream?.delegate = self
        let myRunLoop = RunLoop.current
        inputStream?.schedule(in: myRunLoop, forMode: .default)
        inputStream!.open()
        print("current ip: ", host_address)
        record()
        playChirpSound()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //  initRecord()
    }

    func initRecord() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("mic 권한 허용\n")
        case .denied:
            recordNotAllowed()
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                print(granted)

                if granted {
                    DispatchQueue.main.sync {
                        print("mic 권한 허용됨 !! \n")
                    }
                } else {
                    self.recordNotAllowed()
                }
            }
        default:
            break
        }
    }

    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func record() {
        let audioSession = AVAudioSession.sharedInstance()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsURL.appendingPathComponent("audio.m4a") // caf
        print("녹음된 파일은 여기 저장됨:", documentsURL.absoluteString.replacingOccurrences(of: "file://", with: ""))

        // 녹음 세팅
        let recordSettings: [String: Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey: 12000.0,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: 44100.0
        ]

        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setActive(true)

            try recorder = AVAudioRecorder(url: url, settings: recordSettings)
    
        } catch {
            print(error)
            return
        }
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record(forDuration: 5.0) // 5초동안 녹음하기
        audioData = try! Data(contentsOf: url) as NSData // 여기에 바로...? 담아주기 ?
        
        guard (audioData != nil) else {return}
        
    }

    func stopRecord() {
        recorder.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
        searchRecord()
    }

    func searchRecord() {
        let urlString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        if let urls = try? FileManager.default.subpathsOfDirectory(atPath: urlString) {
            for path in urls {
                print("\(urlString)/\(path)")
            }
        }
    }

    func recordNotAllowed() {
        print("permission denined!")
    }

    func sendAudioData() {
        

        
    }

    // text 보내는 방법
    
    func sendCardData() {
        let message = "hello \n"
        guard outputStream != nil else { return }
        let outData = message.data(using: .utf8)
        outData?.withUnsafeBytes { (p: UnsafePointer<UInt8>) -> Void in
            outputStream!.write(p, maxLength: (outData?.count)!)
        }
    }

    // data 받는 부분 명함 데이타 받기 !!
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            let iStream = aStream as! InputStream
            let buffersize = 1024
            var buffer = [UInt8](repeating: 0, count: buffersize)
            iStream.read(&buffer, maxLength: buffersize)
            let msg = String(bytes: buffer, encoding: String.Encoding.utf8)
            print(msg)
        case .endEncountered:
            print("새 명함 received \n")
        case .errorOccurred:
            print("error occured \n")
        case .hasSpaceAvailable:
            print("has space available \n")
        default:
            return
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
