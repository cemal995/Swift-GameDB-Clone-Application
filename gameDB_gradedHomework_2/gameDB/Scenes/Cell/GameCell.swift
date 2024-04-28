//
//  GameCell.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 24.04.2024.
//

import UIKit
import Kingfisher

class GameCell: UITableViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameReleaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    func configure(avaliableGames: AvaliableGamesResults) {
        gameNameLabel.text = avaliableGames.name
        if let rating = avaliableGames.rating {
            gameRatingLabel.text = String(rating)
        } else {
            gameRatingLabel.text = "N/A"
        }
        gameReleaseDateLabel.text = avaliableGames.released
        guard let url = URL(string: avaliableGames.backgroundImage ?? "") else {return}
        gameImageView.kf.setImage(with:url )
    }
    
    func configureFavoriteGame(FavoriteGame: FavoriteGame) {
        gameNameLabel.text = FavoriteGame.name
        if let rating = FavoriteGame.rating {
            gameRatingLabel.text = String(rating)
        } else {
            gameRatingLabel.text = "N/A"
        }
        gameReleaseDateLabel.text = FavoriteGame.released
        guard let url = URL(string: FavoriteGame.backgroundImageURL ?? "") else {return}
        gameImageView.kf.setImage(with:url )
    }
    
}


