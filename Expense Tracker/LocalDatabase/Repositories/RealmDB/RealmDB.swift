//
//  RealmDB.swift
//  Expense Tracker
//
//  Created by Lucio on 04/08/2022.
//

import Foundation
import RealmSwift

final class RealmDB {
    
    lazy var realm: Realm = {
        var configuration = Realm.Configuration(
            schemaVersion: 1
        )
        #if DEBUG
            configuration.deleteRealmIfMigrationNeeded = true
        #endif
        do {
            let realm = try Realm(configuration: configuration)
            return realm
        } catch let error {
            fatalError("Could not get realm: \(error)")
        }
    }()
    
}
