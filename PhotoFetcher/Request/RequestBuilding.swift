import Foundation

protocol RequestBuilding {
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) throws -> URLRequest
}
