//
//  WebService.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 21.04.2024.
//

import Alamofire
import Foundation

final class Webservice {
    
    static let shared: Webservice = {
        let instance = Webservice()
        return instance
    }()
    
    func request<T: Decodable>(request: URLRequestConvertible, decodeToType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(request).responseData { [weak self] response in
            guard let self else { return }
            
            switch response.result {
                
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(decodedData))
                } catch {
                    print("A json decode error has been occurred")
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
}
