//
//  TableViewCell.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 25.07.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelUID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setdata(data: DataModel){
        self.labelUID.text = data.uID
        self.labelText.text = data.postText
    }
    
    
}
