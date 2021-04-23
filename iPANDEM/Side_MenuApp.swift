//
//  iPANDEM.swift
//  Main controller for the application
//
//  Created by Kevin Jurden on 3/12/21.
//

import SwiftUI
import Firebase

@main
struct Side_MenuApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var showResults = false
    
    var body: some Scene {
        WindowGroup {
            if (showResults == false) {
                ContentView(showResults: $showResults)
            } else {
                ResultsView(showResults: $showResults)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
