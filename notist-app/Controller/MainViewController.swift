//
//  MainViewController.swift
//  notist-app
//
//  Created by Marcos Martinelli on 2/15/21.
//

import UIKit

class MainViewController: UITableViewController {
    var notesManager = NotesManager()
    var allNotes = [Folder]()
    
    var currentFolder = "allNotes"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Folders"
        
        tableView.tableFooterView = UIView() // remove toolbar separator/border

        setupNavigationController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        allNotes = notesManager.getSavedFolders()
        tableView.reloadData()
    }
    
    //MARK: Tableview Set Up
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
        
        if let customCell = cell as? FolderCell {
            customCell.folderTitle.text = allNotes[indexPath.row].name
            customCell.totalFolders.text = "\(allNotes[indexPath.row].notes.count)"
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
    
    //MARK: Utilities
    @objc func createNewFolder() {
        let ac = UIAlertController(title: "New Folder", message: "Enter a name for this folder", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let save = UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            guard let folderName = ac?.textFields?.first?.text else { fatalError() }
            
            self?.notesManager.createNew(folderNamed: folderName)
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Name"
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { _ in
                if textField.hasText {
                    save.isEnabled = true
                } else {
                    save.isEnabled = false
                }
            }
        }
        save.isEnabled = false
        ac.addAction(cancel)
        ac.addAction(save)
        
        present(ac, animated: true)
        
    }
    @objc func createNewNote() {
        
    }
}

