//
//  HTTPClient.swift
//  Test
//
//  Created by Admin on 21/02/2022.
//

import Foundation

protocol NetworkClientRequestable {
    var path: String { get }
    var query: [String: String] { get }
    var customHeaders: [String: String] { get }
    var method: HTTPMethod { get }
}

struct NetworkClient: NetworkClientRequestable {
    let path: String
    let query: [String : String]
    let customHeaders: [String : String]
    let method: HTTPMethod
}
