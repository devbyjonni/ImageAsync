//
//  Repository.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

protocol Repository {
    func fetchPhotos(page: Int, pageLimit: Int) async throws -> [PicsumPhoto]
}
