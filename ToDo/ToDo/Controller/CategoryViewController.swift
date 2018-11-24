//
//  CategoryViewController.swift
//  ToDo.
//  Created by EsraaEid on 11/22/18.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }

// MARK:- Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
// MARK:- Table view delegete methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detinationVC = segue.destination as! ToDoViewController
        
       if let indexPath = tableView.indexPathForSelectedRow
        {
           detinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
// MARK:- data manuplation methods
    
    // update data CURD
    func save(){
        do {
          try context.save()
        }
        catch{
            print("Something went wrong with saving data\(error)")
        }
        tableView.reloadData()
    }
    // read data
    func load(with request : NSFetchRequest<Category> = Category.fetchRequest() ){
        do{
        categoryArray = try context.fetch(request)
        }
        catch{
            print("Something went wrong with loading data\(error)")
        }
        tableView.reloadData()
    }
    
    
// MARK:- add new categories methods

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "New Category", message: "Add Category Yu!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add NOW!", style:.default) { (action) in
            self.save()
        
        let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Your category Here!" 
            textField = alertTextField
        }
        
        alert.addAction(action)
    present(alert, animated: true, completion: nil)
        
    }
    

    
}
