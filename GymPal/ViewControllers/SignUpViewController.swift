//
//  SignUpViewController.swift
//  GymPal
//
//  Created by Spencer Steggell on 4/5/22.
//

import UIKit
import Parse


class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var pronounsField: UITextField!
    @IBOutlet weak var aboutYouTextView: UITextView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var prefferedGymField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aboutYouTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.aboutYouTextView.layer.borderWidth = 0.5

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let defaults = UserDefaults.standard
        let user = PFUser()
            user.username = self.emailField.text
        defaults.set(user.username, forKey: "userId")
            user.password = self.passwordField.text
            user.signUpInBackground {(succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                self.displayAlert(withTitle: "Error", message: error.localizedDescription)
                print("Error: \(String(describing: error.localizedDescription))")
            } else {
                let defaultImage = UIImage(systemName: "face.smiling.fill")
                let defaultImageData = defaultImage?.pngData()
                let imageFile = PFFileObject(name: "image.png", data: defaultImageData!)
                let profile = PFObject(className: "Profiles")
                    profile["userName"] = user.username ?? ""
                    profile["age"] = self.ageField.text ?? ""
                    profile["prounouns"] = self.pronounsField.text ?? ""
                    profile["about"] = self.aboutYouTextView.text ?? ""
                    profile["firstName"] = self.firstNameField.text ?? ""
                    profile["lastName"] = self.lastNameField.text ?? ""
                    profile["profilePicture"] = imageFile
                    profile["prefferedGym"] = self.prefferedGymField.text ?? ""
                print("Profile before sign up", profile)
                profile.saveInBackground()
                self.performSegue(withIdentifier: "createAccountSegue", sender: nil)
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(withTitle title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    
}
