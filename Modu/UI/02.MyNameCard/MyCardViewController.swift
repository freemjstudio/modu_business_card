//
//  MyCardViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//

import AVFoundation
import UIKit

class MyCardViewController: UIViewController {
   
    var myCard: Card?
    
    @IBAction func editBtn(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myCard == nil {
            // show default view
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
