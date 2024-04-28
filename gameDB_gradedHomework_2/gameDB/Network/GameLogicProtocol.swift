//
//  GameLogicProtocol.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 21.04.2024.
//

import Foundation

protocol GameLogicProtocol {
    func getAListOfAvaliableGames(completionHandler: @escaping (Result<AvaliableGames, Error>)-> Void)
    func getGameDetails(completionHandler: @escaping (Result<GameDetails, Error>)-> Void, gameId: Int)
}
