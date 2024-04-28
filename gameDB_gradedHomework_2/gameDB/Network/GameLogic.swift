//
//  GameLogic.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 21.04.2024.
//

import Foundation

final class GameLogic: GameLogicProtocol {
    
    static let shared: GameLogic = {
        let instance = GameLogic()
        return instance
    }()
    
    private init() {}
    
    func getAListOfAvaliableGames(completionHandler: @escaping (Result<AvaliableGames, any Error>) -> Void) {
        Webservice.shared.request(request: Router.avaliable, decodeToType: AvaliableGames.self, completionHandler: completionHandler)
    }
    
    func getGameDetails(completionHandler: @escaping (Result<GameDetails, any Error>) -> Void, gameId: Int) {
        Webservice.shared.request(request: Router.detail(gameID: gameId), decodeToType: GameDetails.self, completionHandler: completionHandler)
    }
    
    
}
