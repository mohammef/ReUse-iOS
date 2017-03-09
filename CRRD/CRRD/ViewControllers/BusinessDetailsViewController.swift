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

    //Holds the business details used in the table view cells below
    private struct BusinessDetails {
        var identifier = ""
        var value = ""
        var link = ""
        var image: UIImage! = nil
    }
    
    @IBOutlet weak var dropDownMenuButton: UIBarButtonItem!
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var businessNameLabel: UILabel!
    private var subCategoryList: [SubcategoryMO] = []
    private var linkList: [LinkMO] = []
    private var businessDetails: [BusinessDetails] = []
    var business: BusinessMO! = nil
    
    
    //Executes after view controller is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTheme()
        loadData()
        populateBusinessDetailsList()
    }
    
    //Add business info
    private func populateBusinessDetailsList() {
        
        //Add business address
        if business.address_line_1 != "" {
            let address = "\(business.address_line_1!) \n\(business.city!) \(business.state!) \(business.zip)"
            
            //Link to open address in Apple Maps. Remove "\n" character and replace " " with "%20"
            let addressLink = "http://maps.apple.com/?q=" + address.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "%20")
            
            businessDetails.append(BusinessDetails(identifier: "address", value: address, link: addressLink, image: #imageLiteral(resourceName: "place_black")))
        }
        
        //Add business phone number
        if business.phone != "" {
            businessDetails.append(BusinessDetails(identifier: "phone", value: formatPhone(business.phone!), link: business.phone!, image: #imageLiteral(resourceName: "phone_black")))
        }
        
        //Add business website
        if business.website != "" {
            businessDetails.append(BusinessDetails(identifier: "website", value: business.website!, link: business.website!, image: #imageLiteral(resourceName: "public_black")))
        }

        //Add business subcategory list
        if subCategoryList.count > 0 {
            businessDetails.append(BusinessDetails(identifier: "accepts", value: "\(business.name!) Accepts the Following:", link: "", image: #imageLiteral(resourceName: "check_box_black")))
            
            //Format subcategory list for display in table view cell
            var subCategories = ""
            for subcategory in subCategoryList {
                subCategories += "\(subcategory.subCategoryName!)\n"
            }

            businessDetails.append(BusinessDetails(identifier: "subcategory_list", value: subCategories, link: "", image: nil))
        }
        
        //Add business links
        if linkList.count > 0 {
            for link in linkList {
                businessDetails.append(BusinessDetails(identifier: "link", value: link.linkName!, link: link.uri!, image: #imageLiteral(resourceName: "link_black")))
            }
        }
    }
    
    //Format US phone number for display
    private func formatPhone(_ phoneNumber: String) -> String {
        
        switch phoneNumber.characters.count {
        //Returns number in 555-5555 format
        case 7:
            return String(format: "%@-%@", subString(phoneNumber,0,3), subString(phoneNumber,3,7))
        //Returns number in (555)555-5555 format
        case 10:
            return String(format: "(%@)%@-%@", subString(phoneNumber,0,3), subString(phoneNumber,3,6), subString(phoneNumber,6,10))
        //Removes leading 1 and returns number in (555)555-5555 format
        case 11:
            return String(format: "(%@)%@-%@", subString(phoneNumber,1,4), subString(phoneNumber,4,7), subString(phoneNumber,7,11))
        default:
            return phoneNumber
        }
    }
    
    //Returns a substring from using the given start and end index
    private func subString(_ string: String,_ start: Int,_ end: Int) -> String {
        let start = string.index(string.startIndex, offsetBy: start)
        let end = string.index(string.startIndex, offsetBy: end)
        let range = start..<end
        return string.substring(with: range)
    }
    
    
    /*****************************************************************************/
    //MARK: - Theme
    
    //Adjusts look of items in view
    private func viewTheme(){
       
        //Hide back button label from the navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Move the home and drop down menu buttons further to the right
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -6
        
        self.navigationItem.setRightBarButtonItems([negativeSpacer, dropDownMenuButton, homeButton], animated: false)
        
        //Set view label text
        self.title = business?.name
        businessNameLabel.text = business?.name
    }
    
    
    /*****************************************************************************/
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
        dropDownView.popoverPresentationController!.permittedArrowDirections = .up
        
        //Present the popover menu
        self.present(dropDownView, animated: false, completion: nil)
    }
    
    //UIPopoverPresentationController Delegate method. Forces popover instead of modal presentation for iphone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    //Displays an alert on the screen and prompts the user with a choice to navigate to the link
    private func openLink(_ link: String,_ value: String,_ alertTitle: String) {
        
        //Setup alert menu
        let alertMenu = UIAlertController(title: nil, message: alertTitle, preferredStyle: .actionSheet)
        let cancelAlertMenu = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Setup action that allows the user to open the link when pressed
        let actionHandler = { (action:UIAlertAction) -> Void in
            
            //Error message when link cannot be opened
            let openLinkError = UIAlertController(title: "Service Unavailable", message: "Unable to open. Please try again later", preferredStyle: .alert)
            openLinkError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            //Error message when link is invalid
            let invalidLinkError = UIAlertController(title: "Error", message: "An unexpected error occured. Please try again later", preferredStyle: .alert)
            invalidLinkError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            //Try to open link and handle errors
            if let linkURL = NSURL(string: link) as? URL {
            
                //Link can be opened
                if UIApplication.shared.canOpenURL(linkURL) {
                   UIApplication.shared.open(linkURL, options: [:], completionHandler: nil)
                    
                } else { self.present(openLinkError, animated: true, completion:  nil) }
            
            } else { self.present(invalidLinkError, animated: true, completion:  nil) }
        }
        let linkAction = UIAlertAction(title: "\(value)", style: .default, handler: actionHandler)
        
        //Add call and cancel actions to the alert menu
        alertMenu.addAction(linkAction)
        alertMenu.addAction(cancelAlertMenu)
        
        present(alertMenu, animated: true, completion:  nil)
    }
    
    
    /*****************************************************************************/
    // MARK: - Table view data source
    
    //Load from core data model
    private func loadData() {
        
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
            } catch { print("Failed to retrieve record: \(error)") }
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
        case "address":
            openLink(businessDetails[indexPath.row].link, businessDetails[indexPath.row].value , "Open in Apple Maps")
        case "link":
            openLink(businessDetails[indexPath.row].link, businessDetails[indexPath.row].value , "Open")
        case "phone":
            openLink("tel://+1\(businessDetails[indexPath.row].link)", businessDetails[indexPath.row].value, "Call \(business.name!)")
        case "website":
            openLink(businessDetails[indexPath.row].link, businessDetails[indexPath.row].value  ,"Open Website")
        default:
            break
        }
    }
}
