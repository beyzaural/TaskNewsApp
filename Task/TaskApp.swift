//
//  TaskApp.swift
//  Task
//
//  Created by beyza ural on 3.02.2025.
//

import SwiftUI

@main
struct TaskApp: App {
    
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
       
       var body: some Scene {
           WindowGroup {
               ContentView()
                   .environmentObject(articleBookmarkVM)
           }
       }
}
