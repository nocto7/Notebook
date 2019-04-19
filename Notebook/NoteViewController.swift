//
//  NoteViewController.swift
//  Notebook
//
//  Created by kirsty darbyshire on 18/04/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UIActivityItemSource {
    var note: Note!
    weak var delegate: TableViewController! // https://www.hackingwithswift.com/example-code/system/how-to-pass-data-between-two-view-controllers
    @IBOutlet var noteText: UITextView!
    @IBOutlet var noteTitle: UILabel!
    @IBOutlet var noteDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteTitle.text = note.title
        noteDate.text = "Created: \(note.dateCreated)"
        noteText.text =  note.text
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        let editButton = UIBarButtonItem(title: "Edit Title", style: .plain, target: self, action: #selector(edit))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [saveButton, editButton, shareButton]
        
        // fixing keyboard prob
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func save() {
        saveText()
        navigationController?.popViewController(animated: true)
    }
    
    func saveText() {
        note.text = noteText.text
        delegate.updateNotes(note: note)
    }
    
    @objc func edit() {
        let ac = UIAlertController(title: "Edit Title", message: nil, preferredStyle: .alert)
        ac.addTextField() {
            textField in
            textField.text = self.note.title
        }
        let editAction = UIAlertAction(title: "Save", style: .default) {
            [weak self] _ in
            guard let newTitle = ac.textFields?[0].text else { return }
            self?.note.title = newTitle
            self?.noteTitle.text = self?.note.title
        }
        ac.addAction(editAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
    // https://www.hackingwithswift.com/articles/118/uiactivityviewcontroller-by-example
    @objc func share() {
        saveText()
        let items = [self]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
 
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return note.text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return note.text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return note.title
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteText.contentInset = .zero
        } else {
            noteText.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        noteText.scrollIndicatorInsets = noteText.contentInset
        
        let selectedRange = noteText.selectedRange
        noteText.scrollRangeToVisible(selectedRange)
    }
}
