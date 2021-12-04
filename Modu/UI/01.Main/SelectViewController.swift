//
//  SelectViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//
import AVFoundation
import CocoaAsyncSocket
import CoreAudio
import Foundation
import UIKit

var audioData = NSData() // audio Data
var chirpData = NSData()
var myProfile = cardList[0].image?.pngData() // UIImage

class SelectViewController: UIViewController, StreamDelegate {
    // socket 통신
    var host_address = "13.209.9.126"
    let host_port = 12000
    var inputStream: InputStream?
    var outputStream: OutputStream?

    var recorder: AVAudioRecorder!
    var player = AVQueuePlayer()
    var levelTimer = Timer()

    let sender = 1 // 명함 전송
    let receiver = 2 // 명함 받기

    var audioURL: URL?

    func playChirpSound() {
        if let url = Bundle.main.url(forResource: "chirp", withExtension: "m4a") {
            player.removeAllItems()
            player.insert(AVPlayerItem(url: url), after: nil)
            player.play()
            chirpData = try! Data(contentsOf: url) as NSData

            print(chirpData.count) // number of elements in collections
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

        //  record()
        playChirpSound()

        //  audioData = try! Data(contentsOf: audioURL!) as NSData // 여기에 file을 담아준다.

//        let outputData = Data(referencing: chirpData).withUnsafeBytes { unsafeBytes in
//            let audioDataBytes = unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
//
//            //      let dataSize = withUnsafeBytes(of: audioData.count.bigEndian, Array.init)
//            //    let byteData = withUnsafeBytes(of: audioData, Array.init)
//
//            //  outputStream?.write(chirpData, maxLength: chirpData.count) // audio data 를 Byte로 바꾼것의 길이..
//            outputStream?.write(audioDataBytes, maxLength: chirpData.count)
//        }

//

        // -1 header size 보내기
//
//        let outputCardData = Data(referencing: myProfile as! NSData).withUnsafeBytes { unsafeBytes in
//            
//            let dataByte = unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
//            let dataSize = withUnsafeBytes(of: myProfile?.count.bigEndian, Array.init)
//
//            let first = withUnsafeBytes(of: 1, Array.init)
//            let second = withUnsafeBytes(of: 2, Array.init)
//            // 사이즈 앞에 1
//            outputStream?.write(first, maxLength: myProfile!.count)
//            outputStream?.write(dataSize, maxLength: myProfile!.count)
//
//            // 이미지 앞에 2
//            outputStream?.write(second, maxLength: myProfile!.count)
//            outputStream?.write(dataByte, maxLength: myProfile!.count) // png 파일 전송
//            print(myProfile?.count)
//
//            print("이거", dataSize)
//        }


        let msg = "a"
        let outData = msg.data(using: .utf8)
        outData?.withUnsafeBytes {
            _ in
            outputStream!.write(msg, maxLength: outData!.count)
            print(msg.count)
        }
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

        if let url2 = Bundle.main.url(forResource: "audio", withExtension: "m4a") {
            print(url2)
            let tempData = try! Data(contentsOf: url2) as NSData
            print("=============tempData: ", tempData)
        }
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
        print("+++++++++ url : ", url)

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

        audioURL = url
        // print("audio Data -----", audioData.count)
    }

    func searchRecord() {
        let urlString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        if let urls = try? FileManager.default.subpathsOfDirectory(atPath: urlString) {
            for path in urls {
                print("\(urlString)/\(path)")
                //     addAudio(URL(string: "file://\(urlString)/\(path)")!)
            }
        }
    }

    func stopRecord() {
        recorder.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
        searchRecord()
    }

    func findRecord() {
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

    func sendAudioData() {}

    // my card 내용 전송하기

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
}
