//
//  MyCardViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//

import AVFoundation
import UIKit
var myCard = Card(name: "라이언", tel: "010-3333-4444", company: "카카오", image: UIImage(named: "ryan"), email: "ryan@kakao.com")

class MyCardViewController: UIViewController {
   
  
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myTel: UILabel!
    @IBOutlet weak var myCompany: UILabel!
    @IBOutlet weak var myEmail: UILabel!
    
    @IBAction func editBtn(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.myImage.image = myCard.image
        self.myName.text = myCard.name
        self.myTel.text = myCard.tel
        self.myCompany.text = myCard.company
        self.myEmail.text = myCard.email
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myImage.image = myCard.image
        self.myName.text = myCard.name
        self.myTel.text = myCard.tel
        self.myCompany.text = myCard.company
        
        
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
