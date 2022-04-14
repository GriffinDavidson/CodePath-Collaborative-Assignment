//
//  EditProfileViewController.swift
//  GymPal
//
//  Created by Nguyen, Khang on 4/12/22.
//

import UIKit
import AlamofireImage
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var pronounsTextField: UITextField!
    @IBOutlet weak var prefferedGymTextField: UITextField!
    @IBOutlet weak var aboutYouTextField: UITextView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "userId")
        let query = PFQuery(className:"Profiles")
        print("userId", userName!)
        query.whereKey("userName", equalTo: userName!)
        query.getFirstObjectInBackground { [self] (object: PFObject?, error: Error?) in
            if let error = error {
                // The query failed
                print(error.localizedDescription)
            } else if let object = object {
                // The query succeeded with a matching result
                print("object in Edit Profile", object)
                self.ageTextField.text = object["age"] as? String
                self.pronounsTextField.text = object["prounouns"] as? String
                self.aboutYouTextField.text = object["about"] as? String
                self.prefferedGymTextField.text = object["prefferedGym"] as? String
                let imageFile = object["profilePicture"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                self.profilePictureImageView.af.setImage(withURL: url)
                
            } else {
                // The query succeeded but no matching result was found
                print("Nothing was found")
            }
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onSubmit(_ sender: Any) {
        print("aaaaa")
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
                
                object["age"] = self.ageTextField.text ?? ""
                object["prounouns"] = self.pronounsTextField.text ?? ""
                object["about"] = self.aboutYouTextField.text ?? ""
                object["prefferedGym"] = self.prefferedGymTextField.text ?? ""
                let imageData = self.profilePictureImageView.image!.pngData()
                let file = PFFileObject(name: "image.png", data: imageData!)
                object["profilePicture"] = file
                object.saveInBackground {(success, error) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                        print("saved!")
                    } else {
                        print("error!")
                    }
                }
            } else {
                // The query succeeded but no matching result was found
                print("Nothing was found")
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onProfilePicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        profilePictureImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
    }
}
