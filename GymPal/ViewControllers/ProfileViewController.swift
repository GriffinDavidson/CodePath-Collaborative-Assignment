//
//  ProfileViewController.swift
//  GymPal
//
//  Created by Nguyen, Khang on 4/12/22.
//

import UIKit
import AlamofireImage
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var fullNameTextLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ageTextLabel: UILabel!
    @IBOutlet weak var prefferedGymTextLabel: UILabel!
    @IBOutlet weak var pronounTextLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aboutTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.aboutTextView.layer.borderWidth = 0.5
        
        self.loadData();
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "userId")
        let query = PFQuery(className:"Profiles")
        print("userId", userName!)
        query.whereKey("userName", equalTo: userName!)
        query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
            if let error = error {
                // The query failed
                print(error.localizedDescription)
            } else if let object = object {
                // The query succeeded with a matching result
                let firstName = object["firstName"] as? String
                let lastName = object["lastName"] as? String
                let fullName = firstName! + " " + lastName!

                self.ageTextLabel.text = object["age"] as? String
                self.fullNameTextLabel.text = fullName
                self.aboutTextView.text = object["about"] as? String
                self.pronounTextLabel.text = object["prounouns"] as? String
                self.prefferedGymTextLabel.text = object["prefferedGym"] as? String
                print("object in ProfileViewController", object)
                let imageFile = object["profilePicture"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                self.profileImageView.af.setImage(withURL: url)
                
                
            } else {
                // The query succeeded but no matching result was found
                print("Nothing was found")
            }
        }
    }
    
    @IBAction func onRefresh(_ sender: Any) {
        loadData()
    }
}
