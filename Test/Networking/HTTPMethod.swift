//
//  HTTPMethod.swift
//  Test
//
//  Created by Asim Najam on 2/14/22.
//

import Foundation
import RealmSwift

enum HTTPMethod {
    case get
    case delete
    case post(data: Data)
    case put(data: Data)
    
    var value: String {
        switch self {
        case .get: return "Get"
        case .delete: return "Delete"
        case .post: return "Post"
        case .put: return "Put"
        }
    }
    
    var data: Data? {
        switch self {
        case .get, .delete:
            return nil
        case let .post(data), let .put(data):
            return data
        }
    }
}

struct Model: Decodable {
    
}

protocol FetchLiveProtocol {
    func fetch(success: @escaping (Model) -> Void, failure: @escaping (Error) -> Void)
}

class FetchLive: FetchLiveProtocol {
    let handler = Handler()
    func fetch(success: @escaping (Model) -> Void, failure: @escaping (Error) -> Void) {
        let client = NetworkClient(path: "", query: [:], customHeaders: [:], method: .get)
        handler.performRequest(
            client,
            model: Model.self,
            success: success,
            failure: failure
        )
    }
}
