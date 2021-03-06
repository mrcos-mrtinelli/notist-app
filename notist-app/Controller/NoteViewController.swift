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
        
        // from hackingwithswift.com
        // notify when keyboard changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // add padding to textview
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        navigationItem.largeTitleDisplayMode = .never
        
        textView.delegate = self
        textView.text = noteBody
        textView.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            delegate?.doneEditing(textView.text)
        }
    }
    // from hackingwithswift.com
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    @objc func share() {
        guard let noteBody = noteBody else { return }
        let activityVC = UIActivityViewController(activityItems: [noteBody], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    func updateNavigationItem() {
        if textView.text != "" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateNavigationItem()
    }
    func textViewDidChange(_ textView: UITextView) {
        updateNavigationItem()
    }
}
