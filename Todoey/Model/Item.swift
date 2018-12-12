//
//  Item.swift
//  Todoey
//
//  Created by Federico Chiesa on 12/12/2018.
//  Copyright © 2018 Federico Chiesa. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable {
    init(_ itemName : String) {
        name = itemName
        done = false
    }
    var name : String
    var done : Bool
}
