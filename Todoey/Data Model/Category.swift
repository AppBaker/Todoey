//
//  Category.swift
//  Todoey
//
//  Created by Ivan Nikitin on 12.03.2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
