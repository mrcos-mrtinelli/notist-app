//
//  ViewController.swift
//  notist-app
//
//  Created by Marcos Martinelli on 2/15/21.
//

import UIKit

class MainViewController: UITableViewController {
    var notesManager = NotesManager()
    var allNotes = [Collection]()
    
    var currentFolder = "allNotes"
    
    override func viewWillAppear(_ animated: Bool) {
        allNotes = notesManager.getSavedNotes()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Collections"
        
        tableView.tableFooterView = UIView() // remove toolbar separator/border

        setupNavigationController()
    }
    
    //MARK: Tableview Set Up
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath)
        
        if let customCell = cell as? CollectionCell {
            customCell.collectionTitle.text = allNotes[indexPath.row].name
            customCell.totalCollections.text = "\(allNotes[indexPath.row].notes.count)"
        }
        
        return cell
    }
    //MARK: Navigation Controller Set up
    func setupNavigationController() {
        // icons
        let newFolderIcon = UIImage(systemName: "folder.badge.plus")
        let newNoteIcon = UIImage(systemName: "square.and.pencil")
        
        // buttons
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let newFolderBtn = UIBarButtonItem(image: newFolderIcon, style: .plain, target: self, action: #selector(createNewFolder))
        let newNoteBtn = UIBarButtonItem(image: newNoteIcon, style: .plain, target: self, action: #selector(createNewNote))
        
        // navigationController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barTintColor = .white
        navigationController?.toolbar.clipsToBounds = true
        toolbarItems = [newFolderBtn, spacer, newNoteBtn]
        
    }
    
    //MARK: Actions
    @objc func createNewFolder() {
        
    }
    @objc func createNewNote() {
        
    }
}

