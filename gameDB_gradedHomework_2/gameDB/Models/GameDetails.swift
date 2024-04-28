//
//  GameDetail.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 25.04.2024.
//

struct GameDetails: Codable {
    let name: String?
    let metacritic: Int?
    let released: String?
    let description: String?
    let backgroundImage: String?
    
    enum CodingKeys: String, CodingKey {
        case name, metacritic, released, description
        case backgroundImage = "background_image"
    }
}
