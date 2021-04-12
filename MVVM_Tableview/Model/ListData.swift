//
//  ListData.swift
//  MVVM_Tableview
//
//  Created by Rajeswari on 13/04/21.
//

import Foundation
import RealmSwift

class ListData: Decodable {
    
    let full_name: String?
    let name: String?
    let discription: String?
    let forks: Int?
    let watchers: Int?
    let language: String?
}

@objcMembers class List: Object {
    dynamic var full_name = String()
    dynamic var name = String()
    dynamic var discription = String()
    dynamic var forks = Int()
    dynamic var watchers = Int()
    dynamic var language = String()
}
