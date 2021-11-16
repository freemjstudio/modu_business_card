//
//  SocketIOManager.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//

import Foundation
import SocketIO
import UIKit

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    var manager = SocketManager(socketURL: URL(string: "52.78.56.137:12000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    override init() {
        super.init()
      
        socket.on("message") { data, _ in
            if let message = data.first as? String {
                print(message)
            }
        }
    }
    
    // 서버 주소와 포트로 소켓 연결시도
    func establishConnection() {
        socket.connect()
    }
    
    // connected 된 다음에
    func setupSocketEvents() {
        socket?.on(clientEvent: .connect) { _, _ in
            print("Connected \n")
        }
    }
    
    // 소켓 연결 종료
    func closeConnection() {
        socket.disconnect()
    }
    
    func sendMessage(message: String, nickname: String) {
        socket.emit("event", ["message": "This is a test message"]) // event 라는 이름으로 메세지 emit
    }

    func sendAudioData() {
        // 녹음된 데이타 전송
        socket?.emit("audio", "audio data")
    }
}
