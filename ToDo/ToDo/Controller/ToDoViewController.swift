//
//  ViewController.swift
//  ToDo
// save data using user defaults
// save data using Ns coder - codable
// using core data - setup, create, read, update, destroy "CRUD"
//



import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
 var itemArray = [item]()
 //let defaults = UserDefaults.standard
    
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category?{
        didSet{
            loadData()
        }
    
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        

    }
    
    //MARK: - tableView Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        //cell.accessoryType = item.done == True ? .checkmark : .none
        
        
    
        return cell
    }

    //MARK: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        //to delet data..
//        context.delete(itemArray[indexPath.row]) // first from table
//        itemArray.remove(at: indexPath.row) // second from array
        
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
        
        //tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new item
    
    @IBAction func addBtn(_ sender: Any) {
        var textField = UITextField() // scope issues
    let alert = UIAlertController(title: "New Challenge!", message: "Add Your New ToDo", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Let's Add", style: .default) { (action) in
        // once user tap add open this alert triggered
            
          self.saveData()
// create data
        let newItem = item(context: self.context)
        newItem.title = textField.text!
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
       self.itemArray.append(newItem)
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New ONE!"
            textField = alertTextField
        }
        //self.defaults.set(self.itemArray, forKey: "arrayKey")
        alert.addAction(action)
    present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - model manuplation methods
// update data
    func saveData()
    {
        
        do {
            try context.save()
        }
        catch{
            print("Something Went Wrong with saving\(error)")
        }
        
        tableView.reloadData() // to add items in table as it's actually there in item array
    }
    
// read data
    func loadData(with request : NSFetchRequest<item> = item.fetchRequest(), predicate : NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
        itemArray = try context.fetch(request)
        }
        catch{
            print("something went wrong with requesting data\(error)")
        }
        tableView.reloadData()
   }

}

extension ToDoViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<item> = item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //cd means not case or  diacritc sensetive
        request.sortDescriptors = [NSSortDescriptor(key: title, ascending: true)]
        loadData(with: request, predicate: predicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                  searchBar.resignFirstResponder() // cusor of search stopped and hide kyeboard
            }
        }
    }
}

