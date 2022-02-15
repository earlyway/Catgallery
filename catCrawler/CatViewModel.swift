//
//  CatViewModel.swift
//  catCrawler
//
//  Created by Mac pro on 2022/02/11.
//

import Foundation

protocol CatViewModelOutput: AnyObject {
    func loadComplete()
}


final class CatViewModel {
    
    private var currentPage = 0
    
    private var limit = 3 * 7
    
    private let service = CatService()
    
    var data: [CatResponse] = []
    
    weak var delegate : CatViewModelOutput?
    
    private var delegates: [CatViewModelOutput] = []
    
    func attach(delegate: CatViewModelOutput) {
        self.delegates.append(delegate)
    }
    
    func detach(delegate: CatViewModelOutput) {
        self.delegates = self.delegates.filter {
            $0 !== delegate
        }
    }
    
    var isLoading: Bool = false
    
    func loadMoreIfNeeded(index: Int) {
        if index > data.count - 6 {
            self.load()
        }
    }
    
    func load() {
        guard !isLoading else { return }
        self.isLoading = true
        
        self.service.getCats(page: self.currentPage, limit: self.limit) {
            result in
            
            DispatchQueue.main.async {
                
                switch result {
                case .failure(let error):
                    break
                case .success(let response):
                    self.data.append(contentsOf: response)
                    self.currentPage += 1
                    self.delegates.forEach{ $0.loadComplete() }
                }
                    self.delegate?.loadComplete()
                }
                self.isLoading = false
            }
            
            
        }
}

