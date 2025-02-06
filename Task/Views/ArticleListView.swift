import SwiftUI

struct ArticleListView: View {
    @State private var articles: [Article] = []
    @State private var page: Int = 1
    @State private var isLoading: Bool = false
    @State private var searchText: String = ""
    @State private var sortByDate: Bool = false
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Search Bar with Sort Button
            HStack {
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

            // Articles List
            List {
                ForEach(filteredArticles) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        ArticleRowView(article: article)
                            .padding(.vertical, 8)
                    }
                    .swipeActions(edge: .trailing) {
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
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
                
                // Loading indicator
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .listStyle(.plain)
            .onAppear {
                loadArticles()
            }
            .onAppear(perform: loadMoreIfNeeded)
        }
        .navigationTitle("All Articles")
    }
    
    private var filteredArticles: [Article] {
        let sortedArticles = sortByDate ? articles.sorted(by: { $0.publishedAt > $1.publishedAt }) : articles
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
    
    private func loadMoreIfNeeded() {
        guard !isLoading else { return }
        guard articles.count % 20 == 0 else { return } // Only load if pageSize is met
        page += 1
        loadArticles()
    }
    
    private func loadArticles() {
        isLoading = true
        NewsAPI.fetchNews(page: page, pageSize: 20) { result in
            switch result {
            case .success(let newArticles):
                DispatchQueue.main.async {
                    self.articles.append(contentsOf: newArticles)
                    self.isLoading = false
                }
            case .failure(let error):
                print(error.localizedDescription)
                isLoading = false
            }
        }
    }
}
