//
//  QuestionNetworkService.swift
//  Test
//
//  Created by Admin on 21/02/2022.
//

import Foundation

protocol QuestionFetchable {
    func fetch(success: @escaping (Questions?) -> Void, failure: @escaping (Error) -> Void)
}

final class QuestionService: QuestionFetchable {
    private let handler = Handler()
    
    func fetch(success: @escaping (Questions?) -> Void, failure: @escaping (Error) -> Void) {
        let request = NetworkClient(
            path: "MCQ.json",
//                "monishsyed/7d38bbe2e512ccc2c3708168b99ff5e5/raw/6a967af106fc951979342a4a7bbdb45d8aedc845/SwiftChallenge.json",
            query: [:],
            customHeaders: [:],
            method: .get
        )
        handler.performRequest(
            request,
            model: Questions.self,
            success: success,
            failure: failure
        )
    }
}
