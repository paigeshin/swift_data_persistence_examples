//
//  ViewController.swift
//  CoreDataTodo
//
//  Created by shin seunghyun on 2020/02/20.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories: [Category] = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: K.categoryCell, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: K.categoryToItem, sender: self)
    }
    
    //화면 넘기기 전에 데이터 initialization
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionationVC = segue.destination as! ItemViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destionationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        let alert: UIAlertController = UIAlertController(title: "Add a New Category", message: "", preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let categoryText: String = textField?.text {
                let newCategory: Category = Category(context: self.context)
                newCategory.name = categoryText
                self.categories.append(newCategory)
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
    
    func load(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading category: \(error)")
        }
        tableView.reloadData()
    }
    

    
    
}

