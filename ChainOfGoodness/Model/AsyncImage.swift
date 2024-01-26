//
//  AsyncImage.swift
//  ChainOfGoodness
//
//  Created by Raunaq Vyas on 2024-01-15.
//

import Foundation
import SwiftUI

struct AsyncImageView: View {
    @State private var fetchedImage: UIImage?
    @State private var isImageLoading: Bool = false
    var imageKey: String
    var sessionManager: SessionManager

    var body: some View {
        Group {
            if let image = fetchedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isImageLoading {
                ProgressView()
            } else {
                Image(systemName: "")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.3)
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        guard !imageKey.isEmpty else { return }
        isImageLoading = true
        Task {
            do {
                let image = try await sessionManager.fetchImageFromS3Async(key: imageKey)
                fetchedImage = image
            } catch {
                print("Error fetching image: \(error)")
            }
            isImageLoading = false
        }
    }
}
