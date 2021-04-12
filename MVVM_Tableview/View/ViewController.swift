//
//  ViewController.swift
//  VBD_Sample_Task
//
//  Created by Rajeswari on 04/04/21.
//  Copyright © 2021 Rajeswari. All rights reserved.
//

import UIKit
import Reachability
import RealmSwift
import SystemConfiguration

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    var dataList : Results<List>!
    var index = IndexPath()
    
    var listViewModel = ListViewModel()
    var pageNumber: Int = 1
    var isDataLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternetConnection()
    }
    
    func checkInternetConnection() {
        dataList = ListViewModel.realm.objects(List.self)
        if currentReachabilityStatus == .notReachable {
            if dataList.count != 0 {
                errorView.isHidden = true
                return
            }
            errorView.isHidden = false
            return
        } else {
            errorView.isHidden = true
            initViewModel()
        }
    }
    
    @IBAction func retryButtonAction(_ sender: Any) {
        if currentReachabilityStatus == .notReachable {
            let alert = UIAlertController(title: "", message: "Ups, Internet connection appears to be offline Connect to network and try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                if self.currentReachabilityStatus == .reachableViaWiFi {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        self.errorView.isHidden = true
                        self.initViewModel()
                    }
                }
                self.present(alert, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            initViewModel()
        }
        
    }
    
    func initViewModel() {
        listViewModel.reloadTableView = {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
        listViewModel.showLoading = {
            DispatchQueue.main.async { self.activityIndicator.startAnimating() }
        }
        listViewModel.hideLoading = {
            DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
        }
        listViewModel.getData(pageNumber: pageNumber)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentReachabilityStatus == .notReachable {
            if dataList.count == 0 {
                return 0
            } else {
                return dataList.count
            }
        } else {
            return listViewModel.numberOfCells
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath) as? ListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        if currentReachabilityStatus == .notReachable {
            let list = dataList[indexPath.row]
            index = indexPath
            cell.name.text = list.name
            cell.fullName.text = list.full_name
            cell.fork.text = String(list.forks)
            cell.watchers.text = String(list.watchers)
            cell.language.text = list.language
            activityIndicator.isHidden = true
        } else {
            let list = listViewModel.getCellViewModel( at: indexPath )
            index = indexPath
            cell.name.text = list.name
            cell.fullName.text = list.fullName
            cell.fork.text = String(list.forks)
            cell.watchers.text = String(list.watchers)
            cell.language.text = list.language
        }
        
        cell.fullName.numberOfLines = 0
        cell.name.numberOfLines = 0
        cell.name.sizeToFit()
        cell.fullName.sizeToFit()
        return cell
    }
    
}

extension ViewController {
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentReachabilityStatus == .notReachable {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            
        }
        else{
            for cell in tableView.visibleCells {
                let indexPath = tableView.indexPath(for: cell)
                if indexPath != nil {
                    let lastItem = listViewModel.numberOfCells - 3
                    if indexPath!.row == lastItem {
                        self.pageNumber = self.pageNumber + 1
                        listViewModel.getData(pageNumber: pageNumber)
                        activityIndicator.stopAnimating()
                        activityIndicator.isHidden = true
                        isDataLoading = true
                    }
                    
                }
                
            }
            
        }
    }
}
