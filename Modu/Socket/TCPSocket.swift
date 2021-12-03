//
//  TCPSocket.swift
//  Modu
//
//  Created by 우민지 on 2021/11/18.
//

import Foundation

class TCPSocket: NSObject, StreamDelegate {
    var host: String?
    var port: Int?
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    func connect(host: String, port: Int) {
        self.host = host
        self.port = port
        
        Stream.getStreamsToHost(withName: host, port: port, inputStream: &inputStream, outputStream: &outputStream)
    
        if inputStream != nil && outputStream != nil {
            
            // set delegate
            inputStream!.delegate = self
            outputStream!.delegate = self
            
            // schedule 
            inputStream!.schedule(in: .main, forMode: RunLoop.Mode.default)
            outputStream!.schedule(in: .main, forMode: RunLoop.Mode.default)
            
            print("Start open() \n")
            
            // open
        }
    }
    
}
