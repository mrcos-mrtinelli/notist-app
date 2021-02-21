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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.notes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = folder.notes[indexPath.row]
        let noteComponents = note.body.components(separatedBy: "\n")
        
        if noteComponents.count > 1 {
            cell.textLabel?.text = noteComponents.first
            cell.detailTextLabel?.text = noteComponents[1]
        } else {
            cell.textLabel?.text = noteComponents.first
            cell.detailTextLabel?.text = "No additional text"
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    func setupNavigationController() {
        // icon
        let newNoteIcon = UIImage(systemName: "square.and.pencil")
        
        // buttons
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let newNoteBtn = UIBarButtonItem(image: newNoteIcon, style: .plain, target: self, action: #selector((createNewNote)))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
        
        toolbarItems = [spacer, newNoteBtn]
        title = folder.name
        
        tableView.tableFooterView = UIView()
    }

    //MARK: - Actions
    @objc func createNewNote() {
        if let noteVC = storyboard?.instantiateViewController(identifier: "NoteView") as? NoteViewController {
            noteVC.delegate = self
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }
}
extension FolderViewController: NotesViewControllerDelegate {
    func doneEditing(_ note: String) {
        // stuff
    }
}
