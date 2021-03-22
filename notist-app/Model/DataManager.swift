//
//  DataManager.swift
//  notist-app
//
//  Created by Marcos Martinelli on 3/21/21.
//
import CoreData
import UIKit

protocol DataManagerDelegate {
    func didSave()
}

class DataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: DataManagerDelegate?
    
    //MARK: - Pre-load "All Notes" folder
    func preLoadData() {
        let folderCount = loadFolders()?.count
        
        if folderCount == 0 {
            let newFolder = Folder(context: context)
            newFolder.name = "All Notes"
            newFolder.id = "allNotesFolder"
            
            do {
                try context.save()
                delegate?.didSave()
            } catch {
                print("There was an error creating default folder: \(error)")
            }
        }
        return
    }
    
    //MARK: - Load and Save Methods
    func save() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print("There was an error saving: \(error)")
            return false
        }
    }
    func loadFolders() -> [Folder]? {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        
        do {
            let allFolders = try context.fetch(request)
            
            if allFolders.count > 1 {
                return sort(folders: allFolders)
            } else {
                return allFolders
            }
            
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
        
        if save() {
            return folderID
        }
        
        return nil
    }
    func createNew(note: String, in folder: Folder) -> String? {
        let newNote = Note(context: context)
        let noteID = UUID().uuidString
        
        newNote.body = note
        newNote.id = noteID
        newNote.parentFolder = folder
        
        if save() {
            return noteID
        }
        
        return nil
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
    
    //MARK: - Utilities
    func getFolderIndex(for folderID: String, in folders: [Folder]) -> Int {
        if let folderIndex = folders.firstIndex(where: {(folder) in folder.id == folderID}) {
            return folderIndex
        }
        return 0
    }
}
