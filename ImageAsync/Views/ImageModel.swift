//
//  ImageModel.swift
//  ImageAsync
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

struct ImageModel: Identifiable, Decodable {
    private var downloadURLString: String
    var id: String
    var author: String
    var url: String

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case url
        case downloadURLString = "download_url"
    }

    var downloadURL: URL? {
        URL(string: downloadURLString)
    }
    
    var imageURL: URL? {
        URL(string: "https://picsum.photos/id/\(id)/256/256.jpg")
    }
}

