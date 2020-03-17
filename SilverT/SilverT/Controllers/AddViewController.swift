//
//  AddViewController.swift
//  SilverT
//
//  Created by Manel Soler on 12/03/2020.
//  Copyright © 2020 Manel. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var sections: UIPickerView!
    var categories: UIPickerView!
    var segmented: UISegmentedControl!
    var text: UITextField!
    
    var segData: [String] = ["Income" , "Expence"]
    var sectionsData : [String] = ["Cash", "Credit Card", "Bank account"]
    var categoriesData: [String] = ["Tax", "Grocery", "Enterteiment", "Gym", "Health", "Salary", "Dividents"]

    var main: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add"
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        
        self.segmented = UISegmentedControl(items: segData)
        self.segmented.frame = CGRect.init(x: (self.view.frame.size.width/2) - 100, y: 100, width: 200, height: 50)
        
        self.sections = UIPickerView(frame: CGRect.init(x: 0, y: 200, width: self.view.frame.size.width, height: 100))
        self.categories = UIPickerView(frame: CGRect.init(x: 0, y: 300, width: self.view.frame.size.width, height: 100))
    
        self.text = UITextField(frame: CGRect.init(x: (self.view.frame.size.width/2) - 200, y: 450, width: 400, height: 50))
        self.text.borderStyle = UITextField.BorderStyle.roundedRect
        self.text.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        self.segmented.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        self.segmented.backgroundColor = .green
        self.segmented.selectedSegmentIndex = 0
        
        self.sections.tag = 0
        self.categories.tag = 1
        
        self.sections.delegate = self
        self.sections.dataSource = self
        self.categories.delegate = self
        self.categories.dataSource = self
        
        self.view.addSubview(segmented)
        self.view.addSubview(sections)
        self.view.addSubview(categories)
        self.view.addSubview(text)
    }
    
    @IBAction func segmentAction(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.backgroundColor == .green
        {
            segmentedControl.backgroundColor = .red
        }
        else
        {
            segmentedControl.backgroundColor = .green
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0
        {
           return sectionsData.count
        }
        else if pickerView.tag == 1
        {
            return categoriesData.count
        }
        
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0
        {
           return sectionsData[row]
        }
        else if pickerView.tag == 1
        {
            return categoriesData[row]
        }
        
        return ""
    }
    
    @IBAction func save()
    {
        let now = Date()
        let formattNow = DateFormatter()
        formattNow.dateFormat = "dd/MM/YYYY HH:mm"

        let category = MainViewController.Categories(category: "\(categoriesData[categories.selectedRow(inComponent: 0)])   \(formattNow.string(from: now))", amount: "\((self.segmented.backgroundColor == .red ? "-" : ""))\(text.text!)")
        let section = MainViewController.Sections(section: sectionsData[sections.selectedRow(inComponent: 0)], categories: [category])
        
        var added = false
        
        for sec in self.main.list
        {
            if sec.section == sectionsData[sections.selectedRow(inComponent: 0)]
            {
                self.main.list[sections.selectedRow(inComponent: 0)].categories.append(category)
                added = true
            }
        }
        
        if(!added)
        {
            self.main.list.append(section)
        }
        
        self.main.reload()
        self.text.text = ""
    }
}
