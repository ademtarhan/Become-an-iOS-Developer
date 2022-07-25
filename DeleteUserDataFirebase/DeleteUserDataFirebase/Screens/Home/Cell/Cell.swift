//
//  Cell.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 21.07.2022.
//

import UIKit

class Cell: UITableViewCell {

    
    @IBOutlet weak var labelUID: UILabel!
    
    
    @IBOutlet weak var labelCellText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(data: DataModel){
        self.labelCellText.text = data.text
        self.labelUID.text = data.uid
    }
    
}