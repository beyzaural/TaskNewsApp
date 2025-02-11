//
//  ContentView.swift
//  Task
//
//  Created by beyza ural on 3.02.2025.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // All Articles Tab
            NavigationView {
                ArticleListView() // No argument needed
            }
            .tabItem {
                Label("All Articles", systemImage: "list.bullet")
            }
            
            // Saved Articles Tab
            NavigationView {
                BookmarkTabView()
            }
            .tabItem {
                Label("Saved", systemImage: "bookmark")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
