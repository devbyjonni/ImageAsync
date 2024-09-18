import Foundation

protocol APIService {
    func fetchData(for page: Int, pageLimit: Int, method: HTTPMethod) async throws -> [PicsumPhoto]
}
