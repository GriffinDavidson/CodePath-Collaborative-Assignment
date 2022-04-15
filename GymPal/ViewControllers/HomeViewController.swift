//
//  HomeViewController.swift
//  GymPal
//
//  Created by Griffin Davidson on 4/14/22.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    
    var users = [User]()
    {
        didSet
        {
            peopleCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "GymPal"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        peopleCollectionView.delegate = self
        peopleCollectionView.dataSource = self

        users = [User(name: "1"),
                 User(name: "2"),
                 User(name: "3"),
                 User(name: "4"),
                 User(name: "5"),
                 User(name: "6"),
                 User(name: "7"),
                 User(name: "8"),
                 User(name: "9")]
        // Do any additional setup after loading the view.
        
//        let layout = peopleCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumLineSpacing = 5
//        layout.minimumInteritemSpacing = 0
//
//        let width = (view.frame.width - layout.minimumInteritemSpacing * 2) / 2
//        layout.itemSize = CGSize(width: width, height: 3 / 2 * width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if (indexPath.row < users.count && indexPath.row < 7)
        {
            guard let cell = peopleCollectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCollectionViewCell", for: indexPath) as? PeopleCollectionViewCell
            else
            {
                print("Error! Returned Normal Cell!")
                return UICollectionViewCell()
            }
            
            cell.configure(with: users[indexPath.row])
            
            return cell
        }
        else
        {
            guard let cell = peopleCollectionView.dequeueReusableCell(withReuseIdentifier: "ToFullPeopleCollectionViewCell", for: indexPath) as? ToFullPeopleCollectionViewCell
            else
            {
                print("Error! Returned Normal Cell! (Load More Cell)")
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (users.count > 8 ? 8 : users.count)
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
