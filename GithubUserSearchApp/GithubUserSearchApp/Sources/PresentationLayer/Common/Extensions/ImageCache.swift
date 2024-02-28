//
//  ImageCache.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/25.
//

import UIKit

public extension UIImageView {
    private static var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    
    private func cacheImageSetter(with link: String, and image: UIImage) {
        let cacheKey = NSString(string: link)
        UIImageView.cache.setObject(image, forKey: cacheKey)
    }
    
    private func cacheImageGetter(of link: String) -> UIImage? {
        let cacheKey = NSString(string: link)
        let image = UIImageView.cache.object(forKey: cacheKey)
        return image
    }
    
    private func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        Task {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response.mimeType, mimeType.hasPrefix("image"),
                let image = UIImage(data: data)
            else { return }
            self.cacheImageSetter(with: url.absoluteString, and: image)
            self.image = image
        }
    }
    
    func loadImage(from link: String?, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let link else { return }
        if let image = cacheImageGetter(of: link) {
            self.image = image
            return
        }
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
