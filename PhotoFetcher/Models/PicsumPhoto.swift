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

class PicsumPhoto: Identifiable, Codable {
    var id: String
    var author: String
    var url: String
    var downloadURL: String
    var isFavorite: Bool = false
    var savedAt: Date = Date()
    
    init(id: String, author: String, url: String, downloadURL: String, isFavorite: Bool = false, savedAt: Date = Date()) {
        self.id = id
        self.author = author
        self.url = url
        self.downloadURL = downloadURL
        self.isFavorite = isFavorite
        self.savedAt = savedAt
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        author = try container.decode(String.self, forKey: .author)
        url = try container.decode(String.self, forKey: .url)
        downloadURL = try container.decode(String.self, forKey: .downloadURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(author, forKey: .author)
        try container.encode(url, forKey: .url)
        try container.encode(downloadURL, forKey: .downloadURL)
    }
}

