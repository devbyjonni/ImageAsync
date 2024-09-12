//
//  PicsumPhoto.swiftd
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-09.
//

import Foundation

// https://picsum.photos/id/870/200/300?grayscale&blur=2
/*
 {
 "id": "0",
 "author": "Alejandro Escamilla",
 "width": 5616,
 "height": 3744,
 "url": "https://unsplash.com/...",
 "download_url": "https://picsum.photos/..."
 }
 */

struct PicsumPhoto: Identifiable, Codable {
    let id: String
    let author: String
    let url: String
    let downloadURL: String

    // Add a manual initializer for testing (XCTestCase)
    init(id: String, author: String, url: String, downloadURL: String) {
        self.id = id
        self.author = author
        self.url = url
        self.downloadURL = downloadURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case url
        case downloadURL = "download_url"
    }
    
    var photoURL: URL? {
        URL(string: "https://picsum.photos/id/\(id)/256/256.jpg")
    }
}

