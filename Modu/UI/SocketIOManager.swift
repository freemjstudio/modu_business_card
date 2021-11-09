//
//  SocketIOManager.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//

import Foundation
import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    var manager = SocketManager(socketURL: URL(string: "http://localhost:9000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        socket = self.manager.socket(forNamespace: "/test") // 룸 /test
        
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
    }
    
    // 서버 주소와 포트로 소켓 연결시도
    func establishConnection() {
        socket.connect()
    }
    
    // 소켓 연결 종료
    func closeConnection() {
        socket.disconnect()
    }
    
    func sendMessage(message: String, nickname: String) {
        socket.emit("event", ["message" : "This is a test message"]) // event 라는 이름으로 메세지 송신
    }
    
}