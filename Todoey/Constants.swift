//
//  Constants.swift
//  Todoey
//
//  Created by Rodrigo Maidana on 23/01/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

struct K {
    static let goToItemsSegue = "goToItems"
    static let appName = "Todoey"
    static let trashIcon = "trash.fill"
    static let itemCellId = "ToDoItemCell"
    static let itemsViewTitle = "Items"
    static let categoryCellId = "CategoryCell"
    
    struct Database {
        static let databaseName = "TodoeyDB"
    }
    struct AddItem {
        static let alertTitle = "Add a new item"
        static let addButtonTitle = "Add"
        static let emptyItem = "Empty item"
        static let alertTextPlaceholder = "New item"
    }
    struct AddCategory {
        static let alertTitle = "Add a new category"
        static let addButtonTitle = "Add"
        static let alertTextPlaceholder = "New category"
        static let emptyCategory = "New Category"
    }
}
