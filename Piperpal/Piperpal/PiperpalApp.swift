//
//  PiperpalApp.swift
//  Piperpal
//
//  Created by Ole Kristian Aamot on 9/5/22.
//

import SwiftUI

@main
struct PiperpalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
