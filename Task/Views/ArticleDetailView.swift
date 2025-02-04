//
//  ArticleDetailView.swift
//  Task
//
//  Created by beyza ural on 4.02.2025.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(article.title)
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 8)
                
                if let author = article.author, !author.isEmpty {
                    Text("Author: \(author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let publishedAt = article.publishedAt as Date? {
                    Text("Published On: \(DateFormatter.localizedString(from: publishedAt, dateStyle: .medium, timeStyle: .short))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                }
                
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
                    .frame(maxHeight: 300)
                    .clipped()
                }
                
                Text(article.descriptionText)
                    .font(.body)
                    .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleDetailView(article: Article.previewData[0])
        }
    }
}
