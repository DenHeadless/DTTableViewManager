//
//  TableViewController.swift
//  DTTableViewManager
//
//  Created by Denys Telezhkin on 22.08.15.
//  Copyright © 2015 Denys Telezhkin. All rights reserved.
//

import UIKit
import DTTableViewManager

class TableViewController: UITableViewController, DTTableViewManageable {

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.register(StringCell.self)
        manager.memoryStorage.addItems(["1","2","3"])
    }
}
