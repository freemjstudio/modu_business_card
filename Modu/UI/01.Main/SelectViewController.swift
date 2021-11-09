//
//  SelectViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//

import SocketIO
import UIKit
class SelectViewController: UIViewController {
    var socket: SocketIOClient!
    // 명함 전송하기
    @IBAction func SendBtn(_ sender: Any) {
        SocketIOManager.shared.establishConnection()
    }

    // 명함 받기
    @IBAction func RecvBtn(_ sender: Any) {}

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
