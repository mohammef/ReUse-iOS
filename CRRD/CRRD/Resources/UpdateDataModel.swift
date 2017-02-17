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
    
    //Clear all records from a given entity
    static func clearEntityRecords(entity: String) {
        
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
    
    //Populate Business, Category, and Subcategory entities using data parsed from xml file
    static func addToBusinessMO(businessList: [Business]) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
        
            //Process each business in 
            for business in businessList {
                
                //Create new business
                let newBusiness = BusinessMO(context: context)
                
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
                
                //Business is part of a category
                if business.categoryList.count > 0 {
                    
                    //Create fetch request for all records in Category MO
                    let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
                    
                    do {
                        //Fetch all records in the Category MO
                        let categoryListResult = try context.fetch(request) //Execute fetch request
                        var categoryResultIndex: Int

                        //Process each catagory the business belongs to
                        for category in business.categoryList {
                            var categoryFound = false
                            categoryResultIndex = 0
                            
                            //Search through Category entity results to see if category exists
                            for categoryResult in categoryListResult {
                                
                                //Category found in Category MO
                                if categoryResult.categoryName == category.name {
                                    categoryFound = true
                                    break
                                }
                                categoryResultIndex += 1
                            }
                            
                            //Add business to existing category
                            if categoryFound {
                                
                                //Create relationship between category and Business
                                categoryListResult[categoryResultIndex].addToBusiness(newBusiness)
                            
                                //Category has subcategories
                                if category.subcategoryList.count > 0 {
                                    
                                    //Process each subcategory
                                    for subCategory in category.subcategoryList {
                                        
                                        //Create new subcategory and add it to Subcategory MO
                                        let newSubCategory = SubcategoryMO(context: context)
                                        newSubCategory.subCategoryName = subCategory
                                        
                                        //Create relationship between category and subcategory
                                        categoryListResult[categoryResultIndex].addToSubcategory(newSubCategory)
                                    }
                                }
                            
                            } else { //Add business to new category
                                
                                //Create new category and add it to Category MO
                                let newCategory = CategoryMO(context: context)
                                newCategory.categoryName = category.name
                                
                                //Create relationship between category and business
                                newCategory.addToBusiness(newBusiness)
                                
                                //Category has subcategories
                                if category.subcategoryList.count > 0 {
                                    
                                    //Process each subcategory
                                    for subCategory in category.subcategoryList {
                                        
                                        //Create new subcategory and add it to Subcategory MO
                                        let newSubCategory = SubcategoryMO(context: context)
                                        newSubCategory.subCategoryName = subCategory
                                        
                                        //Create relationship between category and subcategory
                                        newCategory.addToSubcategory(newSubCategory)
                                    }
                                }
                            }
                        }
                        
                    } catch {
                        //Failed to fetch records from Category entity
                        print("Failed to retrieve record")
                        print(error)
                    }
                }
                
                //Save all records in Core Data Model
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}
