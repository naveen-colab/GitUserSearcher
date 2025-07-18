//
//  SearchView.swift
//  GitUserSearcher
//
//  Created by Surya Teja Nammi on 7/18/25.
//

import Foundation
import Combine
import SwiftUI

struct SearchView: View {
    @State var text: String = ""
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                searchField
                
                List {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let error = viewModel.error {
                        Text("\(error)")
                    } else {
                        ForEach(viewModel.users.indices, id: \.self) { index in
                            let user = viewModel.users[index]
                        
                            NavigationLink(value: user) {
                                GitHubUserSearchViewRow(user: user)
                                    .onAppear {
                                        if viewModel.shouldCallThePaginationAPI(index: index) {
                                            print("Last but one item appeared")
                                            viewModel.paginationCall()
                                        }
                                    }
                            }
                        }
                        
                        Section {
                            HStack(alignment: .center) {
                                if viewModel.isPageLoading {
                                    ProgressView()
                                } else if viewModel.isPageError {
                                    VStack {
                                        Text("Couldn't load next page")
                                        
                                        Button("Retry") {
                                            viewModel.paginationCall()
                                        }
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        
                    }
                }
                
            }
            .padding(.horizontal, 16)
            .navigationTitle("Search Github users")
            .navigationDestination(for: GitHubUser.self) { model in
                UserDetailView(viewModel: UserDetailViewModel(user: model))
            }
        }
    }
    
    var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search github users", text: $viewModel.searchText)
                .autocorrectionDisabled()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1))
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark)
}


struct GitHubUserSearchViewRow: View {
    var user: GitHubUser
    
    var body: some View {
        HStack(alignment: .center) {
//            AsyncImage(url: URL(string: user.avatarURL)) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                case .success(let image):
//                    image.resizable()
//                        .frame(width: 40, height: 40)
//                        .clipShape(Circle())
//                case .failure:
//                    Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
//                @unknown default:
//                    EmptyView()
//                }
//            }
            if let url = URL(string: user.avatarURL) {
                CachedImageView(url: url)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            
            Text(user.login)
                .font(.headline)
        }
    }
}
