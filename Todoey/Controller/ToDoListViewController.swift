//
//  ViewController.swift
//  Todoey
//
//  Created by Federico Chiesa on 10/12/2018.
//  Copyright © 2018 Federico Chiesa. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("todolist.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
        saveData()
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
            self.saveData()
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //MARK: Data management methods
    
    func saveData() {
        do{
            let data = try PropertyListEncoder().encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error encoding")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        if let data = try? Data(contentsOf: dataFilePath!){
            do{
                itemArray = try PropertyListDecoder().decode([Item].self, from: data)
            }
            catch{
                print("Error decoding")
            }
        }
    }
}
