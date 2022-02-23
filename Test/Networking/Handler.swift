//
//  Handler.swift
//  Test
//
//  Created by Admin on 16/02/2022.
//

import Foundation
import RealmSwift

final class Handler {
    private let networking: NetworkSessionable
    private let parser: JSONParsable
    
    init(networking: NetworkSessionable = Networking(), parser: JSONParsable = JSONParser()) {
        self.networking = networking
        self.parser = parser
    }
    
    func performRequest<T: Decodable>(_ client: NetworkClientRequestable, model: T.Type, success: @escaping (T) -> Void, failure: @escaping (Error) -> Void) {
        networking.perform(client) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                if let parsedData = try? self.parser.parse(data: data, model: model) {
                    success(parsedData)
                } else {
                    failure(CustomError.parsingError)
                }
            case let .failure(error):
                failure(error)
            }
        }
    }
}
