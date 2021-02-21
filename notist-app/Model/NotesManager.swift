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
        print("getSavedNotes()")
        return [Collection(id: defaultCollection, name: "All Notes", notes: [Note]())]
    }
}
