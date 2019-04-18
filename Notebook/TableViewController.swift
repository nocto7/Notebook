//
//  ViewController.swift
//  Notebook
//
//  Created by kirsty darbyshire on 18/04/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNote))
        
        navigationItem.rightBarButtonItems = [composeButton]
    }

    @objc func composeNote() {
        let note = Note(title: "New Note", text: "", dateCreated: Date(), uuid: UUID().uuidString)
        notes.append(note)
        editNote(note: note)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        editNote(note: note)
    }
    
    func editNote(note: Note) {
        if let nvc = storyboard?.instantiateViewController(withIdentifier: "Note") as? NoteViewController {
            nvc.note = note
            nvc.delegate = self
            navigationController?.pushViewController(nvc, animated: true)
        }
    }
    
    func updateNotes(note changedNote: Note) {
        for note in notes {
            if (note.uuid == changedNote.uuid) {
                if let i = notes.firstIndex(of: note) {
                    notes.remove(at: i)
                    notes.append(changedNote)
                }
            }
        }
        tableView.reloadData()
    }

}

