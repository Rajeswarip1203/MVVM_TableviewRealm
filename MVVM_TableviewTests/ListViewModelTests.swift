//
//  ListViewModelTests.swift
//  MVVM_TableviewTests
//
//  Created by P, Rajeswari on 07/04/21.
//

import XCTest
@testable import MVVM_Tableview

class ListViewModelTests: XCTestCase {
    
    var viewModel : ListViewModel!
    var modelData: ListData!
    fileprivate var service : ApiClient!
    
    override func setUp() {
        viewModel = ListViewModel()
        viewModel.listData = readJsonData()
    }
    
    func testInit() {
        XCTAssertNotNil(viewModel)
    }
    
    func testThatCellCreationSuccess() {
        viewModel?.createCell(data: self.viewModel.listData)
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
    
    func testModelInformations() {
        XCTAssertNotNil(viewModel.saveData(data: readJsonData()))
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.modelData = nil
        super.tearDown()
    }
    
}
