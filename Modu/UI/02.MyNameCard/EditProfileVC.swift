//
//  EditProfileVC.swift
//  Modu
//
//  Created by 우민지 on 2021/11/17.
//

import UIKit

class EditProfileVC: UIViewController, UITextFieldDelegate {
    
    //UI entity
    @IBOutlet var myProfile: UIImageView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var name: UITextField!
    @IBOutlet var tel: UITextField!
    @IBOutlet var company: UITextField!
    @IBOutlet var email: UITextField!
    
    // image 업로드 버튼
    
    @IBAction func uploadBtn(_ sender: Any) {
        let alert = UIAlertController(title: "프로필 이미지", message: "프로필 이미지를 선택해 주세요", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진 엘범", style: .default) { _ in self.openLibrary() }
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in self.openCamera() }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var uploadLabel: UIButton!
    
    // photo library access
    let picker = UIImagePickerController()

    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            print("camera is not available\n")
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        myCard.name = name.text ?? myCard.name
        myCard.tel = tel.text ?? myCard.tel
        myCard.email = email.text ?? myCard.email
        myCard.company = company.text ?? myCard.company
        myCard.image = myProfile.image ?? myProfile.image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        name.text = myCard.name
        tel.text = myCard.tel
        email.text = myCard.email
        company.text = myCard.company
        myProfile.image = myCard.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        uploadLabel.applyGradient(colors: [UIColorFromRGB(0x2B95CE).cgColor, UIColorFromRGB(0x2ECAD5).cgColor])
        // Do any additional setup after loading the view.
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

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myProfile.image = image
            print(info)
        }

        dismiss(animated: true, completion: nil)
    }
}
