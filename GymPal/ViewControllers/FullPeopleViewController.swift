//
//  FullPeopleViewController.swift
//  GymPal
//
//  Created by Griffin Davidson on 4/15/22.
//

import UIKit

class FullPeopleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var allFriends: UICollectionView!
    let users = [User(name: "1"),
             User(name: "2"),
             User(name: "3"),
             User(name: "4"),
             User(name: "5"),
             User(name: "6"),
             User(name: "7"),
             User(name: "8"),
             User(name: "9")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "All Friends"
        allFriends.delegate = self
        allFriends.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = allFriends.dequeueReusableCell(withReuseIdentifier: "PeopleCollectionViewCell", for: indexPath) as? PeopleCollectionViewCell
        else
        {
            print("Failed to use PeoplCollectionViewCell (FullPeopleVC)!")
            return UICollectionViewCell()
        }
        
        cell.configure(with: users[indexPath.row])
        
        return cell
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
