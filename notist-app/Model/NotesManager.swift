//
//  NotesManager.swift
//  notist-app
//
//  Created by Marcos Martinelli on 2/15/21.
//

import Foundation

protocol NotesManagerDelegate {
    func didSave(folder: Folder, at index: Int)
    func didSave(note: Note, to folders: [Folder])
}

class NotesManager {
    let key = "notistApp"
    let defaultFolder = "allNotes"
    var delegate: NotesManagerDelegate?
    
    
    //MARK: Save and Load
    func save(newFolder: Folder, at index: Int, to allFolders: [Folder]) {
        guard let encodedData = encodeJSON(folders: allFolders) else {
            print("Error encoding")
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: key)
        
        delegate?.didSave(folder: newFolder, at: index)
    }
    func save(newNote: Note, to folders: [Folder]) {
        guard let encodedData = encodeJSON(folders: folders) else {
            print("error encoding")
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: key)
        
        delegate?.didSave(note: newNote, to: folders)
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
        let index = getFolderIndex(for: newFolder.id, in: sortedFolders)
        
        save(newFolder: newFolder, at: index, to: sortedFolders)
    }
    func createNew(note: String, in folderID: String) {
        let newNote = Note(id: UUID().uuidString, body: note)
        
        var savedFolders = getSavedFolders()
        let index = getFolderIndex(for: folderID, in: savedFolders)
        
        savedFolders[index].notes.append(newNote)
        
        save(newNote: newNote, to: savedFolders)
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
    func getFolderIndex(for folderID: String, in folders: [Folder]) -> Int {
        if let folderIndex = folders.firstIndex(where: {(folder) in folder.id == folderID}) {
            return folderIndex
        }
        return 0
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

//extension NotesManagerDelegate {
//    func didSave(folder: Folder, at index: Int) {}
//    func didSave(note: Note, to: [Folder]) {}
//}
