//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ivan Nikitin on 04.03.2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()

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
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category")
        
        cell?.textLabel?.text = categoryArray[indexPath.row].name
        
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
            
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveCategory()
        }
        
        let renameAction = UITableViewRowAction(style: .normal, title: "Rename") { (action, indexPath) in
            
            let alert = UIAlertController(title: "Change Category *\(self.categoryArray[indexPath.row].name!)*", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if alert.textFields?.first?.text != "" {
                    self.categoryArray[indexPath.row].name = alert.textFields?.first?.text!
                    self.saveCategory()
                }
                
                if alert.textFields?.first?.text == "999" {
                    action.isEnabled = false
                } else {
                    action.isEnabled = true
                }
                
                
            })
            
            let removeAllAction = UIAlertAction(title: "Remove All", style: .default, handler: { (action) in
                print("Remove All")
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addTextField(configurationHandler: { (textField) in
                
                textField.placeholder = "Category name"

                
            })
            alert.addAction(okAction)
            alert.addAction(removeAllAction)
            alert.addAction(cancelAction)
            
            
            self.present(alert, animated: true, completion: nil)
        }
        renameAction.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

        return [deleteAction, renameAction]
    }

        //MARK: - Add new Categories
    
    @IBAction func addCategoryTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add category", message: "Create a new category", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = alert.textFields?.first?.text
            self.categoryArray.insert(newCategory, at: 0)
            
            self.saveCategory()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new category"
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

    }
    
        //MARK: - Data Manipulation Methods
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
            categoryArray.reverse()
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        
    }
    
    func saveCategory() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
}
