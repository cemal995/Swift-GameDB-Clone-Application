//
//  FavoritesViewController.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 26.04.2024.
//
import UIKit
import Kingfisher
import UIKit

 class FavoritesViewController: UIViewController {
     @IBOutlet weak var tableView: UITableView!
     var emptyView: UIView!

     var favoriteGames: [FavoriteGame] = []

     override func viewDidLoad() {
         super.viewDidLoad()

         tableViewSetup()
         setupEmptyView()
         reloadData()
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)

         favoriteGames = loadFavoriteGames()
         updateEmptyViewVisibility()
         reloadData()
     }

     private func tableViewSetup() {
         tableView.delegate = self
         tableView.dataSource = self
         tableView.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "gameCell")
     }

     private func setupEmptyView() {
         emptyView = UIView()
         emptyView.backgroundColor = .clear
         view.addSubview(emptyView)
         emptyView.translatesAutoresizingMaskIntoConstraints = false

         let label = UILabel()
         label.text = "No favorite games has been found."
         label.textAlignment = .center
         label.textColor = .black
         label.backgroundColor = .white
         label.font = UIFont.boldSystemFont(ofSize: 17) // Bold font
         label.translatesAutoresizingMaskIntoConstraints = false
         emptyView.addSubview(label)

         NSLayoutConstraint.activate([
             label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
             label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor)
         ])

         NSLayoutConstraint.activate([
             emptyView.topAnchor.constraint(equalTo: view.topAnchor),
             emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])

         emptyView.isHidden = true
     }

     func reloadData() {
         tableView.reloadData()
     }

     func updateEmptyViewVisibility() {
         emptyView.isHidden = !favoriteGames.isEmpty
     }

 }

 extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return favoriteGames.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
         let game = favoriteGames[indexPath.row]
         cell.configureFavoriteGame(FavoriteGame: game)
         return cell
     }

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         
         if editingStyle == .delete {
             favoriteGames.remove(at: indexPath.row)
             updateEmptyViewVisibility() 
             tableView.deleteRows(at: [indexPath], with: .fade)
             saveFavoriteGames(favoriteGames)
         }
     }
 }

 extension FavoritesViewController: DetailViewControllerDelegate {
     func didSelectFavoriteGame(_ game: FavoriteGame) {
         favoriteGames.append(game)
         updateEmptyViewVisibility() 
         tableView.reloadData()
         }
 }


