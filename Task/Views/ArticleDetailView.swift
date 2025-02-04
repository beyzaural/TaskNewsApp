import SwiftUI
import WebKit

struct ArticleDetailView: View {
    let article: Article
    @State private var selectedTab = "Description"
    
    var body: some View {
        VStack(spacing: 0) {
            // Fixed Top Section
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.title2)
                    .bold()
                    .padding(.top, 8)
                
                if let author = article.author, !author.isEmpty {
                    Text("Author: \(author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text("Published On: \(DateFormatter.localizedString(from: article.publishedAt, dateStyle: .medium, timeStyle: .short))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 16) // Add more spacing here
            .background(Color.white)
            
            // Picker for Tabs
            Picker("Tabs", selection: $selectedTab) {
                Text("Description").tag("Description")
                Text("Source").tag("Source")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            // Tab View
            TabView(selection: $selectedTab) {
                // Description Tab
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let imageURL = article.imageURL {
                            AsyncImage(url: imageURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                case .failure:
                                    Image(systemName: "photo")
                                        .imageScale(.large)
                                @unknown default:
                                    fatalError()
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .clipped()
                        }
                        
                        Text(article.descriptionText)
                            .font(.body)
                            .padding(.horizontal)
                    }
                }
                .tag("Description")
                
                // Source Tab
                WebView(url: article.articleURL)
                    .edgesIgnoringSafeArea(.bottom)
                    .tag("Source")
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// WebView Implementation
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

// Preview
struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleDetailView(article: Article.previewData[0])
        }
    }
}

