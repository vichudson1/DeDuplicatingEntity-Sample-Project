//
//  NoteBook+Extension.swift
//  DeDuplicatingEntity Sample
//
//  Created by Victor Hudson on 1/16/22.
//

import Foundation
import CoreData
import DeDuplicatingEntity


extension NoteBook: DeDuplicatingEntity {
    public func moveRelationships(to destination: NoteBook) {
        guard let notes = self.notes else { return }
        destination.addToNotes(notes)
    }
}

extension NoteBook {
    static func makeNoteBooks(in context: NSManagedObjectContext) {
        for notebook in 0..<8 {
            let newNoteBook = NoteBook(context: context)
            newNoteBook.timestamp = Date()
            newNoteBook.uuid = UUID()
            newNoteBook.name = "Notebook \(notebook + 1)"
            for note in 0..<3 {
                let newNote = Note(context: context)
                newNote.notebook = newNoteBook
                newNote.uuid = UUID()
                newNote.title = "\(newNoteBook.name ?? "No Notebook") - Note \(note + 1)"
                newNote.content = """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque nisl eros,
                pulvinar facilisis justo mollis, auctor consequat urna. Morbi a bibendum metus.
                Donec scelerisque sollicitudin enim eu venenatis. Duis tincidunt laoreet ex,
                in pretium orci vestibulum eget.
                
                Class aptent taciti sociosqu ad litora torquent
                per conubia nostra, per inceptos himenaeos. Duis pharetra luctus lacus ut
                vestibulum. Maecenas ipsum lacus, lacinia quis posuere ut, pulvinar vitae dolor.
                Integer eu nibh at nisi ullamcorper sagittis id vel leo. Integer feugiat
                faucibus libero, at maximus nisl suscipit posuere.
                
                Morbi nec enim nunc.
                Phasellus bibendum turpis ut ipsum egestas, sed sollicitudin elit convallis.
                Cras pharetra mi tristique sapien vestibulum lobortis. Nam eget bibendum metus,
                non dictum mauris. Nulla at tellus sagittis, viverra est a, bibendum metus.
                """
            }
        }
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

