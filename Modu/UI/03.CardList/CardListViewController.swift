//
//  CardListViewController.swift
//  Modu
//
//  Created by 우민지 on 2021/11/09.
//

import UIKit
var cardList: [Card] = [Card(name: "라이언", tel: "010-3333-4444", company: "카카오", image: UIImage(named: "ryan"), email: "ryan@kakao.com"),
                        Card(name: "춘식이", tel: "010-3333-3333", company: "카카오", image: UIImage(named: "chun"), email: "chunsik@kakao.com")]

class CardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // add new contract
    @IBAction func addBtn(_ sender: Any) {
        
    }

    
    
    @IBOutlet var cardListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cardListTableView.delegate = self
        cardListTableView.dataSource = self
    }

    // 뷰가 노출될 때마다 리스트의 데이터를 다시 불러옴
    override func viewWillAppear(_ animated: Bool) {
        cardListTableView.reloadData()
    }

    // tableview 섹션은 하나로 정함 !
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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

    // 목록 삭제 함수

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete the row from the data source
            cardList.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // create a new instance to add a new row in tableview
        }
    }

    // 삭제 할 때 delete 대신 한글로 삭제라고 표시한다.
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cardDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = cardListTableView.indexPath(for: cell)
            let detailView = segue.destination as! DetailInfoVC
            detailView.receiveData(cardList[((indexPath as NSIndexPath?)?.row)!])
        }
    }
}
