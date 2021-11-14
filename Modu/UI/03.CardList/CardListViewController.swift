//
//  CardListViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//

import UIKit

class CardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // add new contract
    @IBAction func addBtn(_ sender: Any) {}

    @IBOutlet var cardListTableView: UITableView!

    var cardList: [Card] = [Card(name: "Minji Woo", tel: "010-3125-1610", company: "Google Korea", image: UIImage(named: "minji"), email: "mjwoo001@gmail.com"),
                            Card(name: "Leonard", tel: "010-1234-5678", company: "Munster company", image: UIImage(named: "leo"),email: "leonard@gmail.com")]

    override func viewDidLoad() {
        super.viewDidLoad()
        cardListTableView.delegate = self
        cardListTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardListCell

        let currentRowOfList = cardList[indexPath.row]
        cell.nameLabel.text = currentRowOfList.name
        cell.companyLabel.text = currentRowOfList.company
        cell.emailLabel.text = currentRowOfList.email
        cell.telLabel.text = currentRowOfList.tel
        cell.profileImageView.image = currentRowOfList.image
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 180
        return height
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
