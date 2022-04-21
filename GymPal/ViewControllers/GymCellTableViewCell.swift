//
//  GymCellTableViewCell.swift
//  GymPal
//
//  Created by Spencer Steggell on 4/18/22.
//

import UIKit

class GymCellTableViewCell: UITableViewCell {

    @IBOutlet weak var gymName: UILabel!
    @IBOutlet weak var gymAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
