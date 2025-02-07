//
//  ArticleRowView.swift
//  Task
//
//  Created by beyza ural on 4.02.2025.
//
import SwiftUI

struct ArticleRowView: View {
    
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image Section
            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200) // Fixed height for images
                        .clipped() // Prevent overflow
                        .cornerRadius(8) // Optional: Rounded corners
                case .failure:
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        Spacer()
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .background(Color.gray.opacity(0.3)) // Fallback background
            
            // Text Section
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(article.captionText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Bookmark Button
                    Button {
                        toggleBookmark(for: article)
                    } label: {
                        Image(systemName: articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 20)) // Increase the size of the button
                            .frame(width: 44, height: 44) // Larger tappable area
                            .background(Color.gray.opacity(0.1)) // Optional background
                            .cornerRadius(8) // Optional rounded edges
                            .foregroundColor(.black)
                    }
                    .buttonStyle(.borderless)
                    
                    // Share Button
                    Button {
                        presentShareSheet(url: article.articleURL)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20)) // Increase the size of the button
                            .frame(width: 44, height: 44) // Larger tappable area
                            .background(Color.gray.opacity(0.1)) // Optional background
                            .cornerRadius(8) // Optional rounded edges
                            .foregroundColor(.black)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .padding(.vertical, 16) // Add more vertical padding to increase cell height
        .padding(.leading) // Apply padding only to the left side
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Optional: Shadow for elevation
    }
    
    private func toggleBookmark(for article: Article) {
        if articleBookmarkVM.isBookmarked(for: article) {
            articleBookmarkVM.removeBookmark(for: article)
        } else {
            articleBookmarkVM.addBookmark(for: article)
        }
    }
}

// Share Sheet Extension
extension View {
    func presentShareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}

