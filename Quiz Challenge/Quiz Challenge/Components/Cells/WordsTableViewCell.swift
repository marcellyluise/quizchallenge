//
//  WordsTableViewCell.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 27/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

class WordsTableViewCell: UITableViewCell, CellIdentifieable {

    @IBOutlet private weak var wordLabel: UILabel!
    
    var word: String? = nil {
        didSet {
            wordLabel.text = word
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
