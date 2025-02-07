import SwiftUI

struct ArticleListView: View {
    @State private var articles: [Article] = []
    @State private var page: Int = 1
    @State private var isLoading: Bool = false
    @State private var searchText: String = ""
    @State private var sortByDate: Bool = false
    @State private var showDatePicker: Bool = false
    @State private var selectedStartDate: Date? = nil
    @State private var selectedEndDate: Date? = nil
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
                
                // Calendar Button
                Button(action: {
                    showDatePicker.toggle()
                }) {
                    Image(systemName: "calendar")
                        .font(.title2)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showDatePicker) {
                    DateRangePickerView(
                        selectedStartDate: $selectedStartDate,
                        selectedEndDate: $selectedEndDate,
                        onApply: applyDateFilter
                    )
                }

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
        }
        .navigationTitle("All Articles")
    }
    
    private var filteredArticles: [Article] {
        let sortedArticles = sortByDate ? articles.sorted(by: { $0.publishedAt > $1.publishedAt }) : articles
        
        // Apply search and date filters
        return sortedArticles.filter { article in
            let matchesSearchText = searchText.isEmpty || article.title.lowercased().contains(searchText.lowercased()) || article.descriptionText.lowercased().contains(searchText.lowercased())
            let matchesDateRange = isArticleWithinDateRange(article)
            return matchesSearchText && matchesDateRange
        }
    }
    
    private func isArticleWithinDateRange(_ article: Article) -> Bool {
        guard let startDate = selectedStartDate, let endDate = selectedEndDate else {
            return true // No date range selected
        }
        return article.publishedAt >= startDate && article.publishedAt <= endDate
    }
    
    private func toggleBookmark(for article: Article) {
        if articleBookmarkVM.isBookmarked(for: article) {
            articleBookmarkVM.removeBookmark(for: article)
        } else {
            articleBookmarkVM.addBookmark(for: article)
        }
    }
    
    private func loadArticles() {
        isLoading = true
        NewsAPI.fetchNews(page: page, pageSize: 20) { result in
            switch result {
            case .success(let newArticles):
                DispatchQueue.main.async {
                    let uniqueArticles = newArticles.filter { newArticle in
                        !self.articles.contains(where: { $0.url == newArticle.url })
                    }
                    self.articles.append(contentsOf: uniqueArticles)
                    self.isLoading = false
                }
            case .failure(let error):
                print(error.localizedDescription)
                isLoading = false
            }
        }
    }
    
    private func applyDateFilter() {
        // Refresh articles based on the selected date range
        print("Filtering articles from \(selectedStartDate ?? Date()) to \(selectedEndDate ?? Date())")
    }
}
