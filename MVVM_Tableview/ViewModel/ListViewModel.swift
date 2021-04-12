//
//  ListViewModel.swift
//  VBD_Sample_Task
//
//  Created by Rajeswari on 04/04/21.
//  Copyright © 2021 Rajeswari. All rights reserved.
//
import UIKit
import RealmSwift

class ListViewModel {
    static let realm = try! Realm()

    var listData: [ListData] = [ListData]()
    var reloadTableView: (()->())?
    var showError: (()->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?
    var page: Int = 0
    
    private var cellViewModels: [DataListCellViewModel] = [DataListCellViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    func getData(pageNumber: Int) {
        showLoading?()
        page = pageNumber
        let url = URL(string: "https://api.github.com/users/JakeWharton/repos?page="+String(page) + "&per_page=15")
        ApiClient.getDataFromServer(url: url!) { (success, data) in
            self.hideLoading?()
            if success {
                if self.page == 0 {
                   self.listData.removeAll()
                }
                
                if data?.count == 0 {
                    return
                }
                self.createCell(data: data!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
                    self.saveData(data: data!)
                    self.reloadTableView?()
                })
            } else {
                self.showError?()
            }
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> DataListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCell(data: [ListData]) {
        self.listData = data
        var viewModel = [DataListCellViewModel]()
        for data in data {
     
            viewModel.append(DataListCellViewModel(name: data.name ?? "",
                                             fullName: data.full_name ?? "No Fullname Found",
                                             forks: data.forks ?? 0,
                                             watchers: data.watchers ?? 0,
                                             language: data.language ?? ""))
            
        }
        cellViewModels.append(contentsOf: viewModel)
    }
    
    func saveData(data: [ListData]) {
        for data in data {
            let localData = List()
            localData.full_name = data.full_name ?? "No Fullname Found"
            localData.forks = data.forks ?? 0
            localData.name = data.name ?? ""
            localData.watchers = data.watchers ?? 0
            localData.language = data.language ?? ""
            do {
                try! ListViewModel.realm.write {
                    ListViewModel.realm.add(localData)
                }
                
            } catch _ as NSError {
                print("error")
            }
        }
    }
}

struct DataListCellViewModel {
    let name: String
    let fullName: String
    let forks: Int
    let watchers: Int
    let language: String
}
