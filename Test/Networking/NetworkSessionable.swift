//
//  NetworkSessionable.swift
//  Test
//
//  Created by Admin on 21/02/2022.
//

import Foundation

enum CustomError: Error {
    case noData
    case parsingError
}

protocol NetworkSessionable {
    var session: URLSession { get }
    func perform(_ client: NetworkClientRequestable, completion: @escaping (Result<Data, Error>) -> Void)
}

final class Networking: NetworkSessionable {
    let session = URLSession.shared
    
    func perform(_ client: NetworkClientRequestable, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest.make(client)
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    if let data = data {
                        completion(.success(data))
                    } else {
                        completion(.failure(CustomError.noData))
                    }
                    
                default:
                    guard let error = error else { return }
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
