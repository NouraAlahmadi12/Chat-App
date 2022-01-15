//
//  ListOfContactsPage.swift
//  Chat-ApppChellenge
//
//  Created by Noura Alahmadi on 11/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
class ListOfContactsPage: UIViewController {

    var contactsArr: [ListOfUser] = []
    
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    
    @IBAction func signOutAction(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }catch{
            debugPrint(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUsers()
    }
    
    func getUsers(){
        let db = Firestore.firestore()
        db.collection("Users").getDocuments { snapShot, error in
            guard let data = snapShot?.documents else{return}
            self.contactsArr.removeAll()
            for doucment in data{
                let name = doucment.get("Name User") as! String
                let user = ListOfUser(userName: name)
                self.contactsArr.append(user)
                print("the user data is \(user)")
            }
            self.contactTableView.reloadData()
        }
    }
          
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        contactTableView.delegate = self
        contactTableView.dataSource = self
    }
}




extension ListOfContactsPage:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactsCell
        cell.userNamelabel.text = contactsArr[indexPath.row].userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "ChatPageVC")) as! ChatPageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}