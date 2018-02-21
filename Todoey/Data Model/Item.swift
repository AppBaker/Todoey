//
//  Item.swift
//  Todoey
//
//  Created by Ivan Nikitin on 16.02.2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

class Item : Codable {
    
    var item : String
    var done : Bool = false
    
    init(item: String) {
        self.item = item
    }
    
}
