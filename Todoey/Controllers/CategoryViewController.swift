//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nadia Ayala on 18/05/19.
//  Copyright © 2019 Nadia Ayala. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var categoryArray: [Cat] = [Cat]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    //MARK: - TableView Data Source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
    
    
    //MARK: - Data manipulation methods
    
    func saveCategories(){
        
        
        do {
            try self.context.save()
        }
        catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        print(categoryArray)
        
    }
    
    func loadCategories(with request: NSFetchRequest<Cat> = Cat.fetchRequest()){
        
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            //The output for this method will be an array of Items that is stored in our persistent container
            categoryArray =  try context.fetch(request)
        }
        catch{
            print("Error fetching data from context. \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alertController = UIAlertController(title: "Add category", message: " ", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != "" {
                let newCat = Cat(context: self.context)
                newCat.name = textField.text!
                self.categoryArray.append(newCat)
                
                self.saveCategories()
//                print(self.categoryArray)
                
            }
    }
        alertController.addAction(action)
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - TableView delegate methods

   
    
    
    
    

}
