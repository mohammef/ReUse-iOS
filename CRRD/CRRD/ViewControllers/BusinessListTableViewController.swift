//
//  BusinessListTableViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 Fahmy Mohammed - Team Reticulum. All rights reserved.
//

import UIKit
import CoreData

class BusinessListTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    private var businessList: [BusinessMO] = []
    private var selectedBusiness: BusinessMO! = nil
    var subcategory: SubcategoryMO! = nil
    var category: CategoryMO! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load Businesses from database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<BusinessMO> = BusinessMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
            //Refine request to businesses from a particular category
            if subcategory != nil && category != nil {
                //Refine request. In this case, return all business of given subcategory
                let predicate = NSPredicate(format: "%K == %@", "category.categoryName", category.categoryName!)
                
                request.predicate = predicate
            }
        
            //Sort results by business name
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sortDescriptor]
        
            do {
                businessList = try context.fetch(request)
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
    
    //Segue to BusinessDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusiness" {
            let businessDetailsVC = segue.destination as! BusinessDetailsViewController
            businessDetailsVC.business = selectedBusiness
        }
    }
    
    
    // MARK: - Table view data source

    //Number of TableView sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Number of rows in TableView section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessList.count
    }
    
    //List businesses from results
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = businessList[indexPath.row].name
        return cell
    }

    //Perform action for selected business
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBusiness = businessList[indexPath.row]
        performSegue(withIdentifier: "showBusiness", sender: self)
    }
}
