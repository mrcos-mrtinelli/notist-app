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
    
    func getSavedNotes() -> [Folder] {
        let defaults = UserDefaults.standard
        let allNotesFolder = [Folder(id: defaultFolder, name: "All Notes", notes: [Note]())]
        
        guard let savedData = defaults.object(forKey: key) as? Data,
              let folders = try? JSONDecoder().decode([Folder].self, from: savedData) else {
            return allNotesFolder
        }
        
        return folders
    }
}
