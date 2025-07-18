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
            SearchView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
