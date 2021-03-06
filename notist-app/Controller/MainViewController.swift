//
//  MainViewController.swift
//  notist-app
//
//  Created by Marcos Martinelli on 2/15/21.
//

import UIKit

class MainViewController: UITableViewController {
    var searchController: UISearchController!
    let dataManager = DataManager()
    var allFolders: [Folder]?
    var filteredResults = [Folder]()
    
    var currentFolderID = "allNotesFolder"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Folders"
        tableView.tableFooterView = UIView() // remove toolbar separator/border
        
        dataManager.preLoadData()
        dataManager.delegate = self
        setupNavigationController()
        setupSearchBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFolders()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
        
        if let customCell = cell as? FolderCell {
            customCell.folderTitle.text = filteredResults[indexPath.row].name
            customCell.totalFolders.text = "\(filteredResults[indexPath.row].notesCount)"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if let folderVC = storyboard?.instantiateViewController(identifier: "FolderView") as? FolderViewController {
            folderVC.currentFolderID = filteredResults[indexPath.row].id
            folderVC.folder = filteredResults[indexPath.row]
            folderVC.notes = filteredResults[indexPath.row].notes?.allObjects as? [Note]
            
            navigationController?.pushViewController(folderVC, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0 {
            return .none
        }
        return .delete
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let folder = filteredResults[indexPath.row]
//
//            if folder.notes.count > 0 {
//                let ac = UIAlertController(title: "Warning", message: "Deleting \"\(folder.name)\" will also delete \(filteredResults[indexPath.row].notes.count) notes.", preferredStyle: .alert)
//                let cancel = UIAlertAction(title: "Cancel", style: .cancel)
//                let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
//                    guard let self = self else { return }
//                    self.notesManager.delete(folder: folder)
//                }
//
//                ac.addAction(cancel)
//                ac.addAction(delete)
//
//                present(ac, animated: true)
//
//            } else {
//                notesManager.delete(folder: folder)
//            }
//        }
    }
    
    //MARK: - Setup
    func setupNavigationController() {
        // icons
        let newFolderIcon = UIImage(systemName: "folder.badge.plus")
        let newNoteIcon = UIImage(systemName: "square.and.pencil")
        
        // buttons
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let newFolderBtn = UIBarButtonItem(image: newFolderIcon, style: .plain, target: self, action: #selector(createNewFolder))
        let newNoteBtn = UIBarButtonItem(image: newNoteIcon, style: .plain, target: self, action: #selector(createNewNote))
        
        // navigationController
        navigationItem.rightBarButtonItem = self.editButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barTintColor = .white
        navigationController?.toolbar.clipsToBounds = true
        toolbarItems = [newFolderBtn, spacer, newNoteBtn]
        
    }
    func setupSearchBar() {
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.delegate = self
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.sizeToFit()
//        searchController.dimsBackgroundDuringPresentation = false
//
//        searchController.searchBar.delegate = self
//        searchController.searchBar.autocapitalizationType = .none
//
//        definesPresentationContext = true
//        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    //MARK: - Utilities
    func loadFolders(withID: String? = nil) {
        guard let loadedFolders = dataManager.loadFolders() else { return }
        
        allFolders = loadedFolders
        filteredResults = loadedFolders
        
        if let newFolderID = withID {
            let index = dataManager.getFolderIndex(for: newFolderID, in: filteredResults)
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            filteredResults = loadedFolders
            tableView.reloadData()
        }
    }
    @objc func createNewFolder() {
        let ac = UIAlertController(title: "New Folder", message: "Enter a name for this folder", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let save = UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            guard let folderName = ac?.textFields?.first?.text else { fatalError() }
            guard let self = self else { return }
            
            if let newFolderID = self.dataManager.createNewFolder(name: folderName) {
                DispatchQueue.main.async {
                    self.loadFolders(withID: newFolderID)
                }
            }
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
        if let noteVC = storyboard?.instantiateViewController(identifier: "NoteView") as? NoteViewController {
            noteVC.delegate = self
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }
//extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
//    func updateSearchResults(for searchController: UISearchController) {
//
//        if let searchText = searchController.searchBar.text {
//            // trim whitespace
//            let whiteSpace = CharacterSet.whitespaces
//            let strippedSearchText = searchText.trimmingCharacters(in: whiteSpace).lowercased()
//
//            filteredResults = searchText.isEmpty ? allFolders : allFolders.filter { (folder) in
//                return folder.name.lowercased().contains(strippedSearchText)
//            }
//        }
//        tableView.reloadData()
//    }
//}
//extension MainViewController: NotesManagerDelegate {
//    func didSave(folder: Folder, at index: Int) {
//        allFolders.insert(folder, at: index)
//        filteredResults = allFolders
//        let indexPath = IndexPath(row: index, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//    }
//    func didSave(note: Note, to folders: [Folder]) {
//        allFolders = folders
//        filteredResults = allFolders
//        tableView.reloadData()
//    }
//    func didDelete(folderAt: Int, from folders: [Folder]) {
//        let indexPath = IndexPath(row: folderAt, section: 0)
//
//        allFolders = folders
//        filteredResults = allFolders
//
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//    }
//}
}
extension MainViewController: DataManagerDelegate {
    func didSave() {
        loadFolders()
    }
}
extension MainViewController: NotesViewControllerDelegate {
    func doneEditing(_ note: String) {
        guard note != "" else { return }
        guard let allFolders = allFolders else { return }
        let index = dataManager.getFolderIndex(for: currentFolderID, in: allFolders)
        let currentFolder = allFolders[index]
        
        let newNoteID = dataManager.createNew(note: note, in: currentFolder)
        tableView.reloadData()
        print("Saved new note with ID: \(newNoteID!)")
    }
}
