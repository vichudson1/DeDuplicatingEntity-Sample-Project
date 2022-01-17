//
//  NoteBookView.swift
//  DeDuplicatingEntity Sample
//
//  Created by Victor Hudson on 1/16/22.
//

import SwiftUI

struct NoteBookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var notebook: NoteBook
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.title, ascending: true)],
        animation: .default)
    private var notes: FetchedResults<Note>
    
    init (notebook: NoteBook) {
        _notebook = ObservedObject(wrappedValue: notebook)
        _notes = FetchRequest<Note>(sortDescriptors:
                                        [NSSortDescriptor(keyPath: \Note.title,
                                                          ascending: true)],
                                    predicate: NSPredicate(format: "notebook == %@", notebook))
    }
    
    var body: some View {
        List {
            ForEach(notes) { note in
                NavigationLink {
                    NoteView(note: note)
                } label: {
                    Text(note.title ?? "")
                }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.plain)
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(notebook.name ?? "NoteBook")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    deDuplicateNotes()
                } label: {
                    Image(systemName: "square.stack.3d.up.slash")
                    Text("DeDuplicate Notes")
                }
            }
        }
    }
    
    private func deDuplicateNotes() {
        // in a real app do this in a privateQueueConcurrencyType  context
        viewContext.perform {
            Note.deduplicateBy(property: "title", in: viewContext)
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)
        }
    }
    
}



//struct NoteBookView_Previews: PreviewProvider {
//    static var previews: some View {
//        // NoteBookView()
//    }
//}
