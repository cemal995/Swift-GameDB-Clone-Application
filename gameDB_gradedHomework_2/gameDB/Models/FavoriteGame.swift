//
//  FavoriteGame.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 26.04.2024.
//

import Foundation

struct FavoriteGame: Encodable, Decodable, Equatable {
    let name: String?
    let released: String?
    let rating: Double?
    let backgroundImageURL: String?
}
