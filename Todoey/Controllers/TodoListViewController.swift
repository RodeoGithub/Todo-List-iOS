//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray: [Item] = []
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.itemsViewTitle
    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCellId, for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (deleteAction, view, success:(Bool)->Void) in
            self.deleteItem(at: indexPath)
            self.saveItems()
            self.tableView.reloadData()
            success(true)
        }
        
        deleteAction.image = UIImage(systemName: K.trashIcon)
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    //MARK: - Add Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: K.AddItem.alertTitle, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.AddItem.addButtonTitle, style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            if textField.text != nil && textField.text != "" {
                newItem.title = textField.text!
            }
            else {
                newItem.title = K.AddItem.emptyItem
            }
            newItem.normalizedTitle = newItem.title!.lowercased()
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = K.AddItem.alertTextPlaceholder
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Database
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), _ predicate: NSPredicate? = nil){
        do {
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            if let additionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                    categoryPredicate,
                    additionalPredicate
                ])
            }
            else {
                request.predicate = categoryPredicate
            }
            let result = try context.fetch(request)
            itemArray = result
        }
        catch {
            print("Error fetching data from Database. \(error)")
        }
    }
    
    func saveItems(){
        do {
            try context.save()
        }
        catch {
            print("Error saving data \(error)")
        }
    }
    
    func deleteItem(at indexPath: IndexPath){
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
    }
}

//MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == nil || searchBar.text == "" {
            loadItems()
            tableView.reloadData()
        }
        else {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            let normalizedSearch = searchBar.text!.lowercased()
            let predicate = NSPredicate(format: "normalizedTitle CONTAINS[cd] %@", normalizedSearch)
            
            loadItems(with: request, predicate)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
