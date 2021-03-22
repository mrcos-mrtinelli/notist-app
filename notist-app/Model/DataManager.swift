//
//  DataManager.swift
//  notist-app
//
//  Created by Marcos Martinelli on 3/21/21.
//
import CoreData
import UIKit

class DataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Load and Save Methods
    func loadFolders() -> [Folder]? {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        
        do {
            let allFolders = try context.fetch(request)
            return allFolders
        } catch {
            print("There was an error loading folders: \(error)")
            return nil
        }
    }
    
    //MARK: - Data Manipulation Methods
    func createNewFolder(name: String) {
        let newFolder = Folder(context: context)
        newFolder.id = UUID()
        newFolder.name = name
        
        do {
            try context.save()
        } catch {
            print("There was an error saving new folder: \(error)")
        }
    }
}
