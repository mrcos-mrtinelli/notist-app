//
//  Folder.swift
//  notist-app
//
//  Created by Marcos Martinelli on 2/15/21.
//

import Foundation

struct Folder: Codable {
    var id: String
    var name: String
    var notes: [Note]
}
