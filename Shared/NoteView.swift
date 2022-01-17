//
//  NoteView.swift
//  DeDuplicatingEntity Sample
//
//  Created by Victor Hudson on 1/16/22.
//

import SwiftUI

struct NoteView: View {
    @ObservedObject var note: Note
    
    var body: some View {
        ScrollView {
            Text(note.content ?? "")
                .fixedSize(horizontal: false, vertical: true)
                .navigationTitle(note.title ?? "Note Detail")
            .padding(.horizontal)
        }
    }
}

