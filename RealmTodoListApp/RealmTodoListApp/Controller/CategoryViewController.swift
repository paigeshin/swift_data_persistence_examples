//
//  ViewController.swift
//  RealmTodoListApp
//
//  Created by shin seunghyun on 2020/02/20.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeCellViewController {
    
    //initialize Realm
    let realm: Realm = try! Realm()
    
    //Data to be collected from Realm
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist") }
        if let navbarColor = UIColor(hexString: "007AFF"){
            navBar.backgroundColor = navbarColor
            navBar.barTintColor = navbarColor
            navBar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let populatedCategory: Category = categories?[indexPath.row] {
            cell.textLabel!.text = populatedCategory.name
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: populatedCategory.hexColor)!, returnFlat: true)
            cell.backgroundColor = UIColor(hexString: populatedCategory.hexColor)
        } else {
            cell.textLabel!.text = "No Category is added yet"
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: "FFFFFF")!, returnFlat: true)
            cell.backgroundColor = UIColor(hexString: "000000")
        }
        return cell
    }
    
    //Triggered when swipe cell action happens
    override func updateModel(indexPath: IndexPath) {
        if let deleteCategory = categories?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(deleteCategory)
                }
            } catch {
                print("Error happened while deleting an item: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: K.categoryToItem, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        if let indexPath: IndexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        let alert:UIAlertController = UIAlertController(title: "Add a Category", message: "", preferredStyle: .alert)
        let action:UIAlertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let newCategoryText: String = textField!.text {
                let newCategory: Category = Category()
                newCategory.name = newCategoryText
                newCategory.hexColor = UIColor.randomFlat().hexValue()
                self.save(categoryToBeAddeds: newCategory)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(categoryToBeAddeds category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func load(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
}

