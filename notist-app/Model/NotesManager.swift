//
//  NotesManager.swift
//  notist-app
//
//  Created by Marcos Martinelli on 2/15/21.
//

import Foundation

class NotesManager {
    let key = "notistApp"
    let defaultFolder = "allNotes"
    
    
    //MARK: Save and Load
    func save(newFolder: Folder, at index: Int, to allFolders: [Folder]) {
        guard let encodedData = encodeJSON(folders: allFolders) else {
            print("Error encoding")
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: key)
        
        print("saved to defaults")
    }
    
    func getSavedFolders() -> [Folder] {
        let defaults = UserDefaults.standard
        let allNotesFolder = [Folder(id: defaultFolder, name: "All Notes", notes: [Note]())]
        
        guard let savedData = defaults.object(forKey: key) as? Data,
              let folders = try? JSONDecoder().decode([Folder].self, from: savedData) else {
            return allNotesFolder
        }
        
        return folders
    }
    //MARK: Folder and Note
    func createNew(folderNamed name: String) {
        let newFolder = Folder(id: UUID().uuidString, name: name, notes: [Note]())
        
        var allFolders = getSavedFolders()
        allFolders.append(newFolder)
        
        let sortedFolders = sort(folders: allFolders)
        let index = sortedFolders.firstIndex { folder in
            folder.id == newFolder.id
        }
        
        save(newFolder: newFolder, at: index!, to: sortedFolders)
    }
    
    func sort(folders: [Folder]) -> [Folder] {
        var mutableFolders = folders
        let allNotesFolder = mutableFolders.removeFirst()
        var sortedFolders = mutableFolders.sorted { (folderA, folderB) in
            return folderA.name < folderB.name
        }
        
        sortedFolders.insert(allNotesFolder, at: 0)
        
        return sortedFolders
    }
    
    //MARK: JSON Utilities
    func encodeJSON(folders: [Folder]) -> Data? {
        let encoder = JSONEncoder()
        
        do {
            
            let encodedData = try encoder.encode(folders)
            return encodedData
            
        } catch {
            print("encodeJSON ERROR: \(error)")
            return nil
        }
    }
}
