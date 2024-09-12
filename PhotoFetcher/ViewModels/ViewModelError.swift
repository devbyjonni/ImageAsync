//
//  ViewModelError.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

enum ViewModelError: Identifiable {
    case networkError(String)
    case genericError(String)
    
    var id: String {
        switch self {
        case .networkError(let message), .genericError(let message):
            return message
        }
    }
    
    var errorMessage: String {
        switch self {
        case .networkError(let message):
            return "Network issue: \(message). Please check your connection."
        case .genericError(let message):
            return "Oops! Something went wrong: \(message)."
        }
    }
}
