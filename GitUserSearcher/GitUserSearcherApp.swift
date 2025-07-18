//
//  GitUserSearcherApp.swift
//  GitUserSearcher
//
//  Created by Surya Teja Nammi on 7/18/25.
//

import SwiftUI

@main
struct GitUserSearcherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
