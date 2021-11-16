//
//  ReceiveViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//
import AVFoundation
import CoreAudio
import Foundation

import UIKit

class ReceiveViewController: UIViewController {
    var player = AVQueuePlayer()

    @IBAction func btn(_ sender: UIButton) {
        if let url = Bundle.main.url(forResource: "chirp", withExtension: "m4a") {
            player.removeAllItems()
            player.insert(AVPlayerItem(url: url), after: nil)
            player.play()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
