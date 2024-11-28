import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // value = condition ? ifTrue : ifFalse
        cell.accessoryType = item.isCompleted ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //DELETE From DATABASE
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        //UPDATE PART
        //itemArray[indexPath.row].isCompleted = !itemArray[indexPath.row].isCompleted
        
        self.saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    // MARK- add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.isCompleted = false
            self.itemArray.append(newItem)
    
          //  self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK- Manipulation parts
    
    func saveItems(){
        
        do{
            try context.save()
        } catch {
            print("Error saving datas to database :(\(error))")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
            try itemArray = context.fetch(request)
        }catch{
            print("Error fetching data from database :(\(error))")
        }
        
    }

}

