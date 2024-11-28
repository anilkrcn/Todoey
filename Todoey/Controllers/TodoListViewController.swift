import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        
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
        
        itemArray[indexPath.row].isCompleted = !itemArray[indexPath.row].isCompleted
        
        self.saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    // MARK- add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
    
          //  self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
            
            let encoder = PropertyListEncoder()
            do{
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("Error encoding array, error:\(error)")
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding array, error:\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        let decoder = PropertyListDecoder()
        let data = try? Data(contentsOf: dataFilePath!)
        if let items = try? decoder.decode([Item].self, from: data!) {
            itemArray = items
        }
        
    }

}

