//
//  SwipeCellViewController.swift
//  RealmTodoListApp
//
//  Created by shin seunghyun on 2020/02/20.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeCellViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    //Must be implemented when using `SwipeTableViewCellDelegate`
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(indexPath: indexPath)
        }
        // customize the action appearance
        deleteAction.image = UIImage(systemName: "delete.left")
        return [deleteAction]
    }
    
    //Must be implemented when using `SwipeTableViewCellDelegate`
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(indexPath: IndexPath) {
        // Update our data model
    }
    
}
