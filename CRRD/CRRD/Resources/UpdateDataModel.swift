//
//  UpdateDataModel.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 2/10/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import CoreData
import UIKit

class UpdateDataModel {
    
    /***********************************************************************************/
    //Clear all records from a given entity
    /***********************************************************************************/
    static func clearEntityRecords(_ entity: String) {
        
        // Load entity from database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let context = appDelegate.persistentContainer.viewContext
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest) //Batch Delete Request
            
            do {
                try context.execute(batchDeleteRequest)
            } catch {
                print(error)
            }
        }
    }
    
    /***********************************************************************************/
    //Populate core data model objects using data parsed from xml file
    /***********************************************************************************/
    static func addToBusinessMO(_ businessList: [Business]) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
        
            //Process each business in 
            for business in businessList {
                
                //Tuple containing result of business core data search. If found
                //it is returned, else a new business is returned
                let businessResult: (businessMO: BusinessMO, result: Bool) = getBusiness(business, context)
                
                //Business was not found in core data
                if !businessResult.result {
                
                    //New business
                    let newBusiness = businessResult.businessMO
                    
                    //Populate business
                    newBusiness.setValue(business.name, forKey: "name")
                    newBusiness.setValue(business.database_id, forKey: "id")
                    newBusiness.setValue(business.address_1, forKey: "address_line_1")
                    newBusiness.setValue(business.address_2, forKey: "address_line_2")
                    newBusiness.setValue(business.city, forKey: "city")
                    newBusiness.setValue(business.state, forKey: "state")
                    newBusiness.setValue(business.zip, forKey: "zip")
                    newBusiness.setValue(business.phone, forKey: "phone")
                    newBusiness.setValue(business.website, forKey: "website")
                    newBusiness.setValue(business.latitude, forKey: "latitude")
                    newBusiness.setValue(business.longitude, forKey: "longitude")
                    newBusiness.setValue(business.recycleBusiness, forKey: "recycleBusiness")
                    
                    
                    //Business is part of a category
                    if business.categoryList.count > 0 {
                        
                        //Create fetch request for all records in Category MO
                        let categoryRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
                        
                        do {
                            //Fetch all records in the Category MO
                            let categoryListResult = try context.fetch(categoryRequest)

                            //Process each catagory the business belongs to
                            for businessCategoryListItem in business.categoryList {
                                
                                //Get category from Category MO or create new category if it doesn't exist
                                let category = getCategory(categoryListResult, businessCategoryListItem, context)
                                
                                //Create relationship between category and business
                                category.addToBusiness(newBusiness)
                                
                                //Category has subcategories
                                if businessCategoryListItem.subcategoryList.count > 0 {
                                    
                                    //Create fetch request for all records in Subcategory MO
                                    let subcategoryRequest: NSFetchRequest<SubcategoryMO> = SubcategoryMO.fetchRequest()
                                    
                                    do {
                                        //Fetch all records in the Subcategory MO
                                        let subcategoryListResult = try context.fetch(subcategoryRequest)
                                        
                                        //Process each subcategory
                                        for subCategoryListItem in businessCategoryListItem.subcategoryList {
                                            
                                            //Get subcategory from Subcategory MO or create new subcategory if it doesn't exist
                                            let subCategory = getSubcategory(subcategoryListResult, subCategoryListItem, context)
                                            
                                            //Create relationship between subcategory and business
                                            subCategory.addToBusiness(newBusiness)
                                            
                                            //Create relationship between category and subcategory
                                            subCategory.addToCategory(category)
                                        }
                                    } catch { //End subcategory fetch request
                                        print("Failed to retrieve record")
                                        print(error)
                                    }
                                }
                            }
                        } catch { //End category fetch request
                            print("Failed to retrieve record")
                            print(error)
                        }
                    }
                
                
                    //Business has links
                    if business.linkList.count > 0 {

                        //Process each link in business link list
                        for link in business.linkList {
                            
                            //Create relationship between business and link
                            newBusiness.addToLink(getLink(link, context))
                        }
                    }
                }
                
                //Save all records in core data model
                do { try context.save() } catch { print(error) }
            }
        }
    }
    
    /***********************************************************************************/
    //Search through Business MO for a business.
    //If it exits, return it. Otherwise, create and return new business
    /***********************************************************************************/
    private static func getBusiness(_ business: Business,
                                    _ context: NSManagedObjectContext) -> (BusinessMO, Bool) {
        
        var businessResult: [BusinessMO] = []
        
        //Load Businesses from core data model
        let request: NSFetchRequest<BusinessMO> = BusinessMO.fetchRequest()
        
        //Refine request. In this case, return the business that matches business database_id
        let predicate = NSPredicate(format: "id == %@", business.database_id as NSNumber)
        request.predicate = predicate

        do {
             businessResult = try context.fetch(request)
        } catch {
            print("Failed to retrieve record")
            print(error)
        }
        
        //Business was found
        if businessResult.count > 0 {
            
            //If it is recycle business it will be set to true
            businessResult[0].recycleBusiness = business.recycleBusiness
            
            return (businessResult[0], true)
        }
        
        //Business was not found.
        return (BusinessMO(context: context), false)
    }
    
    /***********************************************************************************/
    //Search through Category MO for a category. 
    //If it exits, return it. Otherwise, create and return new category
    /***********************************************************************************/
    private static func getCategory(_ categoryList: [CategoryMO],
                                    _ category: Category,
                                    _ context: NSManagedObjectContext) -> CategoryMO {
        
        //Search through Category MO results to see if category exists
        for categoryListItem in categoryList {

            //Category found in Category MO
            if categoryListItem.categoryName == category.name {
                return categoryListItem
            }
        }
        
        //Category not found. Create new category and add it to Category MO
        let newCategory = CategoryMO(context: context)
        newCategory.categoryName = category.name
        return newCategory
    }
    
    /***********************************************************************************/
    //Search through Subcategory MO for a subcategory.
    //If it exits, return it. Otherwise, create and return new subcategory
    /***********************************************************************************/
    private static func getSubcategory(_ subCategoryList: [SubcategoryMO],
                                       _ subCategory: String,
                                       _ context: NSManagedObjectContext) -> SubcategoryMO {
        
        //Search through Subcategory MO results to see if subcategory exists
        for subCategoryListItem in subCategoryList {
            
            //Category found in Subcategory MO
            if subCategoryListItem.subCategoryName == subCategory {
                return subCategoryListItem
            }
        }
        
        //Subcategory not found. Create new subcategory and add it to Subcategory MO
        let newSubCategory = SubcategoryMO(context: context)
        newSubCategory.subCategoryName = subCategory
        return newSubCategory
    }
    
    /***********************************************************************************/
    //Search through Link MO for a Link.
    //If it exits, return it. Otherwise, create and return new link
    /***********************************************************************************/
    private static func getLink(_ link: Link, _ context: NSManagedObjectContext) -> LinkMO {
        
        var linkResult: [LinkMO] = []
        
        //Load Links from core data model
        let request: NSFetchRequest<LinkMO> = LinkMO.fetchRequest()
        
        //Refine request. In this case, return business that matches business database_id
        let predicate = NSPredicate(format: "linkName == %@", link.name)
        request.predicate = predicate

        do {
            linkResult = try context.fetch(request)
        } catch {
            print("Failed to retrieve record")
            print(error)
        }
        
        //Link was found. Return it
        if linkResult.count > 0 {
            return linkResult[0]
        }
        
        //Link not found, Create and return a new Link
        let newLink = LinkMO(context: context)
        newLink.linkName = link.name
        newLink.uri = link.uri
        return newLink
    }
}

