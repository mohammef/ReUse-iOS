//
//  CategoryTableViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 Fahmy Mohammed - Team Reticulum. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    private var categoryList: [CategoryMO] = []
    private var selectedCategory: CategoryMO! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load Categories from database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
            //Create Predicate to refine request. In this case, remove "Repair Items" from results
            let predicate = NSPredicate(format: "%K != %@", "categoryName", "Repair Items")
            request.predicate = predicate
            
            //Sort results by category name
            let sortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            do {
                categoryList = try context.fetch(request)
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        //Hide back button from the navigation bar
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Navigation
    
    //Button action that displays the drop down menu
    @IBAction func dropDownMenu(_ sender: UIBarButtonItem) {
        
        //Reference to drop down menu view controller
        let dropDownView = (storyboard?.instantiateViewController(withIdentifier: "DropDownMenuViewController"))!
        
        //Set presentation style to popover
        dropDownView.modalPresentationStyle = UIModalPresentationStyle.popover
        
        //Setup popover presentation controller
        dropDownView.popoverPresentationController?.delegate = self
        dropDownView.popoverPresentationController?.barButtonItem = sender
        
        //Present the popover menu
        self.present(dropDownView, animated: false, completion: nil)
    }
    
    //UIPopoverPresentationController Delegate method. Forces popover instead of modal presentation for iphone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    //Segue to SubCategoryTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSubcategory" {
            let subCategoryVC = segue.destination as! SubCategoryTableViewController
            subCategoryVC.category = selectedCategory
        }
    }
    
    
    // MARK: - Table view data source
    
    //Number of TableView sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Number of rows in TableView section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }

    //List category names from results
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].categoryName
        return cell
    }
    
    //Perform action for selected category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryList[indexPath.row]
        performSegue(withIdentifier: "showSubcategory", sender: self)
    }
}
