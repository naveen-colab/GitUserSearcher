//
//  SearchUsersErrorModel.swift
//  GitUserSearcher
//
//  Created by Surya Teja Nammi on 7/18/25.
//

import Foundation

struct GitHubSerachUserErrorResponse: Codable, Error {
    let message: String
    let documentationURL: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case message
        case documentationURL = "documentation_url"
        case status
    }
}
