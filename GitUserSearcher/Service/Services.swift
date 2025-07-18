//
//  ServiceManager.swift
//  GitUserSearcher
//
//  Created by Surya Teja Nammi on 7/18/25.
//

import Foundation
import SwiftUI

func getGithubUsersService(searchText: String, perPage: Int = 100,page: Int = 1) async -> GitHubUserSearchResponse? {
    guard let url = URL(string: "https://api.github.com/search/users?q=\(searchText)+in%3Alogin&per_page=\(perPage)&page=\(page)") else {
        print("Invalid URL")
        return nil
    }
    print("Fetching github users data with pageNumber \(page) and searchText \(searchText) URL: \(url)...")
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let errorResponse = try? JSONDecoder().decode(GitHubSerachUserErrorResponse.self, from: data) {
            print("GitHub API error: \(errorResponse.message)")
            return nil
        }
        
        let response = try JSONDecoder().decode(GitHubUserSearchResponse.self, from: data)
        print("Successfully fetched data")
        print("respone", response)
        return response
    } catch(let error) {
        print("Failed to fetch data \(error)")
    }
    
    return nil
}

func getGithubUserRepositories(username: String, perPage: Int = 100,page: Int = 1) async -> GitHubRepoList? {
    guard let url = URL(string: "https://api.github.com/users/\(username)/repos?per_page=\(perPage)&page=\(page)") else {
        print("Invalid URL")
        return nil
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GitHubRepoList.self, from: data)
        print("Successfully fetched data")
        print("respone", response)
        return response
    } catch(let error) {
        print("Failed to fetch data with error: \(error)")
    }
    
    return nil
}

func getGithubUserDetails(url: String) async -> GitHubUserDetail? {
    guard let url = URL(string: url) else {
        print("Invalid URL")
        return nil
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GitHubUserDetail.self, from: data)
        print("Successfully fetched data")
        print("respone", response)
        return response
    } catch {
        print("Failed to fetch data")
    }
    
    return nil
}
