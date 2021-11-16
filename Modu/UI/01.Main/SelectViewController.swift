//
//  SelectViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//
import AVFoundation
import CoreAudio
import Foundation
import SocketIO
import UIKit

class SelectViewController: UIViewController, StreamDelegate {
    // socket 통신
    var host_address = "3.35.25.230"
    let host_port = 12000
    var input: InputStream?
    var output: OutputStream?

    var recorder: AVAudioRecorder!
    var levelTimer = Timer()

    var socket: SocketIOClient!
    // 명함 전송하기
    @IBAction func SendBtn(_ sender: Any) {
        Stream.getStreamsToHost(withName: host_address, port: host_port, inputStream: &input, outputStream: &output)
        output!.open()
        input?.delegate = self
        let myRunLoop = RunLoop.current
        input?.schedule(in: myRunLoop, forMode: .default)
        input!.open()
        print("current ip: ", host_address)
        record()
    }

    // 명함 받기
    @IBAction func RecvBtn(_ sender: Any) {
        Stream.getStreamsToHost(withName: host_address, port: host_port, inputStream: &input, outputStream: &output)
        output!.open()
        input?.delegate = self
        let myRunLoop = RunLoop.current
        input?.schedule(in: myRunLoop, forMode: .default)
        input!.open()
        print("current ip: ", host_address)
        record()
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

    func record() {
        let audioSession = AVAudioSession.sharedInstance()

        // userDomainMask 에 녹음 파일 생성
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        print("녹음된 파일은 여기 저장됨:", documents.absoluteString.replacingOccurrences(of: "file://", with: ""))

        // 녹음 세팅
        let recordSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleIMA4,
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderBitRateKey: 9600,
            AVLinearPCMBitDepthKey: 8,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
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
        recorder.record()
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

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
