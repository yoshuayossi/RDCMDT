//
//  TransactionTableViewCell.swift
//  homework
//
//  Created by MACPRO-ITAPL on 02/05/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPayees: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAccNo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
