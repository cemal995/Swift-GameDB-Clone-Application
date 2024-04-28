//
//  Router.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 21.04.2024.
//

import Alamofire
import Foundation

enum Router: URLRequestConvertible {
    case avaliable
    case detail(gameID: Int)
    
    private var gameID: Int? {
        switch self {
        case .detail(let id):
            return id
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
            
        case .avaliable, .detail:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
            
        case .avaliable, .detail:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var url: URL {
        switch self {
            
        case .avaliable:
            let url = URL(string: Constant.nowAvaliableURL)
            return url!
        case .detail:
            if let gameID = self.gameID {
                let urlString = "https://api.rawg.io/api/games/\(gameID)?key=f2786f0e6faa4bf7949c61025d2b7e38"
                return URL(string: urlString)!
            } else {
                fatalError("gameID is not set for detail case")
            }
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
}
