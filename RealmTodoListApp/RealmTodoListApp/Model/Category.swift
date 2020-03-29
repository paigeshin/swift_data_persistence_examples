//
//  Category.swift
//  RealmTodoListApp
//
//  Created by shin seunghyun on 2020/02/20.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexColor: String = ""
    
    //relationship
    let items: List<Item> = List<Item>()
}
