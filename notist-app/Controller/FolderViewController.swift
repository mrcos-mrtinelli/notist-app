//
//  FolderViewController.swift
//  notist-app
//
//  Created by Marcos Martinelli on 2/15/21.
//

import UIKit

class FolderViewController: UITableViewController {
    
    var notesManager = NotesManager()
    var currentFolderID: String!
    var folder: Folder!
    var isNewNote: Bool!
    var selectedNoteID: String!
    var notesCountLabel: UILabel!
    
    var notesCount = 0 {
        didSet {
            notesCountLabel.text = "\(notesCount) notes"
        }
    }
    
    var shareNotes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesManager.delegate = self
        setupNavigationController()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.notes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = folder.notes[indexPath.row]
        let noteComponents = note.body.components(separatedBy: "\n")
        
        if noteComponents.count > 1 && noteComponents[1] != "" {
            cell.textLabel?.text = noteComponents.first
            cell.detailTextLabel?.text = noteComponents[1]
        } else {
            cell.textLabel?.text = noteComponents.first
            cell.detailTextLabel?.text = "No additional text"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let noteVC = storyboard?.instantiateViewController(identifier: "NoteView") as? NoteViewController {
            noteVC.delegate = self
            noteVC.noteBody = folder.notes[indexPath.row].body
            
            isNewNote = false
            selectedNoteID = folder.notes[indexPath.row].id
            
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = folder.notes[indexPath.row]
            
            notesManager.delete(note: note, fromFolder: folder)
        }
    }
    
    // MARK: - Navigation
    func setupNavigationController() {
        // icon and custom view
        let newNoteIcon = UIImage(systemName: "square.and.pencil")
        notesCountLabel = UILabel(frame: CGRect(x: .zero, y: .zero, width: 200, height: 21))
        notesCountLabel.textAlignment = .center
        notesCount = folder.notes.count
        
        // buttons
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let toolbarLabel = UIBarButtonItem(customView: notesCountLabel)
        let newNoteBtn = UIBarButtonItem(image: newNoteIcon, style: .plain, target: self, action: #selector((createNewNote)))
        
        navigationItem.rightBarButtonItem = self.editButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
        
        toolbarItems = [spacer, toolbarLabel, spacer, newNoteBtn]
        title = folder.name
        
        tableView.tableFooterView = UIView()
    }

    //MARK: - Actions
    @objc func createNewNote() {
        if let noteVC = storyboard?.instantiateViewController(identifier: "NoteView") as? NoteViewController {
            noteVC.delegate = self
            
            isNewNote = true
            
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }
    @objc func share() {
        for note in shareNotes {
            print(note.body)
        }
    }
}
extension FolderViewController: NotesViewControllerDelegate {
    func doneEditing(_ note: String) {
        if isNewNote {
            guard note != "" else { return }
            notesManager.createNew(note: note, in: currentFolderID)
        } else {
            notesManager.update(note: note, noteID: selectedNoteID, folderID: currentFolderID)
        }
    }
}
//MARK: - Extensions
extension FolderViewController: NotesManagerDelegate {
    func didSave(note: Note, to folders: [Folder]) {
        let index = notesManager.getFolderIndex(for: currentFolderID, in: folders)
        
        folder = folders[index]
        setupNavigationController()
        
        tableView.reloadData()
    }
    func didDelete(noteFromFolder: Folder, at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        folder = noteFromFolder
        notesCount = folder.notes.count

        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
