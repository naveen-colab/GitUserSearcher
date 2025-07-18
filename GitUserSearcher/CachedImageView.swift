//
//  CachedImageView.swift
//  GitUserSearcher
//
//  Created by Surya Teja Nammi on 7/18/25.
//

import SwiftUI

struct CachedImageView: View {
    let url: URL
    @State private var error: Bool = false
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else if error {
                Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            load()
        }
    }

    func load() {
        let key = url.absoluteString

        if let cached = ImageCache.shared.image(forKey: key) {
            self.image = cached
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let img = UIImage(data: data) {
                    ImageCache.shared.insertImage(img, forKey: key)
                    await MainActor.run {
                        self.error = false
                        self.image = img
                    }
                }
            } catch {
                self.error = true
                print("Image load failed:", error)
            }
        }
    }
}

#Preview {
    CachedImageView(url: URL(string: "https://avatars.githubusercontent.com/u/7138")!)
}
