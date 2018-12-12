//
//  ViewController.swift
//  Todoey
//
//  Created by Federico Chiesa on 10/12/2018.
//  Copyright © 2018 Federico Chiesa. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item("Posso")]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items =  defaults.value(forKey: "todolist") as? [Item]{
            itemArray = items
        }
    }

    //MARK: TableView data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].name

        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    //MARK: TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "Type in the new item's name", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.itemArray.append(Item(alert.textFields![0].text!))
            self.defaults.set(self.itemArray, forKey: "todolist")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}