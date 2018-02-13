//
//  ViewController.swift
//  Todoey
//
//  Created by Ivan Nikitin on 13.02.2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Finde Mike", "Buy Eggs", "Finde charge"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }

}

