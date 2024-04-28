//
//  ViewController.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 21.04.2024.
//

import UIKit
import Kingfisher

protocol ViewControllerProtocol: AnyObject {
    func loadGameListCollectionView()
    func loadGameListTableView()
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var emptyView: UIView!
    
    var nowAvaliableList = [AvaliableGamesResults]()
    var imageUrls: [URL] = []
    var favoriteGames: [FavoriteGame] = []
    var filteredGames: [AvaliableGamesResults] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        GameLogic.shared.getAListOfAvaliableGames { [weak self] result in
            guard let self else { return }
            
            switch result {
                
            case .success(let games):
                self.nowAvaliableList = games.results ?? [AvaliableGamesResults]()
                self.filteredGames = self.nowAvaliableList
                self.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageUrls.removeAll()
        imageUrls.append(URL(string:"https://image.api.playstation.com/vulcan/ap/rnd/202312/0117/0b68ebf352db559cb45a75bd32fed3381f34dc52c5480192.png?w=5000&thumb=false")!)
        imageUrls.append(URL(string: "https://cdn1.epicgames.com/offer/c4763f236d08423eb47b4c3008779c84/EGS_AlanWake2_RemedyEntertainment_S1_2560x1440-ec44404c0b41bc457cb94cd72cf85872")!)
        imageUrls.append(URL(string: "https://cdn.cloudflare.steamstatic.com/steam/apps/1785650/header.jpg?t=1714105357")!)
        imageUrls.append(URL(string:"https://static.cdprojektred.com/cms.cdprojektred.com/16x9_big/fcaa0ba91e2368e2aef8c0d556692307768fad49-1280x720.jpg")!)
    
        for index in 0..<min(nowAvaliableList.count, 3) {
               if let backgroundImageUrlString = nowAvaliableList[index].backgroundImage,
                  let backgroundImageUrl = URL(string: backgroundImageUrlString) {
                   imageUrls.append(backgroundImageUrl)
               }
           }
        
        print("Number of image URLs: \(imageUrls.count)")
        
        setupTableView()
        setupCollectionView()
        setupSearchBar()
        setupEmptyView()
        updateEmptyViewVisibility()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateEmptyViewVisibility()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "gameCell")
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GameImageCell", bundle: nil), forCellWithReuseIdentifier: "gameImageCell")
       
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Games"
        
   
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
    }
    
    private func setupEmptyView() {
          emptyView = UIView()
          emptyView.backgroundColor = .clear
          view.addSubview(emptyView)
          emptyView.translatesAutoresizingMaskIntoConstraints = false

          let label = UILabel()
          label.text = "No game has been found. Please try again! "
          label.textAlignment = .center
          label.textColor = .black
          label.backgroundColor = .white
          label.font = UIFont.boldSystemFont(ofSize: 17)
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
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
               filteredGames = nowAvaliableList
           } else {
               filteredGames = nowAvaliableList.filter {
                   ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false)
               }
           }
           tableView.reloadData()
           updateEmptyViewVisibility()
    }
    
    func updateEmptyViewVisibility() {
           emptyView.isHidden = !filteredGames.isEmpty
       }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
        cell.configure(avaliableGames: filteredGames[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedGame = nowAvaliableList[indexPath.row]
            guard let gameID = selectedGame.id else {
                print("Game ID is nil")
                return
            }
        
            GameLogic.shared.getGameDetails(completionHandler: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let gameDetails):
                    
                    guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerIdentifier") as? DetailViewController else {
                        fatalError("Unable to instantiate DetailViewController from the storyboard.")
                    }
                    
                    detailVC.loadViewIfNeeded()
                    detailVC.configure(gameDetails: gameDetails)
                    detailVC.favoriteGames = self.favoriteGames 
                    detailVC.delegate = self
                    self.navigationController?.pushViewController(detailVC, animated: true)
                    
                case .failure(let error):
                    print("Failed to fetch game details: \(error.localizedDescription)")
                }
            }, gameId: gameID)
        }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameImageCell", for: indexPath) as? GameImageCell else {
            return UICollectionViewCell()
        }
        
        let url = imageUrls[indexPath.item]
        cell.gameImageView.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return collectionView.bounds.size
        }

}

extension ViewController: DetailViewControllerDelegate {
   func didSelectFavoriteGame(_ game: FavoriteGame) {
        
          if favoriteGames.firstIndex(where: { $0 == game }) == nil {
              favoriteGames.append(game)
              print("Favorite game added:", game)
              print("Updated favorite games array:", favoriteGames)
              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }
          }
      }
}


extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
}


extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterContentForSearchText("")
    }
}
    







