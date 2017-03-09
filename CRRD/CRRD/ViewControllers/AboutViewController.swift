//
//  AboutViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var dropDownMenuButton: UIBarButtonItem!
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var AboutActivityLabel: UILabel!
    @IBOutlet weak var AboutCorvallisReuseLabel: UILabel!
    private var aboutDetails: [String] = []
    
    //Gets the strings stored in the Strings.plist file
    private var strings: [String: Any] = Utils.getStrings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTheme()
        populateAboutDetails()
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
        self.title = strings["AboutActivityLabel"] as! String?
        AboutActivityLabel.text = strings["AboutActivityLabel"] as! String?
        AboutCorvallisReuseLabel.text = strings["AboutCorvallisReuse"] as! String?
        
    }
    

    /*****************************************************************************/
    //MARK: - Navigation and Data Handling
    
    //Add about details
    private func populateAboutDetails() {
        
        //Add about Corvallis ReUse reuse details
        aboutDetails.append((strings["AboutCorvallisReuseReuse"] as! String?)!)
        
        //Add about Corvallis ReUse recycle details
        aboutDetails.append((strings["AboutCorvallisReuseRecycle"] as! String?)!)
        
        //Add about Corvallis ReUse repair details
        aboutDetails.append((strings["AboutCorvallisReuseRepair"] as! String?)!)
    }
    
    
    //Button action that displays the drop down menu
    @IBAction func dropDownMenu(_ sender: UIButton) {
        
        //Reference to drop down menu view controller
        let dropDownView = (storyboard?.instantiateViewController(withIdentifier: "DropDownMenuViewController"))!
    
        //Set presentation style to popover
        dropDownView.modalPresentationStyle = UIModalPresentationStyle.popover
        
        //Setup popover presentation controller
        dropDownView.popoverPresentationController!.delegate = self
        dropDownView.popoverPresentationController!.sourceView = sender
        dropDownView.popoverPresentationController!.permittedArrowDirections = .up
        dropDownView.popoverPresentationController!.sourceRect = CGRect(x: sender.bounds.origin.x - 1, y: sender.bounds.origin.y, width: sender.bounds.size.width, height: sender.bounds.size.height)
        
        //Present the popover menu
        self.present(dropDownView, animated: false, completion: nil)
    }

    //UIPopoverPresentationController Delegate method. Forces popover instead of modal presentation for iphone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    /*****************************************************************************/
    // MARK: - Table view data source
    
    //Number of rows in table view section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutDetails.count
    }
    
    //Display about details in table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Cell uses AboutDetailCell as template
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutDetailCell", for: indexPath) as! DetailTableViewCell
        
        //Wrap words if line is too long
        cell.aboutCellLabelValue.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //Configure table view cell
        cell.aboutCellLabelValue.text = aboutDetails[indexPath.row]
        cell.aboutCellImage.image = #imageLiteral(resourceName: "check_box_black")
        
        //Change image tint and label text color
        cell.aboutCellLabelValue.textColor = UIColor.black
        cell.aboutCellImage.tintColor = UIColor.black
        
        return cell
    }
}
