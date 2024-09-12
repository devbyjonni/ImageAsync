//
//  PersistenceService.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

protocol PersistenceService {
    func savePhotos(_ photos: [PicsumPhoto]) throws
    func fetchPhotos() throws -> [PicsumPhoto]
}
