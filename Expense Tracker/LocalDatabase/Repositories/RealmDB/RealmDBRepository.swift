//
//  RealmManage.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RealmSwift
import RxSwift

protocol CRUDType {
    associatedtype T
    func query(with predicate: String?) -> Single<[T]>
    func save(entity: T) -> Completable
    func update(entity: T) -> Completable
    func delete(entity: T) -> Completable
}


final class RealmDBRepository<T: Object>: CRUDType {
        
    private let realm: Realm
    
    init(_ realm: Realm) {
        self.realm = realm
    }
    
    func query(with predicate: String?) -> Single<[T]> {
        return Single<[T]>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            var result: Results<T> = self.realm.objects(T.self)
            
            if let predicate = predicate, !predicate.isEmpty {
                let predicate = NSPredicate(format: predicate)
                result = result.filter(predicate)
            }
            
            observer(.success(result.toArray()))
            
            return Disposables.create {}
        }
    }
    
    func save(entity: T) -> Completable {
        return Completable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            try? self.realm.write {
                self.realm.add(entity)
                observer(.completed)
            }
            return Disposables.create {}
        }
    }
    
    func update(entity: T) -> Completable {
        return Completable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            try? self.realm.write {
                self.realm.add(entity, update: .modified)
                observer(.completed)
            }
            return Disposables.create {}
        }
    }
    
    func delete(entity: T) -> Completable {
        return Completable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            try? self.realm.write {
                self.realm.delete(entity)
                observer(.completed)
            }
            return Disposables.create {}
        }
    }
    
}
