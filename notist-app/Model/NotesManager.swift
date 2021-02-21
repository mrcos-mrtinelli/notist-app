//
//  NotesManager.swift
//  notist-app
//
//  Created by Marcos Martinelli on 2/15/21.
//

import Foundation

class NotesManager {
    let key = "notistApp"
    let defaultCollection = "allNotes"
    
    func getSavedNotes() -> [Collection] {
        let defaults = UserDefaults.standard
        let defaultCollections = [Collection(id: defaultCollection, name: "All Notes", notes: [Note]())]
        
        guard let savedData = defaults.object(forKey: key) as? Data,
              let collections = try? JSONDecoder().decode([Collection].self, from: savedData) else {
            return defaultCollections
        }
        
        return collections
    }
}
