//
//  HomeTableViewCell.swift
//  Czech for Travel
//
//  Created by Jan Polzer on 5/29/19.
//  Copyright © 2019 Apps KC. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            self.backgroundColor = UIColor.black
        } else {
            self.backgroundColor = UIColor.darkGray
        }
    }

    func configureCell(category: Category) {
        
        self.backgroundColor = UIColor.darkGray
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.selectionStyle = .none
        
        if let image = UIImage(named: category.imageFileName ?? "ic_phrases") {
            categoryImageView.image = image
        }
       
        categoryLabel.text = category.name
        categoryLabel.textColor = UIColor.lightText
    }
}

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        
        return widthRatio
    }
}
