import Foundation

protocol PersistenceService {
    func savePhotos(_ photos: [PicsumPhoto]) throws
    func fetchPhotos() throws -> [PicsumPhoto]
}
