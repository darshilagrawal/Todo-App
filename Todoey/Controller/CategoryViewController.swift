//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Darshil Agrawal on 19/08/20.
//

import UIKit

import RealmSwift

class CategoryViewController: SwipleTableViewController {
    let realm = try! Realm()
    var categoryArray:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert=UIAlertController(title: "Add a Category", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newItem=Category()
            newItem.name=textField.text!
            
            
            self.saveCategory(with: newItem)
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Enter new Category"
            textField=alertTextField
        }
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text=categoryArray?[indexPath.row].name ?? "No Category Found"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! TodoeyViewController
        if let indexPath=tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory=categoryArray?[indexPath.row]
        }
    }
    //MARK: - DATA MANIPULATION
    
    func loadData() {
        categoryArray=realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func saveCategory(with object:Object){
        do {
            try realm.write{
                realm.add(object)
            }
        } catch {
            print("error saving the Context\(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath:IndexPath){
        if let category=self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(category)
                }
                
            } catch {
                print("Error Deleting Cell")
            }
            
        }
    }
    
}



