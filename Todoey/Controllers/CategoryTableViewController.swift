//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ivan Nikitin on 04.03.2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadData()

    }
    
    //MARK: - TableView Datasource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories?.count ?? 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category")
        
        cell?.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
        
        return cell!
        
    }

        //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "itemsSegue", sender: self)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            do {
                try self.realm.write {
                    self.realm.delete(self.categories![indexPath.row])
                }
            }
            catch {
                print("Rename category \(error)")
            }
            
            self.tableView.reloadData()
            
        }
        
        let renameAction = UITableViewRowAction(style: .normal, title: "Rename") { (action, indexPath) in
            
            let alert = UIAlertController(title: "Change Category *\(self.categories![indexPath.row].name)*", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if alert.textFields?.first?.text != "" {
                    
                    do {
                        try self.realm.write {
                            
                            self.categories![indexPath.row].name = (alert.textFields?.first?.text)!
                        }
                    }
                    catch {
                        print("Rename category \(error)")
                    }
                    
                    self.tableView.reloadData()
                    
                    //MARK: RENAME ACTION

                }

            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
     
            alert.addTextField(configurationHandler: { (textField) in
                
                textField.placeholder = "Category name"
                textField.autocapitalizationType = .words

            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        renameAction.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

        return [deleteAction, renameAction]
    }

        //MARK: - Add new Categories
    
    @IBAction func addCategoryTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add category", message: "Create a new category", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = (alert.textFields?.first?.text)!
            self.save(category: newCategory)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new category"
            textField.autocapitalizationType = .words
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

    }
    
        //MARK: - Data Manipulation Methods
    
    func loadData() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
}
