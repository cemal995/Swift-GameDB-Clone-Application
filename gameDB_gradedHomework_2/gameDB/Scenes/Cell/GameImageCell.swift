//
//  GameImageCell.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 24.04.2024.
//

import UIKit

class GameImageCell: UICollectionViewCell {

    @IBOutlet weak var gameImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gameImageView.contentMode = .scaleAspectFill
        gameImageView.clipsToBounds = true
    }
}
