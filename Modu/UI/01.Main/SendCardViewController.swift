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
    
    let alert = UIAlertController(title: "성공! ", message: "명함 데이터를 보내겠습니까?", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
        cardList.append(Card(name: "Yoon Ha. B", tel: "010-1111-2222", company: "중앙대학교", image: UIImage(named: "cau"), email: "tlol91@cau.com"))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        alert.addAction(okAction)

        present(alert, animated: false, completion: nil)
        
        
    }

    func sendStringHeader2Server() {
        let type = Int8(0)
        var data_size = UInt32(cardList[0].name.count)
        var send_data_size: UInt32 = data_size.bigEndian

        let bytes = MemoryLayout<UInt32>.size * 2
        let pointerS = UnsafeMutableRawPointer.allocate(byteCount: bytes, alignment: 2)

        let o0 = 0
        pointerS.advanced(by: o0).storeBytes(of: Int8(type), as: Int8.self)
        let o1 = 4
        pointerS.advanced(by: o1).storeBytes(of: send_data_size, as: UInt32.self)

        let ptrDataType0 = pointerS.assumingMemoryBound(to: UInt8.self)
        outputStream?.write(ptrDataType0, maxLength: MemoryLayout<UInt32>.size * 2)
    }

    // send2server
    func sendString2Server() {
        let type = Int8(1)
        let message = cardList[0].name // "Minji"
        let message_size = message.data(using: .utf8)?.count
        let send_message_size:UInt32 = UInt32(message_size!).bigEndian // 실제로 보낼 메세지의 사이즈를 bigendian으로 저장

        guard outputStream != nil else { return }
        let outData = message.data(using: .utf8)
        outData?.withUnsafeBytes { (p: UnsafePointer<UInt8>) -> Void in
            outputStream!.write(p, maxLength: (outData?.count)!)
        }

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
