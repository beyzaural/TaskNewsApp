import SwiftUI

struct BookmarkTabView: View {
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    @State var searchText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Title and Search Bar
            VStack(alignment: .leading, spacing: 8) {
                Text("Saved Articles")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 40) // Add consistent spacing from the top

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
                .padding(.horizontal)
            }
            .padding(.bottom, 8)

            // Article List
            List {
                ForEach(filteredArticles) { article in
                    ArticleRowView(article: article)
                        .padding(.vertical, 8)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                removeFromBookmarks(article: article)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .overlay(overlayView(isEmpty: filteredArticles.isEmpty))
        }
        .padding(.top, 8) // Add spacing from the top
        .navigationTitle("") // Ensure no duplicate navigation title
        .navigationBarHidden(true) // Hide navigation bar title to prevent overlapping
    }

    private var filteredArticles: [Article] {
        if searchText.isEmpty {
            return articleBookmarkVM.bookmarks
        }
        return articleBookmarkVM.bookmarks.filter {
            $0.title.lowercased().contains(searchText.lowercased()) ||
            $0.descriptionText.lowercased().contains(searchText.lowercased())
        }
    }

    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyPlaceholderView(text: "No saved articles", image: Image(systemName: "bookmark"))
        }
    }

    private func removeFromBookmarks(article: Article) {
        articleBookmarkVM.removeBookmark(for: article)
    }
}

struct BookmarkTabView_Previews: PreviewProvider {
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared

    static var previews: some View {
        BookmarkTabView()
            .environmentObject(articleBookmarkVM)
    }
}
