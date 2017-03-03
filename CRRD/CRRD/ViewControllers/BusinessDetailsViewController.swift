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

class BusinessDetailsViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    private struct BusinessDetails {
        var identifier = ""
        var value = ""
        var link = ""
        var image: UIImage! = nil
    }
    
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!

    var business: BusinessMO! = nil
    private var subCategoryList: [SubcategoryMO] = []
    private var linkList: [LinkMO] = []
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
    
    //Add business info
    func populateBusinessDetailsList() {
        var index = 0
        
        if business.address_line_1 != "" {
            businessDetails.append(BusinessDetails())
            index = businessDetails.endIndex - 1
            businessDetails[index].identifier = "address_line_1"
            businessDetails[index].value = "\(business.address_line_1!) \n\(business.city!) \(business.state!) \(business.zip)"
            businessDetails[index].image = #imageLiteral(resourceName: "place_black")
        }
        
        if business.phone != "" {
            //^([0-9]{3})([0-9]{3})([0-9]{4})
            
            businessDetails.append(BusinessDetails())
            index = businessDetails.endIndex - 1
            
            businessDetails[index].identifier = "phone"
            businessDetails[index].value = formatPhone(business.phone!)
            businessDetails[index].link = business.phone!
            businessDetails[index].image = #imageLiteral(resourceName: "phone_black")
        }
        
        if business.website != "" {
            
            businessDetails.append(BusinessDetails())
            index = businessDetails.endIndex - 1
            
            businessDetails[index].identifier = "website"
            businessDetails[index].value = business.website!
            businessDetails[index].link = business.website!
            businessDetails[index].image = #imageLiteral(resourceName: "public_black")
        }

        if subCategoryList.count > 0 {
            businessDetails.append(BusinessDetails())
            index = businessDetails.endIndex - 1
            
            businessDetails[index].identifier = "accepts"
            businessDetails[index].value = "\(business.name!) Accepts the Following:"
            businessDetails[index].image = #imageLiteral(resourceName: "check_box_black")
            
            businessDetails.append(BusinessDetails())
            index = businessDetails.endIndex - 1
            
            businessDetails[index].identifier = "subcategory_list"
            
            //Format subcategory list for display in table view cell
            for subcategory in subCategoryList {
                businessDetails[index].value += "\(subcategory.subCategoryName!)\n"
            }
            
            businessDetails[index].image = nil
        }
        
        if linkList.count > 0 {
            for link in linkList {
                businessDetails.append(BusinessDetails())
                index = businessDetails.endIndex - 1
                
                businessDetails[index].identifier = "link"
                businessDetails[index].value = link.linkName!
                businessDetails[index].link = link.uri!
                businessDetails[index].image = #imageLiteral(resourceName: "link_black")
            }
        }
    }
    
    func formatPhone(_ phoneNumber: String) -> String {
        
        switch phoneNumber.characters.count {
        case 7:
            return String(format: "%@-%@", subString(phoneNumber,0,3), subString(phoneNumber,3,7))
        case 10:
            return String(format: "(%@)%@-%@", subString(phoneNumber,0,3), subString(phoneNumber,3,6), subString(phoneNumber,6,10))
        case 11:
            return String(format: "(%@)%@-%@", subString(phoneNumber,1,4), subString(phoneNumber,4,7), subString(phoneNumber,7,11))
        default:
            return phoneNumber
        }
        
    }
    
    func subString(_ string: String,_ start: Int,_ end: Int) -> String {
        let start = string.index(string.startIndex, offsetBy: start)
        let end = string.index(string.startIndex, offsetBy: end)
        let range = start..<end
        return string.substring(with: range)
    }
    
    //MARK: - Theme
    
    //Adjusts look of items in view
    func viewTheme(){
       
        //Hide back button label from the navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Set view label text
        self.title = business.name
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

    //Displays an alert on the screen and prompts the user with a choice to call the business
    func callBusiness(_ phoneNumber: String,_ formatedNumber: String) {
        
        //Setup alert menu
        let alertMenu = UIAlertController(title: nil, message: "Call \(business.name!)", preferredStyle: .actionSheet)
        let cancelAlertMenu = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Setup action that allows the user to call when the phone number is pressed
        let actionHandler = { (action:UIAlertAction) -> Void in
            UIApplication.shared.open(NSURL(string: "tel://+1\(phoneNumber)") as! URL, options: [:], completionHandler: nil)
        }
        let callAction = UIAlertAction(title: "\(formatedNumber)", style: .default, handler: actionHandler)
        
        //Add call and cancel actions to the alert menu
        alertMenu.addAction(callAction)
        alertMenu.addAction(cancelAlertMenu)
        
        present(alertMenu, animated: true, completion:  nil)
    }
    
    //Displays an alert on the screen and prompts the user with a choice to navigate to the link
    func openLink(_ link: String) {
        
        //Setup alert menu
        let alertMenu = UIAlertController(title: nil, message: "Open", preferredStyle: .actionSheet)
        let cancelAlertMenu = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Setup action that allows the user to open the link when pressed
        let actionHandler = { (action:UIAlertAction) -> Void in
            UIApplication.shared.open(NSURL(string: link)! as URL)
        }
        let linkAction = UIAlertAction(title: "\(link)", style: .default, handler: actionHandler)
        
        //Add call and cancel actions to the alert menu
        alertMenu.addAction(linkAction)
        alertMenu.addAction(cancelAlertMenu)
        
        present(alertMenu, animated: true, completion:  nil)
    }
    
    
    
    // MARK: - Table view data source
    
    //Load from core data model
    func loadData() {
        
        // Load Subcategories and links from core data model
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            
            //Subcategories request
            let subCategoryRequest: NSFetchRequest<SubcategoryMO> = SubcategoryMO.fetchRequest()
            
            //Refine subcategory request. Only return subcategories related to business
            let subCategoryPredicate = NSPredicate(format: "business.name CONTAINS[cd] %@", business.name!)
            subCategoryRequest.predicate = subCategoryPredicate
            
            //Sort results by subcategory name in ascending order
            let subCategorySortDescriptor = NSSortDescriptor(key: "subCategoryName", ascending: true)
            subCategoryRequest.sortDescriptors = [subCategorySortDescriptor]
            
            //Links request
            let linkRequest: NSFetchRequest<LinkMO> = LinkMO.fetchRequest()
            
            //Refine link request. Only return links related to business
            let linkPredicate = NSPredicate(format: "business.name == %@", business.name!)
            linkRequest.predicate = linkPredicate
            
            do {
                subCategoryList = try context.fetch(subCategoryRequest)
                linkList = try context.fetch(linkRequest)
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
        
        //Cell uses BusinessDetailTableViewCell as template
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessDetailCell", for: indexPath) as! DetailTableViewCell
        
        //Change color to black for subcategory list
        if (businessDetails[indexPath.row].identifier == "accepts" ||
            businessDetails[indexPath.row].identifier == "subcategory_list") {
            cell.businessCellLabelValue.textColor = UIColor.black
            cell.businessCellImage.tintColor = UIColor.black
        }
        
        //Wrap characters if URL is too long for one line
        if businessDetails[indexPath.row].identifier == "website" {
            cell.businessCellLabelValue.lineBreakMode = NSLineBreakMode.byCharWrapping
        }
        
        //Configure table view cell
        cell.businessCellLabelValue.text = businessDetails[indexPath.row].value
        cell.businessCellImage.image = businessDetails[indexPath.row].image
        
        return cell
    }
    
    
    //Perform action for selected business
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Action for opening business website, phone, and address
        switch businessDetails[indexPath.row].identifier {
        case "link":
            openLink(businessDetails[indexPath.row].link)
        case "phone":
            callBusiness(businessDetails[indexPath.row].link, businessDetails[indexPath.row].value)
        case "website":
            openLink(businessDetails[indexPath.row].link)
        default:
            break
        }
    }
}
