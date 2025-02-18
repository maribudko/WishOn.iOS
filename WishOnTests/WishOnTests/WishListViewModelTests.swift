//
//  WishOnTests.swift
//  WishOnTests
//
//  Created by Mari Budko on 26.11.2024.
//

import XCTest
import Testing
@testable import WishOn
import Combine

class WishListViewModelTests: XCTestCase {
    var viewModel: WishListViewModel!
    var mockRepository: MockWishListRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockWishListRepository()
        viewModel = WishListViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testLoadWishLists2() {
        let expectation = XCTestExpectation(description: "WishLists are loaded")
        viewModel.$wishLists
            .dropFirst()
            .sink { wishLists in
                if !wishLists.isEmpty {
                    XCTAssertEqual(wishLists.count, 1)
                    XCTAssertEqual(wishLists.first?.name, "Some Name")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadWishLists()
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testAddWishList() {
        let name = "New Test WishList"
        let description = "Some test description"
        viewModel.addNewWishList(name: name, imageUrl: "", eventDate: Date(), wishes: [], isSelected: false, description: description, color: "")
        
        viewModel.$wishLists
            .dropFirst()
            .sink { wishLists in
                if self.mockRepository.isAddWishListCalled {
                    XCTAssertEqual(wishLists.count, 2)
                    XCTAssertEqual(wishLists.last?.name, name)
                    XCTAssertEqual(wishLists.last?.description, description)
                }
            }
            .store(in: &cancellables)
        
       
    }
    
    func testDeleteWishList() {
        
        let name = "New Test WishList"
        let description = "Some test description"
        viewModel.addNewWishList(name: name, imageUrl: "", eventDate: Date(), wishes: [], isSelected: false, description: description, color: "")
        viewModel.addNewWishList(name: "Some other", imageUrl: "", eventDate: Date(), wishes: [], isSelected: false, description: description, color: "")
        
        viewModel.$wishLists
            .dropFirst()
            .sink { wishLists in
                if self.mockRepository.isDeleteWishListCalled {
                    XCTAssertTrue(wishLists.isEmpty)
               }
            }
            .store(in: &cancellables)
        
        viewModel.removeWishList(id: MockWishListRepository.id.uuidString)
    }

    
}
