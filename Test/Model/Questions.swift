//
//  Questions.swift
//  Test
//
//  Created by Admin on 21/02/2022.
//

import Foundation
import RealmSwift

final class Answer: Object, Decodable {
    @Persisted var title: String
    @Persisted var correct: Bool
}

final class Question: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var query: String
    @Persisted var answers: List<Answer> // List of answers (always 4)
}

final class Questions: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var questions: List<Question>
}

class SelectedAnswer: Object {
    @Persisted(primaryKey: true) var questionID: Int
    @Persisted var answerIndex: Int
    @Persisted var isCorrectAnswer: Bool
    
    convenience init(_ questionID: Int, _ answerIndex: Int, _ isCorrectAnswer: Bool) {
        self.init()
        self.questionID = questionID
        self.answerIndex = answerIndex
        self.isCorrectAnswer = isCorrectAnswer
    }
}
