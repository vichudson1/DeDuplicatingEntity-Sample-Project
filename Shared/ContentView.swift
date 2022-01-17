//
//  ContentView.swift
//  Shared
//
//  Created by Victor Hudson on 1/16/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var buttonText:String  {
        return notebooks.count > 0 ? "Clone" : "Seed"
    }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteBook.name, ascending: true)],
        animation: .default)
    private var notebooks: FetchedResults<NoteBook>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notebooks) { item in
                    NavigationLink {
                        NoteBookView(notebook: item)
                    } label: {
                        Text(item.name!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        duplicate()
                    } label: {
                        Image(systemName: "rectangle.stack.badge.plus")
                        Text(buttonText)
                    }
                    Button {
                        deDuplicateNotebooks()
                    } label: {
                        Image(systemName: "square.stack.3d.up.slash")
                        Text("Deduplicate Notebooks")
                    }
                }
            }
            .listStyle(.plain)
            .padding(.horizontal)
            .navigationTitle("NoteBooks")
            Text("Select an item")
            
        }
    }
    
    private func duplicate() {
        NoteBook.makeNoteBooks(in: viewContext)
    }
    
    private func deDuplicateNotebooks() {
        // in a real app do this in a privateQueueConcurrencyType  context
        viewContext.perform {
            NoteBook.deduplicateBy(property: "name", in: viewContext)
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
        
    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = NoteBook(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { notebooks[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
