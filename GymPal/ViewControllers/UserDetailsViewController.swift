//
//  UserDetailsViewController.swift
//  GymPal
//
//  Created by BRIAN BETANCOURT on 4/15/22.
//

import UIKit
import AlamofireImage
import Parse

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var ageTextLabel: UILabel!
    @IBOutlet weak var fullNameTextLabel: UILabel!
    
    @IBOutlet weak var prefferedGymTextLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var pronounTextLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var user:PFObject?
    
    
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
//        let userName = user?["userName"]
        self.ageTextLabel.text = user?["age"] as! String
        self.fullNameTextLabel.text = user?["firstName"] as! String
        self.aboutTextView.text = user?["about"] as? String
        self.pronounTextLabel.text = user?["prounouns"] as? String
        self.prefferedGymTextLabel.text = user?["prefferedGym"] as? String
        let imageFile = user?["profilePicture"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        self.profileImageView.af.setImage(withURL: url)
                
                
           
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


