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
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var rightBarButtonsView: UIView!
    
    private var categoryList: [CategoryMO] = []
    private var repairItemCategory: CategoryMO! = nil
    
    //Gets the strings stored in the Strings.plist file
    private var strings: [String: Any] = Utils.getStrings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTheme()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Theme
    
    //Adjusts look of items in view
    func viewTheme(){

        //Hide back button from the navigation bar
        //self.navigationItem.setHidesBackButton(true, animated: false)
        
        //Hide back button label from the navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Set view label text
        self.title = strings["ApplicationName"] as! String?
        applicationNameLong.text = strings["ApplicationNameLong"] as! String?
        applicationDescription.text = strings["ApplicationDescription"] as! String?
        
        repairButton.layer.cornerRadius = 5
        reuseButton.layer.cornerRadius = 5
        recycleButton.layer.cornerRadius = 5
    }
  
    
    //MARK: - Navigation
    
    //Button action that displays the drop down menu
    @IBAction func dropDownMenu(_ sender: UIButton) {
        
        //Reference to drop down menu view controller
        let dropDownView = (storyboard?.instantiateViewController(withIdentifier: "DropDownMenuViewController"))!
        
        //Set presentation style to popover
        dropDownView.modalPresentationStyle = UIModalPresentationStyle.popover
        
        //Setup popover presentation controller
        dropDownView.popoverPresentationController!.delegate = self
        dropDownView.popoverPresentationController!.sourceView = sender
        dropDownView.popoverPresentationController!.sourceRect = sender.bounds
        //dropDownView.popoverPresentationController!.sourceRect = CGRect(x: sender.bounds.origin.x - 3, y: sender.bounds.origin.y, width: sender.bounds.size.width, height: sender.bounds.size.height)
        
        //Present the popover menu
        self.present(dropDownView, animated: false, completion: nil)
    }
    
    //Button action that navigates to SubCategoryTableViewController and displays repair subcategories
    @IBAction func repairButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showRepairSubcategory", sender: self)
    }
    
    //Button action that navigates to BusinessListTableViewController and displays recycle businesses
    @IBAction func recycleButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showRecycleBusinessList", sender: self)
    }
    
    
    //UIPopoverPresentationController delegate method. Forces popover instead of modal presentation for iphone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    //Segue repair button or recycle button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Repair button
        if segue.identifier == "showRepairSubcategory" {
            let subCategoryVC = segue.destination as! SubCategoryTableViewController
            subCategoryVC.category = repairItemCategory
        }
        
        //Recycle button
        if segue.identifier == "showRecycleBusinessList" {
            let businessListVC = segue.destination as! BusinessListTableViewController
            businessListVC.recycleBusinesses = true
        }
    }
    
    //Segue destination for other view controlers to navigate to this view
    //Used by home button on navigation bar
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {

    }
    
    
    // MARK: - Data source
    
    //Load from core data model
    func loadData() {
        
        //Load Categories from core data model
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
            //Create Predicate to refine request. In this case, only return "Repair Items" from results
            let predicate = NSPredicate(format: "categoryName == %@", "Repair Items")
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
    }
    
}

