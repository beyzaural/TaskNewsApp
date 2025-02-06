import SwiftUI

struct ArticleListView: View {
    let articles: [Article]
    @State private var searchText: String = ""
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    var body: some View {
        let filteredArticles = self.filteredArticles
        
        List {
            ForEach(filteredArticles) { article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    ArticleRowView(article: article)
                        .padding(.vertical, 8) // Add consistent padding between rows
                }
                .swipeActions(edge: .trailing) { // Add swipe actions
                    Button {
                        toggleBookmark(for: article)
                    } label: {
                        Label(
                            articleBookmarkVM.isBookmarked(for: article) ? "Remove from Favorites" : "Add to Favorites",
                            systemImage: articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark"
                        )
                    }
                    .tint(articleBookmarkVM.isBookmarked(for: article) ? .red : .blue)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) // Remove default insets
                .listRowSeparator(.hidden) // Remove separators for a clean look
            }
        }
        .listStyle(.plain) // Prevent extra spacing
        .navigationTitle("All Articles")
        .searchable(text: $searchText)
    }
    
    private var filteredArticles: [Article] {
        if searchText.isEmpty {
            return articles
        }
        return articles.filter {
            $0.title.lowercased().contains(searchText.lowercased()) ||
            $0.descriptionText.lowercased().contains(searchText.lowercased())
        }
    }
    
    private func toggleBookmark(for article: Article) {
        if articleBookmarkVM.isBookmarked(for: article) {
            articleBookmarkVM.removeBookmark(for: article)
        } else {
            articleBookmarkVM.addBookmark(for: article)
        }
    }
}

