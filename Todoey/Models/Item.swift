//
//  Item.swift
//  Todoey
//
//  Created by Rodrigo Maidana on 20/01/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

struct Item: Codable {
    var title: String = ""
    var done: Bool = false
    
    init(title: String, done: Bool){
        self.title = title
        self.done = done
    }
    
    init(title: String) {
        self.title = title
    }
}
