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
    
    //MARK: - Pre-load "All Notes" folder
    func preLoadData() {
        let folderCount = loadFolders()?.count
        
        if folderCount == 0 {
            createNewFolder(name: "All Notes", id: "allNotesFolder")
        }
        
        return
    }
    
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
    func createNewFolder(name: String, id: String? = UUID().uuidString) {
        let newFolder = Folder(context: context)
        newFolder.name = name
        newFolder.id = id
        
        do {
            try context.save()
        } catch {
            print("There was an error saving new folder: \(error)")
        }
    }
}
