//
//  DetailViewController.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 24.04.2024.
//

import UIKit
import Kingfisher

protocol DetailViewControllerDelegate: AnyObject {
    func didSelectFavoriteGame(_ game: FavoriteGame)
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameOfGameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var metacriticRateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var favoriteGame: FavoriteGame?
    var favoriteGames: [FavoriteGame] = []
    var backgroundImageURL: URL?
    
    weak var delegate: DetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteGames = loadFavoriteGames()
    }
    
    func configure(gameDetails: GameDetails) {
        if let rating = gameDetails.metacritic {
            let ratingText = String(rating)
            metacriticRateLabel.text = ratingText
        } else {
            metacriticRateLabel.text = "N/A"
        }
        
        nameOfGameLabel.text = gameDetails.name
        releaseDateLabel.text = gameDetails.released
        descriptionTextView.text = gameDetails.description
        
        if let backgroundImageURLString = gameDetails.backgroundImage, let url = URL(string: backgroundImageURLString) {
            gameImageView.kf.setImage(with: url)
            backgroundImageURL = url
        } else {
            gameImageView.image = UIImage(named: "placeholder_image")
        }
    }
    
    @IBAction func favoritesButtonTapped(_ sender: UIButton) {
        guard let backgroundImageURL = backgroundImageURL else {
                print("No background image URL available.")
                return
            }
        
            let game = FavoriteGame(name: nameOfGameLabel.text ?? "",
                                    released: releaseDateLabel.text ?? "",
                                    rating: Double(metacriticRateLabel.text ?? "") ?? 0,
                                    backgroundImageURL: backgroundImageURL.absoluteString)
    
            delegate?.didSelectFavoriteGame(game)
            addFavoriteGame(game)
    
            if let storyboard = storyboard, let favoritesVC = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController {
                navigationController?.pushViewController(favoritesVC, animated: true)
            }
        }
    
}
