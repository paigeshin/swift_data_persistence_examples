//
//  ItemViewController.swift
//  CoreDataTodo
//
//  Created by shin seunghyun on 2020/02/20.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {

    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Item] = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            self.load()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: K.itemcell, for: indexPath)
        let item: Item = items[indexPath.row]
        cell.textLabel!.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isDone: Bool = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        tableView.cellForRow(at: indexPath)?.accessoryType = isDone ? .none : .checkmark
        items[indexPath.row].isDone = !items[indexPath.row].isDone
        save()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        let alert: UIAlertController = UIAlertController(title: "Add a New Item", message: "", preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let itemText: String = textField?.text {
                let newItem: Item = Item(context: self.context)
                newItem.title = itemText
                newItem.isDone = false
                newItem.parentCategory = self.selectedCategory
                self.items.append(newItem)
                self.save()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(){
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func load(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        //기본 default predicate
        let categoryPredicate: NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //새로운 요청이 들어왔을 때 추가적으로 보낼 predicate
        if let additionalPredicate: NSPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do {
            items = try context.fetch(request)
        } catch {
            print("Error loading category: \(error)")
        }
        tableView.reloadData()
    }


}

extension ItemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        load(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
