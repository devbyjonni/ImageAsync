
import Foundation

protocol SessionBuilding {
    func buildSession() -> URLSession
    func buildForegroundSession() -> URLSession
    func buildBackgroundSession(identifier: String) -> URLSession
}
