//
//  PeopleCollectionViewCell.swift
//  GymPal
//
//  Created by Griffin Davidson on 4/14/22.
//

import UIKit

class PeopleCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(with user: User)
    {
        nameLabel.text = user.name
    }
}
