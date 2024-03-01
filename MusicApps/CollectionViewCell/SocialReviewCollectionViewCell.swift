//
//  SocialReviewCollectionViewCell.swift
//  MovieApp
//
//  Created by Devank on 29/02/24.
//

import UIKit

class SocialReviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = img.frame.width / 2
        img.clipsToBounds = true
        // Initialization code
    }

}
