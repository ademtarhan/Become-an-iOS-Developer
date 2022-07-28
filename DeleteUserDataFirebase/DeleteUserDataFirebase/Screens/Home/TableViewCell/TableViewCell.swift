//
//  TableViewCell.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 25.07.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var labelText: UILabel!
    @IBOutlet var labelUID: UILabel!

    @IBOutlet var imagePost: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setdata(data: DataModel) {
        labelUID.text = data.uID
        labelText.text = data.postText
        load(url: URL(string: data.imageURL) ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/deleteuserdatafirebase.appspot.com/o/images%2Fplaceholder.png?alt=media&token=a096e103-374a-4ed3-9a3a-b94013acf98c")!)
    }

    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imagePost.image = image
                    }
                }
            }
        }
    }
}
