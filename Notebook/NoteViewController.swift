//
//  NoteViewController.swift
//  Notebook
//
//  Created by kirsty darbyshire on 18/04/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
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
        navigationItem.rightBarButtonItems = [saveButton, editButton]
    }
    
    @objc func save() {
        note.text = noteText.text
        delegate.updateNotes(note: note)
        navigationController?.popViewController(animated: true)
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
    

 

}
