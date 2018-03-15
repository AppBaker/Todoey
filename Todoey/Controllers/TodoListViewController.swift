//
//  ViewController.swift
//  Todoey
//
//  Created by Ivan Nikitin on 13.02.2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {
    
    var todoItem: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet {
            loadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItem?[indexPath.row] {
            
            let dateFormator = DateFormatter()
            dateFormator.dateFormat = "ss:mm:hh|MM/YYYY"
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            if let item = self.todoItem?[indexPath.row] {
                
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Delete item \(error)")
                }
                
            }
            

        }
        
        let renameAction = UITableViewRowAction(style: .normal, title: "Rename") { (action, indexPath) in
            
            let alert = UIAlertController(title: "Rename", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
                if alert.textFields?.first?.text != "" {
                    
                    if let item = self.todoItem?[indexPath.row] {
                        
                        do {
                            try self.realm.write {
                                item.title = (alert.textFields?.first?.text)!
                                item.dateCreated = Date()
                            }
                        }
                        catch {
                            print("Error saving new items, \(error)")
                        }
                        
                    }
                }
                
                self.tableView.reloadData()
            })
            alert.addAction(okAction)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Change Item"
            })
            self.present(alert, animated: true, completion: nil)
            
        }
        
        return [deleteAction, renameAction]
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItem?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Done/None property change \(error)")
            }
            self.tableView.reloadData()
        }
    }
    //MARK: - Add new Items
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if alert.textFields![0].text == "" {
                
            } else {
                
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = (alert.textFields?.first?.text)!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }
                    catch {
                        print("Error saving new items, \(error)")
                    }
                }
                
                self.tableView.reloadData()
            }
            //Whft will happen once the user clicks the Add Item button on our UIAlert
            print("Success!")
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            textField.autocapitalizationType = .words
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadData() {
        
        todoItem = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
}

extension TodoListViewController : UISearchBarDelegate {


        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
            tableView.reloadData()
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            if searchBar.text?.count == 0 {
                loadData()
    
                DispatchQueue.main.async {
                   searchBar.resignFirstResponder()
    
                }
            }
        }

}


