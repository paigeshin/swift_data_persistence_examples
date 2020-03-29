//
//  Item.swift
//  RealmTodoListApp
//
//  Created by shin seunghyun on 2020/02/20.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory: LinkingObjects = LinkingObjects(fromType: Category.self, property: "items")
}


