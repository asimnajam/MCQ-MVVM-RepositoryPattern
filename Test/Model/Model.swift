//
//  Model.swift
//  Test
//
//  Created by Admin on 15/02/2022.
//

import Foundation
import RealmSwift

class QuestionRealmModel: Object {
    @Persisted(primaryKey: true) var questionNumber: Int
    @Persisted var question: String = ""
    @Persisted var answers = List<String>()
    @Persisted var options = List<String>()
    @Persisted var userSelectedOptions = List<String>()
    
    var isMultipleChoiceQuestion: Bool {
        answers.count > 1
    }
    
    convenience init(questionNumber: Int, question: String, answers: [String], options: [String], userSelectedOptions: [String]) {
        self.init()
        self.questionNumber = questionNumber
        self.question = question
        self.answers.append(objectsIn: answers)
        self.options.append(objectsIn: options)
        self.userSelectedOptions.append(objectsIn: userSelectedOptions)
    }
}
