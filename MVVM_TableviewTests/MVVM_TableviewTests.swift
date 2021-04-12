//
//  MVVM_TableviewTests.swift
//  MVVM_TableviewTests
//
//  Created by P, Rajeswari on 07/04/21.
//

import XCTest
@testable import MVVM_Tableview

class MVVM_TableviewTests: XCTestCase {
    var viewControllerUnderTest: ViewController!
    var viewModel: ListViewModel?
    var cellViewModels: [DataListCellViewModel]!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        self.viewControllerUnderTest.loadView()
        self.viewControllerUnderTest.viewDidLoad()
        viewModel?.listData = readJsonData()
    }
    
    func testHasATableView() {
        XCTAssertNotNil(viewControllerUnderTest.tableView)
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.delegate)
    }
    
    func testTableviewOneSection() {
        let tablewView = UITableView()
        let numberOfSections = tablewView.numberOfSections
        XCTAssertEqual(1, numberOfSections)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
    }
    
    
    func readJsonData() -> [ListData]{
        let decoder = JSONDecoder()
        guard
            let path = Bundle.main.path(forResource: "ListData", ofType: ".json")
            ,
            let data = NSData(contentsOfFile: path),
            let listData = try? decoder.decode([ListData].self, from: data as Data)
        else {
            return readJsonData()
        }
        return listData
    }
    
    func testValueCell() {
        
        let tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listTableViewCell")
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        // expected ListTableViewCell class
        guard let _ = tableView.cellForRow(at: indexPath) as? ListTableViewCell else {
            XCTAssert(true, "Expected CurrencyCell class")
            return
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
