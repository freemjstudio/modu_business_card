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

var audioData = Data() // audio Data
var chirpData = NSData() // chirp signal & server test data
var myProfile = cardList[0].image?.pngData() // UIImage

class SelectViewController: UIViewController, StreamDelegate, AVAudioRecorderDelegate {
    // socket 통신
    var host_address = "54.180.158.163"
    let host_port = 12000
    var inputStream: InputStream?
    var outputStream: OutputStream?

    var recorder: AVAudioRecorder!
    var downloadTask: URLSessionDownloadTask?

    var player = AVQueuePlayer()
    var levelTimer = Timer()

    var audioURL: URL?

    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }

    func playChirpSound() {
        if let url = Bundle.main.url(forResource: "chirp", withExtension: "m4a") {
            player.removeAllItems()
            player.insert(AVPlayerItem(url: url), after: nil)
            player.play()
        }

        if let url2 = Bundle.main.url(forResource: "audio_test", withExtension: "m4a") {
            chirpData = try! Data(contentsOf: url2) as NSData
        }
    }

    func address(of object: UnsafeRawPointer) -> String {
        let address = Int(bitPattern: object)
        return String(format: "%p", address)
    }

    // 명함 전송하기 - A
    @IBAction func SendBtn(_ sender: Any) {
        Stream.getStreamsToHost(withName: host_address, port: host_port, inputStream: &inputStream, outputStream: &outputStream)
        outputStream!.open()
        inputStream?.delegate = self
        let myRunLoop = RunLoop.current
        inputStream?.schedule(in: myRunLoop, forMode: .default)
        inputStream!.open()
        print("current ip: ", host_address)

        record()
        playChirpSound()

        do {
            audioData = try Data(contentsOf: audioURL!)
            print(audioData.count)
        } catch {
            print(error.localizedDescription)
        }

        /* sendfilename2server */

        // (5, file_name, strlen(file_name), length)
        // (char type, const char* data, int data_size, int file_size)
        /*
                 let type = Int8(5) // test1.Int8(5) // "5"

                 let data = "chirp.m4a"
                 var data_size = UInt32(data.count)
                 var file_size = UInt32(chirpData.count) // UInt32(chirpData.count) // file 자체의 사이즈

                 var send_data_size: UInt32 = data_size.bigEndian

                 var send_file_data_size: UInt32 = file_size.bigEndian

                 let bytes = MemoryLayout<UInt32>.size * 2 // 4

                 let pointerA = UnsafeMutableRawPointer.allocate(byteCount: bytes, alignment: 3)

                 let o0 = 0
                 pointerA.advanced(by: o0).storeBytes(of: Int8(type), as: Int8.self)
                 let o1 = 4 // ERROR MemoryLayout<Int8>.size -> ??
                 pointerA.advanced(by: o1).storeBytes(of: send_data_size, as: UInt32.self)
                 let o2 = o1 + 4 // ERROR MemoryLayout<Int8>.size
                 pointerA.advanced(by: o2).storeBytes(of: send_file_data_size, as: UInt32.self)

                 var value = pointerA.advanced(by: o0).load(as: Int8.self)
                 var value2 = pointerA.advanced(by: o1).load(as: UInt32.self)
                 var value3 = pointerA.advanced(by: o2).load(as: UInt32.self)

         //        let ptrDataType5 = pointerA.assumingMemoryBound(to: UInt8.self)
         //        outputStream?.write(ptrDataType5, maxLength: MemoryLayout<UInt32>.size * 3)

                 let type_chirp = Int8(6)

                 var cData = (chirpData as Data).withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in

                     let mutRawPointer = UnsafeMutableRawPointer(mutating: ptr)
                     let uploadChunkSize = 32768 // 2040으로 변경하기 !!!!
                     let totalSize = chirpData.count // 1768byte
                     var offset = 0

                     while offset < totalSize {
                         let chunkSize = offset + uploadChunkSize > totalSize ? totalSize - offset : uploadChunkSize
                         let chunkSize_32 = UInt32(chunkSize)
                         let send_chunk_size: UInt32 = chunkSize_32.bigEndian

                         var chunk = Data(bytesNoCopy: mutRawPointer + offset, count: chunkSize, deallocator: Data.Deallocator.none)

                         // pointer
                         //   let chunk_bytes = uploadChunkSize // chunkSize 2040
                         //    var pointerC = UnsafeMutableRawPointer.allocate(byteCount: chunk_bytes + 8, alignment: 3) // 2048*3
                         //   var sizeC = (chunk_bytes + 8) * 3

         //                chunk.withUnsafeBytes { (p: UnsafePointer<UInt8>) -> Void in
         //                    outputStream!.write(p, maxLength: chunk.count)
         //                }

                         // store
                         //      let b0 = 0

                         //  pointerC.advanced(by: b0).storeBytes(of: chunk, as: UInt8.self)
                         // pointerC.advanced(by: b0).storeBytes(of: type_chirp, as: Int8.self) // 0 ~ 2048

                         // let b1 = b0 + chunk_bytes + 8 // 2040 + 8

                         // pointerC.advanced(by: b1).storeBytes(of: send_chunk_size, as: UInt32.self) // 2048 ~ 4096 ????

                         // let b2 = b1 + chunk_bytes + 8 // 2040 + 8
                         // pointerC.advanced(by: b2).storeBytes(of: chunk, as: Data.self)
         //

                         //     let ptrDataType6 = pointerC.assumingMemoryBound(to: UInt8.self)

                         //     outputStream?.write(ptrDataType6, maxLength: sizeC) // UInt8

                     }

                 }
             */
    }

    // 명함 받기 - B
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

        // B packet

        /* sendfilename2server */
        // (5, file_name, strlen(file_name), length)
        // (char type, const char* data, int data_size, int file_size)
        /*
                 let type = Int8(7) // test1.Int8(5) // "5"
                 // print("utf 8 type", MemoryLayout.size(ofValue: type))
                 let data = "chirp.m4a"
                 var data_size = UInt32(data.count)
                 var file_size = UInt32(chirpData.count) // UInt32(chirpData.count) // file 자체의 사이즈

                 var send_data_size: UInt32 = data_size.bigEndian

                 var send_file_data_size: UInt32 = file_size.bigEndian

                 let bytes = MemoryLayout<UInt32>.size * 2 // 4

                 let pointerA = UnsafeMutableRawPointer.allocate(byteCount: bytes, alignment: 3)

                 let o0 = 0
                 pointerA.advanced(by: o0).storeBytes(of: Int8(type), as: Int8.self)
                 let o1 = 4 // ERROR MemoryLayout<Int8>.size -> ??
                 pointerA.advanced(by: o1).storeBytes(of: send_data_size, as: UInt32.self)
                 let o2 = o1 + 4 // ERROR MemoryLayout<Int8>.size
                 pointerA.advanced(by: o2).storeBytes(of: send_file_data_size, as: UInt32.self)

                 var value = pointerA.advanced(by: o0).load(as: Int8.self)
                 var value2 = pointerA.advanced(by: o1).load(as: UInt32.self)
                 var value3 = pointerA.advanced(by: o2).load(as: UInt32.self)

                 print("value : ", value)
                 print("value 2: ", value2)
                 print("value 3: ", value3)

                 let ptrDataType5 = pointerA.assumingMemoryBound(to: UInt8.self)
                 outputStream?.write(ptrDataType5, maxLength: MemoryLayout<UInt32>.size * 3)

                 defer {
                     // pointerA.deallocate()
                 }

                 let type_chirp = Int8(8)

                 // chunkSize 씩 나눠서 서버에 보냄

                 var cData = (chirpData as Data).withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in

                     let mutRawPointer = UnsafeMutableRawPointer(mutating: ptr)
                     let uploadChunkSize = 32768
                     let totalSize = chirpData.count //
                     var offset = 0

                     while offset < totalSize {
                         let chunkSize = offset + uploadChunkSize > totalSize ? totalSize - offset : uploadChunkSize
                         let chunkSize_32 = UInt32(chunkSize)
                         let send_chunk_size: UInt32 = chunkSize_32.bigEndian

                         let chunk = Data(bytesNoCopy: mutRawPointer + offset, count: chunkSize, deallocator: Data.Deallocator.none)
                         print("chunk data size:", chunk.count)
                         offset += chunkSize

                         chunk.withUnsafeBytes { (p: UnsafePointer<UInt8>) -> Void in
                             outputStream!.write(p, maxLength: uploadChunkSize)
                         }

                         // pointer
                         //     let chunk_bytes = uploadChunkSize // chunkSize 2040
                         //       var pointerC = UnsafeMutableRawPointer.allocate(byteCount: chunk_bytes + 48, alignment: 2) // 2048*3
                         //       var sizeC = (chunk_bytes + 48) * 3

                         // store
         //                let b0 = 0
         //                pointerC.advanced(by: b0).storeBytes(of: type_chirp, as: Int8.self) // 0 ~ 2048
         //
         //                let b1 = b0 + chunk_bytes + 48 // 2040 + 8
         //
         //                pointerC.advanced(by: b1).storeBytes(of: send_chunk_size, as: UInt32.self) // 2048 ~ 4096 ????
         //
         //                let b2 = b1 + chunk_bytes + 48 // 2040 + 8
         //                pointerC.advanced(by: b2).storeBytes(of: chunk, as: Data.self)

                         //      let ptrDataType6 = pointerC.assumingMemoryBound(to: UInt8.self)

                         //  outputStream?.write(ptrDataType6, maxLength: sizeC)

                     }

                 }

          */
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        audioURL = documentsURL.appendingPathComponent("audio.m4a") // caf
        print("녹음된 파일은 여기 저장됨:", documentsURL.absoluteString.replacingOccurrences(of: "file://", with: ""))
        print("+++++++++ url : ", audioURL)

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

            try recorder = AVAudioRecorder(url: audioURL!, settings: recordSettings)

        } catch {
            print(error)
            return
        }
        recorder.delegate = self
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record(forDuration: 5.0) // 5초동안 녹음하기
    }

    func searchRecord() {
        let urlString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        if let urls = try? FileManager.default.subpathsOfDirectory(atPath: urlString) {
            for path in urls {
                print("\(urlString)/\(path)")
            }
        }
    }

    func stopRecord() {
        recorder.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
        searchRecord()
    }

    func recordNotAllowed() {
        print("permission denined!")
    }

    func sendAudioData(type: Int, file_size: Int, data: NSData, data_size: Int) {}

    // my card 내용 전송하기
    // file name
    func sendStringHeader() {
        let type = Int8(0)
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
