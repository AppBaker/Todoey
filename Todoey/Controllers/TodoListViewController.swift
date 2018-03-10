//
//  ViewController.swift
//  Todoey
//
//  Created by Ivan Nikitin on 13.02.2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        
        didSet {
            loadData()
        }
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(dataFilePath!)

//        if let array = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = array
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.titel
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        itemArray[indexPath.row].setValue("Completed", forKey: "titel")
        
        
        
        
        
        let alert = UIAlertController(title: itemArray[indexPath.row].titel, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Change", style: .default) { (action) in
            if alert.textFields![0].text == "" {
                
            } else {
                self.itemArray[indexPath.row].titel = alert.textFields![0].text
                
            }
            //Whft will happen once the user clicks the Add Item button on our UIAlert
            self.saveItems()
            print("Change Success!")
        }
        let doneAction = UIAlertAction(title: "Done/None", style: .default) { (action) in
            self.itemArray[indexPath.row].done = !self.itemArray[indexPath.row].done
            self.saveItems()
        }
        let deletActin = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.context.delete(self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            self.saveItems()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Rename item"
        }
        alert.addAction(action)
        alert.addAction(doneAction)
        alert.addAction(deletActin)
        
        present(alert, animated: true, completion: nil)

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if alert.textFields![0].text == "" {
                
            } else {
                let newItem = Item(context: self.context)
                newItem.titel = alert.textFields?.first?.text
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveItems()
 
            }
            //Whft will happen once the user clicks the Add Item button on our UIAlert
            print("Success!")
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
 
        do {
            
            try context.save()
            
        }
        catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()

    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        request.predicate = NSPredicate(format: "titel CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "titel", ascending: true)]
        
        loadData(with: request, predicate: request.predicate!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("*",searchText,"*")
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
                
            }
        }
    }
}

