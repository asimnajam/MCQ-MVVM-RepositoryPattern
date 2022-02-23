//
//  URLRequest+Ext.swift
//  Test
//
//  Created by Admin on 21/02/2022.
//

import Foundation

extension URLRequest {
    static var baseURL: String = "https://raw.githubusercontent.com/asimnajam/JSON/main/"
    
    static func make(_ client: NetworkClientRequestable) -> URLRequest {
        var url: URL {
            var urlComponents = URLComponents(string: client.path)!
            urlComponents.queryItems = client.query.map { URLQueryItem(name: $0.key, value: $0.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) }
            let url = urlComponents.url(relativeTo: URL(string: baseURL)!)!
            return url
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = client.method.value
        request.httpBody = client.method.data
        
        for (key, value) in client.customHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
