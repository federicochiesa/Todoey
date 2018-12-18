//
//  ListsViewController.swift
//  Todoey
//
//  Created by Federico Chiesa on 14/12/2018.
//  Copyright © 2018 Federico Chiesa. All rights reserved.
//

import UIKit
import CoreData

class ListsViewController: UITableViewController {

    var listsArray = [List]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New List", message: "Type in the new list's name", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New List"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = List(context: self.context)
            newItem.title = alert.textFields![0].text!
            self.listsArray.append(newItem)
            self.saveData()
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //MARK: TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listsCell", for: indexPath)
        cell.textLabel?.text = listsArray[indexPath.row].title
        return cell
    }

    //MARK: Data manipulation methods
    
    func saveData() {
        do{
            try context.save()
        }
        catch{
            print("Save Error")
        }
        tableView.reloadData()
    }
    
    func loadData(_ request : NSFetchRequest<List> = List.fetchRequest()){
        do{
            listsArray = try context.fetch(request)
        }
        catch{
            print("Error reading data")
        }
        tableView.reloadData()
    }
    
    //MARK: TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedList = listsArray[indexPath.row]
        }
    }
}
