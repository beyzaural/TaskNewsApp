
import SwiftUI

struct ArticleListView: View {
    let articles: [Article]
    @State private var searchText: String = ""
    @State private var sortByDate: Bool = false // State to control sorting
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Search Bar with Sort Button
            HStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                // Sort Button
                Menu {
                    Button("Order by Date") {
                        sortByDate.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.title2)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            //.padding(.top, 8)
            
            // Articles List
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
        }
        .navigationTitle("All Articles")
    }
    
    private var filteredArticles: [Article] {
        var sortedArticles = articles
        
        if sortByDate {
            // Sort articles by publication date (most recent first)
            sortedArticles = sortedArticles.sorted { $0.publishedAt > $1.publishedAt }
        }
        
        if searchText.isEmpty {
            return sortedArticles
        }
        return sortedArticles.filter {
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
