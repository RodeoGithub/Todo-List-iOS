//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Rodrigo Maidana on 23/01/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoriesArray: [Category] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        
        loadCategories()
    }

    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellId, for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        
        return cell;
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToItemsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    // MARK: - Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: K.AddCategory.alertTitle, message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: K.AddCategory.addButtonTitle, style: .default) { (action) in
            if let categoryName = textField.text {
                let newCategory = Category(context: self.context)
                if categoryName != "" {
                    newCategory.name = categoryName
                }
                else {
                    newCategory.name = K.AddCategory.emptyCategory
                }
                self.categoriesArray.append(newCategory)
                self.saveCategories()
                self.tableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            return
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = K.AddCategory.alertTextPlaceholder
            textField = alertTextField
        }
        present(alert, animated: true)
    }
    
    // MARK: - Database
    
    func loadCategories() {
        do {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            let result = try context.fetch(request)
            categoriesArray = result
        }
        catch {
            print("\(error)")
        }
    }
    
    func saveCategories() {
        do{
            try context.save()
        }
        catch {
            print("\(error)")
        }
    }
    
    func deleteCategories() {
        // TODO: Implement delete category
    }
    
}
