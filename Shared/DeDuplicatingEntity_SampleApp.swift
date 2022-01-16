//
//  DeDuplicatingEntity_SampleApp.swift
//  Shared
//
//  Created by Victor Hudson on 1/16/22.
//

import SwiftUI

@main
struct DeDuplicatingEntity_SampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
