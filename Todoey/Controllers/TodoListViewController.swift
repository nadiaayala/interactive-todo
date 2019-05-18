//
//  ViewController.swift
//  Todoey
//
//  Created by Nadia Ayala on 11/05/19.
//  Copyright © 2019 Nadia Ayala. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController  {
    

//    @IBOutlet var todoTableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemArray: [Item] = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        loadItems()
    }

    //MARK - TableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else if item.done == false {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //Next line checks the currenct value of the done property of the selected item and then changes it to its opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
           //context.delete(itemArray[indexPath.row])
          //itemArray.remove(at: indexPath.row)
          saveItems()
 
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != "" {
                
                //At the time pooint when the app is running live inside the user's iPhone, this shared ui application will correspond to the live application object. The delegate is the AppDelegate and we will cast it as our AppDelegate class.
                //1. Tap into the UIApplication class, 2. tap into the shared property, which corresponds to the current app as an object, 3. tap into its delegate, 4. cast it as appdelegate (because they both inherit from the same class UIApplicationDelegate this is valid). 5 We now have access to our AppDelegate as an object and we can get its propery persistentContainer
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                self.itemArray.append(newItem)
                
                self.saveItems()
                
                }
            
        }
        
        alertController.addAction(action)
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        present(alertController, animated: true, completion: nil)
     
        
    }
    
    func saveItems(){
        
        
        do {
            try self.context.save()
        }
        catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        print(itemArray)
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){

//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            //The output for this method will be an array of Items that is stored in our persistent container
            itemArray =  try context.fetch(request)
        }
        catch{
            print("Error fetching data from context. \(error)")
        }
        
        tableView.reloadData()
    }
}
    


// MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
        
//        do{
//            //The output for this method will be an array of Items that is stored in our persistent container
//            itemArray =  try context.fetch(request)
//        }
//        catch{
//            print("Error fetching data from context. \(error)")
//        }
        
        loadItems(with: request)
        
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
        
}
    
    
    
    



