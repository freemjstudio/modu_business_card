//
//  AddNewCardVC.swift
//  Modu
//
//  Created by 우민지 on 2021/11/16.
//

import UIKit

class AddNewCardVC: UIViewController, UITextFieldDelegate {
    @IBOutlet var profileImageView: UIImageView!

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var telTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!

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

    @IBAction func addImageBtn(_ sender: Any) {
        let alert = UIAlertController(title: "프로필 이미지", message: "프로필 이미지를 선택해 주세요", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진 엘범", style: .default) { _ in self.openLibrary() }
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in self.openCamera() }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func saveBtn(_ sender: Any) {
        cardList.append(Card(name: nameTextField.text ?? "-", tel: telTextField?.text ?? "-", company: companyTextField.text ?? "-", image: profileImageView.image, email: emailTextField.text ?? "-"))

        navigationController?.popViewController(animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        nameTextField.delegate = self
        telTextField.delegate = self
        companyTextField.delegate = self
        emailTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    func keyboardWillShow(_ sender: NotificationCenter) {
        view.frame.origin.y = -150
    }

    @objc
    func keyboardWillHide(_ sender: NotificationCenter) {
        view.frame.origin.y = 0 // Move view to original position
    }
}

extension AddNewCardVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
            print(info)
        }

        dismiss(animated: true, completion: nil)
    }
}
