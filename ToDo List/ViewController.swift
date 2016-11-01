//
//  ViewController.swift
//  ToDo List
//
//  Created by Mirko Cukich on 10/31/16.
//  Copyright © 2016 Digital Mirko. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet var textField: NSTextField!
    @IBOutlet var importantCheckbox: NSButton!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var deleteBtn: NSButton!
    
    
    var toDoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getToDoItems()
    }
    
    // get items from core data
    func getToDoItems(){
        // Get the todo Items from coredata
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.managedObjectContext {
            
            do{
                // set them to the class property
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
                
            } catch {
                
            }
        }
        
        // Update the table
        tableView.reloadData()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func addClicked(_ sender: Any) {
        
        if textField.stringValue != "" {
            
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.managedObjectContext {
                
                let toDoItem = ToDoItem(context: context)
                
                toDoItem.name = textField.stringValue
                if importantCheckbox.state == 0 {
                    // Not Important
                    toDoItem.important = false
                } else {
                    // Important
                    toDoItem.important = true
                    
                }
                
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                
                textField.stringValue = ""
                importantCheckbox.state = 0
                
                getToDoItems()
                
                
            }
            
        }
        
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        let toDoItem = toDoItems[tableView.selectedRow]
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.managedObjectContext {
            context.delete(toDoItem)
            
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            
            getToDoItems()
            
            deleteBtn.isHidden = true
        }
    }
    
    
    // MARK: - TableView Stuff
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoItem = toDoItems[row]
        
        
        if tableColumn?.identifier == "importantColumn" {
            // IMPORTANT
            if let cell = tableView.make(withIdentifier: "importantCell", owner: self) as? NSTableCellView {
                
                if toDoItem.important {
                    cell.textField?.stringValue = "❗️"
                } else {
                    cell.textField?.stringValue = ""
                }
                return cell
                
            }
        } else {
            // TODO NAME
            if let cell = tableView.make(withIdentifier: "todoitems", owner: self) as? NSTableCellView {
                cell.textField?.stringValue = toDoItem.name!
                
                return cell
                
            }
        }
        
        
        
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteBtn.isHidden = false
    }
    
    
}

