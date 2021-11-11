//
//  UserTableViewCell.swift
//  iOS-exam
//
//  Created by Amina Brenneng on 24/10/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var userImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
