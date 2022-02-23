//
//  JSONParser.swift
//  Test
//
//  Created by Admin on 21/02/2022.
//

import Foundation

//extension<T: ProtocolA> T: ProtocolB
final class Parsable {}

extension Decodable where Self: Parsable {}

protocol JSONParsable {
    func parse<T>(data: Data, model: T.Type) throws -> T where T: Decodable
}

class JSONParser: JSONParsable {
    private let decoder = JSONDecoder()
    
    func parse<T>(data: Data, model: T.Type) throws -> T where T: Decodable {
        return try decoder.decode(T.self, from: data)
    }
}
