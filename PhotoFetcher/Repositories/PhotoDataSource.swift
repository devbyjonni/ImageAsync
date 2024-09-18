
import Foundation

protocol PhotoDataSource {
    func fetchData(for page: Int, pageLimit: Int, source: DataSource) async throws -> [PicsumPhoto]
}
