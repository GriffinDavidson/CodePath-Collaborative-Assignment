//
//  LoginViewController.swift
//  GymPal
//
//  Created by Spencer Steggell on 4/5/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    //MARK: Variables
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Action Functions
    
    @IBAction func onSignIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.emailTextField.text!, password: self.passwordTextField.text!) {
                  (user: PFUser?, error: Error?) -> Void in
                  if user != nil {
                      let defaults = UserDefaults.standard
                      defaults.set(user?.username, forKey: "userId")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                  } else {
                    self.displayAlert(withTitle: "Error", message: error!.localizedDescription)
                      print("Error: \(String(describing: error?.localizedDescription))")
                  }
                }
    }
    
    
    
    
    func displayAlert(withTitle title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    


}
