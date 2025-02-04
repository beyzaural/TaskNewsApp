//
//  ArticleListView.swift
//  Task
//
//  Created by beyza ural on 4.02.2025.
//

import SwiftUI

struct ArticleListView: View {
    let articles: [Article]
    @State private var searchText: String = "" // Search text state

    var body: some View {
        List {
            ForEach(filteredArticles) { article in
                NavigationLink(
                    destination: ArticleDetailView(article: article),
                    label: {
                        ArticleRowView(article: article)
                    }
                )
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Search articles...") // Attach searchable here
    }

    // Computed property for filtered articles
    private var filteredArticles: [Article] {
        if searchText.isEmpty {
            return articles
        }
        return articles.filter {
            $0.title.lowercased().contains(searchText.lowercased()) ||
            $0.descriptionText.lowercased().contains(searchText.lowercased())
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared

    static var previews: some View {
        NavigationView {
            ArticleListView(articles: Article.previewData)
                .environmentObject(articleBookmarkVM)
        }
    }
}

