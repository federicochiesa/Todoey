//
//  ViewController.swift
//  Todoey
//
//  Created by Federico Chiesa on 10/12/2018.
//  Copyright © 2018 Federico Chiesa. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedList : List? {
        didSet{
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(format: "parentList.title MATCHES %@", (self.selectedList?.title)!)
            loadData(request)
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let newItem = Item(context: self.context)
            newItem.name = alert.textFields![0].text!
            newItem.done = false
            newItem.parentList = self.selectedList
            self.itemArray.append(newItem)
            self.saveData()
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //MARK: Data management methods
    
    func saveData() {
        do{
            try context.save()
        }
        catch{
            print("Save Error")
        }
        tableView.reloadData()
    }
    
    func loadData(_ request : NSFetchRequest<Item> = Item.fetchRequest()){
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print("Error reading data")
        }
        tableView.reloadData()
    }
}

//MARK: Search bar methods

extension ToDoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!), NSPredicate(format: "parentList.title MATCHES %@", (self.selectedList?.title)!)])
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadData(request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(format: "parentList.title MATCHES %@", (self.selectedList?.title)!)
            loadData(request)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }

}
