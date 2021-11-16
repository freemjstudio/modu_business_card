//
//  DetailInfoVC.swift
//  Modu
//
//  Created by 우민지 on 2021/11/14.
//

import UIKit

class DetailInfoVC: UIViewController {
    var receivedCardData: Card?

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var telLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.clipsToBounds = true

        nameLabel.text = receivedCardData?.name
        companyLabel.text = receivedCardData?.company
        telLabel.text = receivedCardData?.tel
        emailLabel.text = receivedCardData?.email
        profileImage.image = receivedCardData?.image
    }

    func receiveData(_ card: Card) {
        receivedCardData = card
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
