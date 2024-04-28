//
//  Constants.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 21.04.2024.
//

import Foundation

struct Constant {
    static let apiKey: String = "f2786f0e6faa4bf7949c61025d2b7e38"
    static let baseURL: String = "https://api.rawg.io"
    static let nowAvaliableURL: String = baseURL + "/api/games?key=" + apiKey
    static let gameDetailURL: String = baseURL + "/api/games/" + "?key" + apiKey
}
