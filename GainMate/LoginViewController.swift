//
//  LoginViewController.swift
//  GainMate
//
//  Created by Griffin Davidson on 4/6/22.
//

import UIKit
import Parse
import AlamofireImage

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Welcome!"
        navigationController?.navigationBar.prefersLargeTitles = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: Any)
    {
        //Pushes to secondary onboarding screen from Wireframe
        // moves to homeView afterwards
        if (!usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty)
        {
            let user = PFUser()
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            
            user.signUpInBackground
            { (success, error) in
                if success
                {
                    self.performSegue(withIdentifier: "onSignUp", sender: nil)
                    self.usernameTextField.text = nil
                    self.passwordTextField.text = nil
                }
                else
                {
                    print("Error signing up!\nERROR: \(error?.localizedDescription ?? "unable to print error")")
                }
            }
        }
    }
    
    @IBAction func onLogin(_ sender: Any)
    {
        // pushes to homeView
        if (!usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty)
        {
            let username = usernameTextField.text!
            let password = passwordTextField.text!
            
            PFUser.logInWithUsername(inBackground: username, password: password)
            { (user, error) in
                if user != nil
                {
                    self.performSegue(withIdentifier: "onLogin", sender: nil)
                    self.usernameTextField.text = nil
                    self.passwordTextField.text = nil
                }
                else
                {
                    print("Error loging in!\nERROR: \(error?.localizedDescription ?? "unable to print error")")
                }
            }
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

}
