//
//  RealmManage.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RealmSwift

protocol CRUDType {
    associatedtype T
    func query(with predicate: String?) -> [T]
    func save(entity: T)
    func update(entity: T)
    func delete(entity: T)
}


final class RealmDBRepository<T: Object>: CRUDType {
    
    private let realm: Realm
    
    init(_ realm: Realm) {
        self.realm = realm
    }
    
    func query(with predicate: String?) -> [T] {
        let result = realm.objects(T.self)
        
        if let predicate = predicate {
            let predicate = NSPredicate(format: predicate)
            return result.filter(predicate).toArray()
        }
        
        return result.toArray()
    }
    
    func save(entity: T) {
        try? realm.write {
            realm.add(entity)
        }
    }
    
    func update(entity: T) {
        try? realm.write {
            realm.add(entity, update: .modified)
        }
    }
    
    func delete(entity: T) {
        try? realm.write {
            realm.delete(entity)
        }
    }
    
    
}
