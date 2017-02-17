//
//  MainViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var applicationNameLong: UILabel!
    @IBOutlet weak var applicationDescription: UILabel!
    @IBOutlet weak var repairButton: UIButton!
    @IBOutlet weak var reuseButton: UIButton!
    @IBOutlet weak var recycleButton: UIButton!
    
    private var categoryList: [CategoryMO] = []
    private var repairItemCategory: CategoryMO! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load Categories from database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
            //Create Predicate to refine request. In this case, only return "Repair Items" from results
            let predicate = NSPredicate(format: "%K == %@", "categoryName", "Repair Items")
            request.predicate = predicate
            
            //Sort results by category name
            let sortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            do {
                categoryList = try context.fetch(request)
                repairItemCategory = categoryList[0]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        repairButton.layer.cornerRadius = 5
        reuseButton.layer.cornerRadius = 5
        recycleButton.layer.cornerRadius = 5
        
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
    
    //Button action that navigates to SubCategoryTableViewController and displays Repair subcategories
    @IBAction func repairButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showRepairSubcategory", sender: self)
    }
    
    
    //UIPopoverPresentationController Delegate method. Forces popover instead of modal presentation for iphone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    //Segue to subCategoryTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRepairSubcategory" {
            let subCategoryVC = segue.destination as! SubCategoryTableViewController
            subCategoryVC.category = repairItemCategory
        }
    }
    
    //Segue destination for other view controlers to navigate to this view
    //Used by home button on navigation bar
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {

    }
    
}

