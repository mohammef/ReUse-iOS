//
//  BusinessDetailsViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 2/02/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class BusinessDetailsViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    private struct BusinessDetails {
        var identifier = ""
        var value = ""
        var image: UIImage! = nil
    }
    
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!

    var business: BusinessMO! = nil
    private var subCategoryList: [SubcategoryMO] = []
    //private var businessDetailList: [Int: String] = [:]
    //private var images: [Int: UIImage] = [:]
    //private var businessDetailListCount: Int = 0
    private var businessDetails: [BusinessDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTheme()
        loadData()
        populateBusinessDetailsList()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func populateBusinessDetailsList() {
        var count = 0
        
        if business.address_line_1 != "" {
            
            businessDetails.append(BusinessDetails())
            businessDetails[count].identifier = "address_line_1"
            businessDetails[count].value = "\(business.address_line_1!) \n\(business.city!) \(business.state!) \(business.zip)"
            businessDetails[count].image = #imageLiteral(resourceName: "place_black")
            count += 1
        }
        
        if business.phone != "" {
            //^([0-9]{3})([0-9]{3})([0-9]{4})
            
            businessDetails.append(BusinessDetails())
            businessDetails[count].identifier = "phone"
            businessDetails[count].value = business.phone!
            businessDetails[count].image = #imageLiteral(resourceName: "phone_black")
            count += 1
        }
        
        if business.website != "" {
            
            businessDetails.append(BusinessDetails())
            businessDetails[count].identifier = "website"
            businessDetails[count].value = business.website!
            businessDetails[count].image = #imageLiteral(resourceName: "public_black")
            count += 1
        }

        
        businessDetails.append(BusinessDetails())
        businessDetails[count].identifier = "accepts"
        businessDetails[count].value = "\(business.name!) Accepts the Following:"
        businessDetails[count].image = #imageLiteral(resourceName: "check_box_black")
        count += 1
        
        businessDetails.append(BusinessDetails())
        businessDetails[count].identifier = "subcategory_list"
        
        //Format subcategory list for display in table view cell
        for subcategory in subCategoryList {
            businessDetails[count].value += "\(subcategory.subCategoryName!)\n"
        }
        
        businessDetails[count].image = nil
    }
    
    //MARK: - Theme
    
    //Adjusts look of items in view
    func viewTheme(){
        //Hide back button from the navigation bar
        //self.navigationItem.setHidesBackButton(true, animated: false)

        //Set navigation bar label to business name
        viewLabel.text = business.name
        
        //Set business details view label to business name
        businessNameLabel.text = business.name
    }
    
    
    //MARK: - Navigation
    
    //Button action that displays the drop down menu
    @IBAction func dropDownMenu(_ sender: UIButton) {
        
        //Reference to drop down menu view controller
        let dropDownView = (storyboard?.instantiateViewController(withIdentifier: "DropDownMenuViewController"))!
        
        //Set presentation style to popover
        dropDownView.modalPresentationStyle = UIModalPresentationStyle.popover
        
        //Setup popover presentation controller
        dropDownView.popoverPresentationController?.delegate = self
        dropDownView.popoverPresentationController?.sourceView = sender
        dropDownView.popoverPresentationController?.sourceRect = sender.bounds
        
        //Present the popover menu
        self.present(dropDownView, animated: false, completion: nil)
    }
    
    //UIPopoverPresentationController Delegate method. Forces popover instead of modal presentation for iphone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    
    @IBAction func businessURL(_ sender: Any) {
        //UIApplication.shared.open(NSURL(string: "http://www.arcbenton.org/")! as URL)
    }

    @IBAction func businessAddress(_ sender: Any) {
        /*
        let baseUrl: String = "http://maps.apple.com/?q="
        let encodedName = "928 NW Beca Ave Corvallis OR 97330"
        let finalUrl = baseUrl + encodedName
        UIApplication.shared.open(NSURL(string: finalUrl)! as URL)
        */
        
    }
    
    @IBAction func businessPhone(_ sender: Any) {
        //(541)754 9011
    }
    
    
    // MARK: - Table view data source
    
    //Load from core data model
    func loadData() {
        
        // Load Subcategories from core data model
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<SubcategoryMO> = SubcategoryMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
            //Refine request. In this case, return all subcategories of given category
            let predicate = NSPredicate(format: "business.name CONTAINS[cd] %@", business.name!)
            request.predicate = predicate
            
            //Sort results by subcategory name
            let sortDescriptor = NSSortDescriptor(key: "subCategoryName", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            do {
                subCategoryList = try context.fetch(request)
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
    }
    
    //Number of rows in table view section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessDetails.count
    }
    
    //Display business details in table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessDetailCell", for: indexPath) as! BusinessDetailTableViewCell
        
        //Change color to black for subcategory list
        if (businessDetails[indexPath.row].identifier == "accepts" ||
            businessDetails[indexPath.row].identifier == "subcategory_list") {
            cell.labelValue.textColor = UIColor.black
        }
        
        //Wrap characters if URL is too long for one line
        if businessDetails[indexPath.row].identifier == "website" {
            cell.labelValue.lineBreakMode = NSLineBreakMode.byCharWrapping
        }
        
        //Configure table view cell
        cell.labelValue.text = businessDetails[indexPath.row].value
        cell.imageLabel.image = businessDetails[indexPath.row].image
        
        return cell
    }
    
    /*
    //Perform action for selected business
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        //Action for opening business website, phone, and address
        switch businessDetails[indexPath.row].identifier {
        case "website":
            UIApplication.shared.open(NSURL(string: businessDetails[indexPath.row].value)! as URL)
        case "phone":
            UIApplication.shared.open(NSURL(string: "telprompt://\(businessDetails[indexPath.row].value)")! as URL)
        default:
            break
        }
        
    }
    */
}
