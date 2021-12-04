//
//  SendCardViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//
import AVFoundation
import CoreAudio
import Foundation
import UIKit

class SendCardViewController: UIViewController, AVAudioRecorderDelegate, StreamDelegate {
    var recorder: AVAudioRecorder!
    var outputStream: OutputStream?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard outputStream != nil else { return }

//        let outputData = Data(referencing: audioData).withUnsafeBytes { unsafeBytes in
//            let bytes = unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
//            outputStream?.write(bytes, maxLength: audioData.count)
//
//            print("count :",audioData.count)
//          //  print("length :", audioData.length)
//        }
    }

    func stopRecord() {
        recorder.stop()

        try? AVAudioSession.sharedInstance().setActive(false)
    }

    public func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    // back btn 누르면 녹음 stop 됨 !
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopRecord()
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
