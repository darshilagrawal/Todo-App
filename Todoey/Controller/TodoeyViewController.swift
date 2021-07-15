
import UIKit

import RealmSwift

class TodoeyViewController: SwipleTableViewController{
    let realm = try! Realm()
    var itemArray:Results<Item>?
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    //let defaults=UserDefaults.standard
    //let filePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    // let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        //  print(filePath)
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField=UITextField()
        let alert=UIAlertController(title: "Add an Item", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory=self.selectedCategory{
                if textField.text != "" {
                do {
                    try self.realm.write{
                        let newItem=Item()
                        newItem.title=textField.text!
                        newItem.dateCreated=Date()
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print("error Saving new data \(error)")
                }
                }else{
                    let alert = UIAlertController(title: "Empty Field", message: "Please Enter details", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Retry", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
        }
            self.tableView.reloadData()
        }
        
        
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Enter new Alert"
            textField=alertTextField
        }
        present(alert, animated: true, completion: nil)
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray?.count ?? 1
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell=super.tableView(tableView, cellForRowAt: indexPath)
        if let item=itemArray?[indexPath.row]{
            
            cell.textLabel?.text=item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
           
            cell.textLabel?.text="No items Found"
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item=itemArray?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("error in Selecting the row\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadItems(){
        itemArray=selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath:IndexPath){
        if let item=self.selectedCategory?.items[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(item)
                }
                
            }catch{
                print("Error Deleting Cell")
            }
            
        }
    }
}

//MARK: - Search View Delegate

extension TodoeyViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray=itemArray?.filter("title CONTAINS[cd] %a",searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else{
            
            itemArray=itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
            
            tableView.reloadData()
        }
    }
}

//
//    func loadItems() {
//        let categoryPredicate=NSPredicate(format: "parentCategory.name MATCHES %@",selectedCategory!.name!)
//        if let searchPredicate=predicate{
//            request.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,searchPredicate])
//        }else{
//            request.predicate=categoryPredicate
//        }
//        do{
//        itemArray = try context.fetch(request)
//        }catch{
//            print("Error Fetching Request")
//        }
//        tableView.reloadData()
//    }

