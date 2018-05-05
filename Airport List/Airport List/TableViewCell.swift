//
//  TableViewCell.swift
//  Airport List
//
//  Created by hortune on 2018/5/5.
//  Copyright © 2018年 hortune. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var airportName: UILabel!
    @IBOutlet weak var iata: UILabel!
    @IBOutlet weak var city: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
