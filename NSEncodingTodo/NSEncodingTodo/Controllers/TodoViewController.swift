//
//  ViewController.swift
//  NSEncodingTodo
//
//  Created by shin seunghyun on 2020/02/20.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var todoItems: [Item] = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") //100% 있는 데이터
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: K.cellName, for: indexPath)
        let item: Item = todoItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isDone: Bool = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        tableView.cellForRow(at: indexPath)?.accessoryType = isDone ? .none : .checkmark
        todoItems[indexPath.row].isDone = !todoItems[indexPath.row].isDone
        self.save()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func save(){
        let encoder: PropertyListEncoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(todoItems)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
    
    func load(){
        if let data = try? Data(contentsOf: dataFilePath!){
            do {
                let decoder: PropertyListDecoder = PropertyListDecoder()
                todoItems = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        let alert: UIAlertController = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let newItemText: String = textField!.text {
                var newItem: Item = Item()
                newItem.title = newItemText
                newItem.isDone = false
                self.todoItems.append(newItem)
                self.save()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Item Here"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

