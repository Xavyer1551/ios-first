//
//  App_WeatherApp.swift
//  App Weather
//
//  Created by Fracisco Javier Martinez on 14/12/21.
//

import SwiftUI

@main
struct App_WeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
