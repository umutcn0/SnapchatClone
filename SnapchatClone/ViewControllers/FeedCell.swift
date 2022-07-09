//
//  FeedCell.swift
//  SnapchatClone
//
//  Created by Umut Can on 8.07.2022.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
