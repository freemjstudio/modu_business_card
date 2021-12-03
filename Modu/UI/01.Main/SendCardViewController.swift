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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func stopRecord() {
        recorder.stop()
        export(fileType: .m4a, completion: { })
        try? AVAudioSession.sharedInstance().setActive(false)
        searchRecord()
    }

    public func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func searchRecord() {
        let urlString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        if let urls = try? FileManager.default.subpathsOfDirectory(atPath: urlString) {
            for path in urls {
                print("\(urlString)/\(path)")
            }
        }
    }

    func export(fileType: AVFileType = .m4a, completion: @escaping (() -> Void)) {
        var exportOutputURL: URL? {
            let pathURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return pathURL?.appendingPathComponent("audio.m4a")
        }
        let recordingFileURL = getDirectory()
        let asset = AVAsset(url: recordingFileURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else { return }
        exportSession.outputFileType = fileType
        exportSession.metadata = asset.metadata
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputURL = exportOutputURL
        exportSession.exportAsynchronously {
            print("export m4a file finished. \n")
            completion()
        }
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
