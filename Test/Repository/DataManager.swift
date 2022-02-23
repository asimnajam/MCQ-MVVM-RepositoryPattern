//
//  DataManager.swift
//  Test
//
//  Created by Admin on 16/02/2022.
//

import Foundation
import RealmSwift

protocol Persistable {}
extension Object: Persistable {}

protocol DatabaseManager {
    func create<T>(_ model: T, completion: @escaping (T) -> Void) where T: Persistable
    func save(object: Persistable)
    func fetch<T>(_ model: T.Type, completion: @escaping (T?) -> Void) where T: Persistable
    func fetchAll<T>(_ model: T.Type, completion: @escaping ([T]) -> Void) where T: Persistable
}

class RealmDataBaseManager: DatabaseManager {
    private let realm: Realm?
    
    init() {
        realm = try? Realm()
        print("Realm Database file: \(Realm.Configuration.defaultConfiguration.fileURL)")
    }
    
    func create<T>(_ model: T, completion: @escaping (T) -> Void) where T: Persistable {
        guard let realm = realm else {
            return
        }
        
        guard let object = model as? Object else {
            return
        }
        
        try? realm.write {
            realm.add(object, update: .all)
        }
    }
    
    
    
    func save(object: Persistable) {
        guard let realm = realm,
              let object = object as? Object else { return }
        
        try? realm.write {
            realm.add(object)
        }
    }
    
    func fetch<T>(_ model: T.Type, completion: @escaping (T?) -> Void) where T: Persistable {
        guard let realm = realm else {
            return
        }
        
        guard let object = model as? Object.Type else {
            return
        }
        
        let result = realm.objects(object).first
        let castedResult = result as? T
        completion(castedResult)
    }
    
    func fetchAll<T>(_ model: T.Type, completion: @escaping ([T]) -> Void) where T: Persistable {
        guard let realm = realm else {
            return
        }
        
        guard let object = model as? Object.Type else {
            return
        }
        
        let result = realm.objects(object)
        completion(Array(result).compactMap { $0 as? T })
    }
}
