//
//  SubCategoryTableViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit
import CoreData

class SubCategoryTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    private var subCategoryList: [SubcategoryMO] = []
    private var selectedSubcategory: SubcategoryMO! = nil
    var category: CategoryMO! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Subcategories from database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<SubcategoryMO> = SubcategoryMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
            //Refine request. In this case, return all subcategories of given category
            let predicate = NSPredicate(format: "%K == %@", "category.categoryName", category.categoryName!)
            request.predicate = predicate
            
            //Sort results by subcategory name
            let sortDescriptor = NSSortDescriptor(key: "subCategoryName", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            request.returnsDistinctResults = true
            
            do {
                let temp = try context.fetch(request)
                
                //Remove duplicate results
                for item in temp {
                    var index = 0;
                    for subCat in subCategoryList {
                        if subCat.subCategoryName == item.subCategoryName {
                            subCategoryList.remove(at: index)
                        }
                        index += 1
                    }
                    subCategoryList.append(item)
                }
                
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        //Hide back button from the navigation bar
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //Set navigation bar label to category name
        self.navigationItem.leftBarButtonItem?.title = category.categoryName
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
    
    //UIPopoverPresentationController delegate method. Forces popover instead of modal presentation for iphone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    //Segue to BusinessListTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusinessList" {
            let businessListVC = segue.destination as! BusinessListTableViewController
            businessListVC.subcategory = selectedSubcategory
            businessListVC.category = category
        }
    }
    
    
    // MARK: - Table view data source
    
    //Number of TableView sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Number of rows in TableView section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategoryList.count
    }

    //List subcategories from results
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = subCategoryList[indexPath.row].subCategoryName
        return cell
    }
 
    //Perform action for selected subcategory
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubcategory = subCategoryList[indexPath.row]
        performSegue(withIdentifier: "showBusinessList", sender: self)
    }
}
