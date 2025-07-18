//
//  SearchViewModel.swift
//  GitUserSearcher
//
//  Created by Surya Teja Nammi on 7/18/25.
//

import Foundation
import Combine
import SwiftUI

final class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    var cancellables = Set<AnyCancellable>()
    
    var searchUserPageSize = 10
    var searchUserPageNumber = 0
    
    @Published var users: [GitHubUser] = [] {
        didSet {
            print("Count: \(users.count)")
            if users.count == 0 {
                error = "Invalid user name"
            } else {
                error = nil
                print("\(users.count)")
            }
        }
    }
    
    private var usersResponse: GitHubUserSearchResponse? = nil
    
    @Published var isLoading: Bool = false
    
    @Published var isPageLoading: Bool = false
    
    @Published var isPageError: Bool = false
    
    @Published var error: String? = nil
    
    init() {
        updateSearchText()
    }
    
    func updateSearchText() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink {[weak self] newText in
                print("search text: \(newText)")
                self?.searchGithubUsers(with: newText)
            }
            .store(in: &cancellables)
    }
    
    func searchGithubUsers(with searchText: String) {
        searchUserPageNumber = 1
        users.removeAll()
        guard !searchText.isEmpty else {
            error = "Please enter a search text"
            return
        }
        
        isLoading = true
        Task {
            let response = await getGithubUsersService(searchText: searchText, perPage: searchUserPageSize, page: searchUserPageNumber)
            
            await MainActor.run { [weak self] in
                guard let response = response else  {
                    self?.error = "User not found"
                    self?.isLoading = false
                    return
                }
                
                self?.usersResponse = response
                withAnimation {
                    self?.users.append(contentsOf: self?.usersResponse?.items ?? [])
                }
                
                self?.isLoading = false
            }
        }
    }
    
    func paginationCall() {
        searchUserPageNumber += 1
        guard !searchText.isEmpty else {
            error = "Please enter a search text"
            return
        }
        
        isPageLoading = true
        Task {
            let response = await getGithubUsersService(searchText: searchText, perPage: searchUserPageSize, page: searchUserPageNumber)
            
            await MainActor.run { [weak self] in
                guard let response = response else  {
                    self?.isPageLoading = false
                    self?.isPageError = true
                    print("Response is nil")
                    return
                }
                
                self?.isPageError = false
                self?.usersResponse = response
                withAnimation {
                    self?.users.append(contentsOf: self?.usersResponse?.items ?? [])
                }
                
                self?.isPageLoading = false
            }
        }
    }
    
    func shouldCallThePaginationAPI(index: Int) -> Bool {
        guard let count = usersResponse?.totalCount else {
            print("No User Response")
            return false
        }
        if index < count - 1 && index == users.count - 1 {
            return true
        }
        
        return false
    }

}
