
import Foundation

protocol NetworkManaging {
    func executeRequest<T: Decodable>(_ request: URLRequest) async throws -> T
}
