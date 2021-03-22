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
            let newFolder = Folder(context: context)
            newFolder.name = "All Notes"
            newFolder.id = "allNotesFolder"
            
            do {
                try context.save()
            } catch {
                print("There was an error creating default folder: \(error)")
            }
        }
        return
    }
    
    //MARK: - Load and Save Methods
    func loadFolders() -> [Folder]? {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        
        do {
            let allFolders = try context.fetch(request)
            let sorted = sort(folders: allFolders)
            return sorted
        } catch {
            print("There was an error loading folders: \(error)")
            return nil
        }
    }
    
    //MARK: - Data Manipulation Methods
    func createNewFolder(name: String) -> String? {
        let newFolder = Folder(context: context)
        let folderID = UUID().uuidString
        
        newFolder.name = name
        newFolder.id = folderID
        
        do {
            try context.save()
            return folderID
        } catch {
            print("There was an error saving new folder: \(error)")
            return nil
        }
    }
    func sort(folders: [Folder]) -> [Folder] {
        var mutableFolders = folders
        let allNotesFolder = mutableFolders.removeFirst()
        var sortedFolders = mutableFolders.sorted { (folderA, folderB) in
            return folderA.name! < folderB.name!
        }
        
        sortedFolders.insert(allNotesFolder, at: 0)
        
        return sortedFolders
    }
    func getFolderIndex(for folderID: String, in folders: [Folder]) -> Int {
        if let folderIndex = folders.firstIndex(where: {(folder) in folder.id == folderID}) {
            return folderIndex
        }
        return 0
    }
}
