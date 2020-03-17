//
//  MainViewController.swift
//  SilverT
//
//  Created by Manel Soler on 12/03/2020.
//  Copyright © 2020 Manel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct Categories {
        var category: String
        var amount: String
    }
    
    struct Sections {
        var section: String
        var categories: [Categories]
    }
    
    var tableView : UITableView = UITableView()
    var list = [Sections]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dashboard"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(onAdd))
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(tableView)
    }
    
    @IBAction func onAdd()
    {
        let vc = AddViewController(nibName: nil, bundle: nil)
        vc.main = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.list[section].section
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        var total: Float = 0.0
        for item in self.list[section].categories
        {
            total += Float(item.amount) ?? 0.0
        }
        
        return "Total \(total)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list[section].categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        
        cell.textLabel!.text = "\(self.list[indexPath.section].categories[indexPath.row].category)"
        cell.detailTextLabel?.text = "\(self.list[indexPath.section].categories[indexPath.row].amount)"
        
        if (cell.detailTextLabel?.text?.contains("-"))!
        {
            cell.detailTextLabel?.textColor = .red
        }
        else
        {
            cell.detailTextLabel?.textColor = .green
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:  UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.list[indexPath.section].categories.remove(at: indexPath.row)
            self.reload()
        }
    }
    
    func reload()
    {
        self.tableView.reloadData()
    }
}


