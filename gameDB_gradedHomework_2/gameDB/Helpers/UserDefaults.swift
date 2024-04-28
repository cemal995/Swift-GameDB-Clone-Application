//
//  UserDefaults.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 27.04.2024.
//

import Foundation


func saveFavoriteGames(_ games: [FavoriteGame]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(games) {
        UserDefaults.standard.set(encoded, forKey: "FavoriteGames")
    }
}

func loadFavoriteGames() -> [FavoriteGame] {
    if let savedGames = UserDefaults.standard.data(forKey: "FavoriteGames") {
        let decoder = JSONDecoder()
        if let loadedGames = try? decoder.decode([FavoriteGame].self, from: savedGames) {
            return loadedGames
        }
    }
    return []
}

func deleteFavoriteGame(at index: Int) {
    var favoriteGames = loadFavoriteGames()
    favoriteGames.remove(at: index)
    saveFavoriteGames(favoriteGames)
}

func addFavoriteGame(_ game: FavoriteGame) {
    var favoriteGames = loadFavoriteGames()
    favoriteGames.append(game)
    saveFavoriteGames(favoriteGames)
}
