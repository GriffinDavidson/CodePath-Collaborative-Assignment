//
//  UsersViewController.swift
//  GymPal
//
//  Created by BRIAN BETANCOURT on 4/15/22.
//

import UIKit
import AlamofireImage
import Parse

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // users is an array of PF objects
    var users = [PFObject]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows
        return users.count
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Profiles")
        // filter goes here when necessary (query.whereKey())
//        query.includeKey("firstName")
        query.findObjectsInBackground{(users, error) in
            if users != nil {
                self.users = users!
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // for each row, cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        print("made it here")
        print(user.object(forKey: "about"))
//        let about = user.object(forKey: "userName")
//        print("ths is about \(about)")
        
//        let firstName = user["firstName"]
        let userName = user["userName"]
        let firstName = user["firstName"]
        
        cell.nameLabel.text = firstName as! String
        cell.usernameLabel.text = userName as! String
        
        let imageFile = user["profilePicture"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)
        
        cell.photoView.af.setImage(withURL: url!)
        
        
        return cell
        
        
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // retrieve big list of users and store in a variable
    
//    func loadData() {
//        let defaults = UserDefaults.standard
//        let userName = defaults.string(forKey: "userId")
//        let query = PFQuery(className:"Profiles")
//        print("userId", userName!)
//        query.whereKey("userName", equalTo: userName!)
//        query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
//            if let error = error {
//                // The query failed
//                print(error.localizedDescription)
//            } else if let object = object {
//                // The query succeeded with a matching result
//                let firstName = object["firstName"] as? String
//                let lastName = object["lastName"] as? String
//                let fullName = firstName! + " " + lastName!
//
//                self.ageTextLabel.text = object["age"] as? String
//                self.fullNameTextLabel.text = fullName
//                self.aboutTextView.text = object["about"] as? String
//                self.pronounTextLabel.text = object["prounouns"] as? String
//                self.prefferedGymTextLabel.text = object["prefferedGym"] as? String
//                print("object in ProfileViewController", object)
//                let imageFile = object["profilePicture"] as! PFFileObject
//                let urlString = imageFile.url!
//                let url = URL(string: urlString)!
//                self.profileImageView.af.setImage(withURL: url)
//
//
//            } else {
//                // The query succeeded but no matching result was found
//                print("Nothing was found")
//            }
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
