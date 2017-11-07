//
//  AddItemTableViewControllerDelegate.swift
//  Bucket List 2
//
//  Created by Kioja Kudumu on 11/6/17.
//  Copyright © 2017 Kioja Kudumu. All rights reserved.
//

import Foundation

// Creating the protocol so that the delegate can talk to these functions

protocol AddItemTableViewControllerDelegate: class {
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?)
    func cancelButtonPressed(by controller: AddItemTableViewController)
}
