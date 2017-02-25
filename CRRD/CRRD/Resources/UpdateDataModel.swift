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
    
    /***********************************************************************************/
    //Populate Business, Category, and Subcategory entities using data parsed from xml file
    /***********************************************************************************/
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
                    let categoryRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
                    
                    do {
                        //Fetch all records in the Category MO
                        let categoryListResult = try context.fetch(categoryRequest) //Execute fetch request

                        //Process each catagory the business belongs to
                        for businessCategoryListItem in business.categoryList {
                            
                            //Get category from Category MO or create new category if it doesn't exist
                            let category = getCategory(categoryList: categoryListResult, category: businessCategoryListItem, context: context)
                            
                            //Create relationship between category and business
                            category.addToBusiness(newBusiness)
                            
                            //Category has subcategories
                            if businessCategoryListItem.subcategoryList.count > 0 {
                                /*
                                //Process each subcategory
                                for subCategory in businessCategoryListItem.subcategoryList {
                                    
                                    //Create new subcategory and add it to Subcategory MO
                                    let newSubCategory = SubcategoryMO(context: context)
                                    newSubCategory.subCategoryName = subCategory
                                    
                                    //Create relationship between category and subcategory
                                    category.addToSubcategory(newSubCategory)
                                }
                                */
                                
                                //Create fetch request for all records in Subcategory MO
                                let subcategoryRequest: NSFetchRequest<SubcategoryMO> = SubcategoryMO.fetchRequest()
                                
                                do {
                                    //Fetch all records in the Subcategory MO
                                    let subcategoryListResult = try context.fetch(subcategoryRequest)
                                    
                                    //Process each subcategory
                                    for subCategoryListItem in businessCategoryListItem.subcategoryList {
                                        
                                        //Get subcategory from Subcategory MO or create new subcategory if it doesn't exist
                                        let subCategory = getSubcategory(subCategoryList: subcategoryListResult, subCategory: subCategoryListItem, context: context)
                                        
                                        //Create relationship between subcategory and business
                                        subCategory.addToBusiness(newBusiness)
                                        
                                        //Create relationship between category and subcategory
                                        //category.addToSubcategory(subCategory)
                                        subCategory.addToCategory(category)
                                        
                                        
                                    }
                                } catch {
                                    //Failed to fetch records from Subcategory MO
                                    print("Failed to retrieve record")
                                    print(error)
                                }
                                    
                                
                            }
                        }
                        
                        
                    } catch {
                        //Failed to fetch records from Category MO
                        print("Failed to retrieve record")
                        print(error)
                    }
                }
                
                //Save all records in core data model
                do { try context.save() } catch { print(error) }
            }
        }
    }
    
    /***********************************************************************************/
    //Search through Category MO for a category. 
    //If it exits, return it. Otherwise, create and return new category
    /***********************************************************************************/
    private static func getCategory(categoryList: [CategoryMO],
                                    category: Category,
                                    context: NSManagedObjectContext) -> CategoryMO {
        
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
    private static func getSubcategory(subCategoryList: [SubcategoryMO],
                                       subCategory: String,
                                       context: NSManagedObjectContext) -> SubcategoryMO {
        
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
    
}
