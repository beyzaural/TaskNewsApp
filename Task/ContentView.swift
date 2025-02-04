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
                            ArticleListView(articles: Article.previewData) // Replace with your actual data source
                                .navigationTitle("All Articles")
                        }
                        .tabItem {
                            Label("All Articles", systemImage: "list.bullet")
                        }
            
            BookmarkTabView()
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
