//
//  SocialDecisionCollectionViewCell.swift
//  MovieApp
//
//  Created by Devank on 29/02/24.
//

import UIKit

class SocialDecisionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = img.frame.width / 2
        img.clipsToBounds = true
        
        img1.layer.cornerRadius = img1.frame.width / 2
        img1.clipsToBounds = true
        
    }

}
