//
//  NoteViewController.swift
//  notist-app
//
//  Created by Marcos Martinelli on 2/15/21.
//

import UIKit

protocol NotesViewControllerDelegate {
    func doneEditing(_ note: String)
}

class NoteViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    var noteBody: String!
    var delegate: NotesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        textView.text = noteBody
        textView.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            delegate?.doneEditing(textView.text)
        }
    }
}
