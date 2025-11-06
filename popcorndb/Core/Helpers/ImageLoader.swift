//
//  ImageLoader.swift
//  popcorndb
//
//  Created by Nazlı on 12.08.2025.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()

    func setImage(on imageView: UIImageView, url: URL?, placeholder: UIImage? = nil) {
        imageView.image = placeholder
        guard let url else { return }

        if let cached = cache.object(forKey: url as NSURL) {
            imageView.image = cached
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let img = UIImage(data: data) else { return }
            self?.cache.setObject(img, forKey: url as NSURL)
            DispatchQueue.main.async { imageView.image = img }
        }.resume()
    }
}
