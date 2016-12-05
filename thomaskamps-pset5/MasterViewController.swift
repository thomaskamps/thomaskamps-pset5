//
//  MasterViewController.swift
//  thomaskamps-pset5
//
//  Created by Thomas Kamps on 03-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let todoManager = TodoManager.sharedInstance
    var selectedList: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func encodeRestorableState(with coder: NSCoder) {

        let selectedList = todoManager.getSelectedInt()
        coder.encode(selectedList, forKey: "selectedList")
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        self.selectedList = coder.decodeInteger(forKey: "selectedList")
        
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        todoManager.readTodos()
        todoManager.setSelectedList(selectedList: self.selectedList)
    }

    func insertNewObject(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add To-Do List", message: "Enter a title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "Title for your list"
        }
        alert.addAction(UIAlertAction(title: "ADD", style: .default, handler: { [weak alert] (_) in
            let titleAlert = alert?.textFields![0]
            let title = titleAlert?.text
            self.todoManager.addList(title: title!)
            self.todoManager.writeTodos()
            let indexPath = IndexPath(row: 0, section: 0)
            //self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
            self.performSegue(withIdentifier: "showDetail", sender: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                todoManager.setSelectedList(selectedList: indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                //controller.tableView.reloadData()
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.getCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let title = todoManager.getList(index: indexPath.row)
        cell.textLabel!.text = title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoManager.deleteList(index: indexPath.row)
            self.todoManager.writeTodos()
            self.tableView.reloadData()
            todoManager.setSelectedList(selectedList: 1000)
            self.performSegue(withIdentifier: "showDetail", sender: nil)
        }
    }


}

