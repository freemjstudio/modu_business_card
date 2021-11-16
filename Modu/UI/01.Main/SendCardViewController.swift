//
//  SendCardViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//
import AVFoundation
import CoreAudio
import Foundation
import SocketIO
import UIKit

class SendCardViewController: UIViewController, AVAudioRecorderDelegate {
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer?
    
    var levelTimer = Timer()
    var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // record()
        SocketIOManager.shared.establishConnection()
        SocketIOManager.shared.sendMessage(message: "test1", nickname: "test2")
        
        // 뷰가 로드 되면 소켓 통신 시작 !
    }
    
    func initRecord() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("mic 권한 허용\n")
            record()
        case .denied:
            recordNotAllowed()
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                print(granted)

                if granted {
                    DispatchQueue.main.sync {
                        self.record()
                    }
                } else {
                    self.recordNotAllowed()
                }
            }
        default:
            break
        }
    }
    
    func playChirpSound() {
        let path = Bundle.main.path(forResource: "chirp", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("can't load chirp sound file!! \n")
        }
    }
    
    func record() {
        let audioSession = AVAudioSession.sharedInstance()

        // userDomainMask 에 녹음 파일 생성
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        print("url복사한뒤 finder 이동 메뉴 폴더로 가기. ", documents.absoluteString.replacingOccurrences(of: "file://", with: ""))

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
        playChirpSound()
        
        // 타이머는 main thread에서 실행 됨
       // levelTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
        
        
    }

    @objc func levelTimerCallback() {
        recorder.updateMeters()
        let level = recorder.averagePower(forChannel: 0)
        
        if level < -48 {
            print("조용함")
        } else if level < -30 {
            print("약간의 소음 있음")
        } else if level < -10 {
            print("조금 시끄러움")
        } else {
            print("시끄러움")
        }
    }

    func recordNotAllowed() {
        print("permission denined!")
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
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
