//
//  ThreadViewModel.swift
//  ChainOfGoodness
//
//  Created by Raunaq Vyas on 2024-01-15.
//

import Foundation

class ThreadViewModel: ObservableObject {
    @Published var userThreads: [Thread] = []
    @Published var allUserThreads: [Thread] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    
    private var threadService: ThreadService
    
    init(threadService: ThreadService = .shared) {
        self.threadService = threadService
    }
    
    func fetchUserThreads(userId: String) {
        isLoading = true
        threadService.getUserThreads(userId: userId) { [weak self] result in
            DispatchQueue.main.async
            {
                self?.isLoading = false
                switch result {
                case .success(let threads):
                    self?.userThreads = threads
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func fetchAllThreads() {
        isLoading = true
        threadService.fetchAllUserThreads { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let threads):
                    self?.allUserThreads = threads
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func createThread(threadDetails: ThreadCredentials) {
            isLoading = true
            threadService.createThread(thread: threadDetails) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(_):
                        self?.showSuccessAlert = true
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        self?.showErrorAlert = true
                    }
                }
            }
        }
}
