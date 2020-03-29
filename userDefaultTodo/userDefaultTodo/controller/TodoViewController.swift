//
//  ViewController.swift
//  userDefaultTodo
//
//  Created by shin seunghyun on 2020/02/20.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    var todoItems: [String] = []
    let userDefaults: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loadedItems: [String] = userDefaults.array(forKey: K.Prefs.items) as? [String] {
            todoItems = loadedItems
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: K.cellName, for: indexPath)
        cell.textLabel?.text = todoItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        let alert:UIAlertController = UIAlertController(title: "Add a new Todo item", message: "", preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let newTodoText: String = textField!.text {
                self.todoItems.append(newTodoText)
                self.tableView.reloadData()
                self.userDefaults.set(self.todoItems, forKey: K.Prefs.items)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
}

