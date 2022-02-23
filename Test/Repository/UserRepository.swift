//
//  UserRepo.swift
//  Test
//
//  Created by Admin on 16/02/2022.
//

import Foundation

protocol UserRepository {
    func save(user: Questions)
    func save(answer: SelectedAnswer)
    func get(by id: Int, completion: @escaping (Question?) -> Void)
    func getAll(completion: @escaping ([Question]) -> Void)
    func getSelectedAnswer(by questionID: Int, completion: @escaping (Question?) -> Void)
    func getAllAnswers(compilation: @escaping ([SelectedAnswer]) -> Void)
}

final class UserRepositoryManager: UserRepository {
    private let databaseManager: DatabaseManager
    
    init(databaseManager: DatabaseManager = RealmDataBaseManager()) {
        self.databaseManager = databaseManager
    }
    
    func save(user: Questions) {
        databaseManager.create(user) { obj in
            print(obj)
        }
    }
    
    func save(answer: SelectedAnswer) {
        databaseManager.create(answer) { obj in
            print(obj)
        }
    }
    
    func get(by id: Int, completion: @escaping (Question?) -> Void) {
        databaseManager.fetchAll(Question.self) { objs in
            let obj = objs.first(where: { $0.id == id })
            completion(obj)
        }
    }
    
    func getAll(completion: @escaping ([Question]) -> Void) {
        databaseManager.fetchAll(Question.self) { objs in
            completion(objs)
        }
    }
    
    func getSelectedAnswer(by questionID: Int, completion: @escaping (Question?) -> Void) {
        databaseManager.fetchAll(SelectedAnswer.self) { [weak self] objs in
            guard let self = self,
            let question = objs.first(where: { $0.questionID == questionID }) else { return }
            self.get(by: question.questionID, completion: completion)
        }
    }
    
    func getAllAnswers(compilation: @escaping ([SelectedAnswer]) -> Void) {
        databaseManager.fetchAll(SelectedAnswer.self) { objs in
            compilation(objs)
        }
    }
}
