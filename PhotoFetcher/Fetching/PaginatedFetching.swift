
import Foundation

protocol PaginatedFetching {
    func fetch(for page: Int, pageLimit: Int, method: HTTPMethod) async throws -> [PicsumPhoto]
}
