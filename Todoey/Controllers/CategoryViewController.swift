//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anıl Karacan on 2.12.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.rowHeight = 80.0
    }
    //MARK: -Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        // value = condition ? ifTrue : ifFalse
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            

            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
    
          //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveCategory()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Manipulation parts
    
    func saveCategory() {
        do{
            try context.save()
        } catch{
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        let request: NSFetchRequest<Category>  = Category.fetchRequest()
        
        do{
            try categoryArray = context.fetch(request)
        }catch{
            print("Error fetching categories: \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
                    // Silinecek kategoriyi al
                    let categoryToDelete = self.categoryArray[indexPath.row]
                    
                    // Core Data'dan sil
                    self.context.delete(categoryToDelete)
                    self.categoryArray.remove(at: indexPath.row)
                    
                    do {
                       try self.context.save()
                   } catch {
                       print("Error deleting category: \(error)")
                   }
                   
                   // TableView'i güncelle
                   tableView.deleteRows(at: [indexPath], with: .automatic)
                   completionHandler(true)
                }
                deleteAction.image = UIImage(systemName: "trash")
                deleteAction.backgroundColor = .red
        
                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
                return configuration
    }
    
}
