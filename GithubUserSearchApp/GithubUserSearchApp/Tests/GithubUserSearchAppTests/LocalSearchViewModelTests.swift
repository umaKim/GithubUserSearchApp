import XCTest
import PresentationLayer
import DomainLayer
import Combine

class LocalSearchViewModelTests: XCTestCase {
    var viewModel: LocalSearchViewModel!
    var mockRepository: MockLocalSearchRepository!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockLocalSearchRepository()
        viewModel = LocalSearchViewModel(repository: mockRepository)
        cancellables = .init()
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // - onViewDidLoad하고 fetch가 잘되는가?
    func testOnViewDidLoad_fetchesUsersSuccessfully() {
        // Setup
        mockRepository.shouldReturnErrorOnFetch(false)
        
        let expectation = XCTestExpectation(description: "Fetch users successfully")
        var notifyType: UserSearchNotifyType?
        
        viewModel.notifyPublisher.sink { notification in
            notifyType = notification
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        // Act
        viewModel.onViewDidLoad()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(notifyType)
        XCTAssertEqual(viewModel.usersDictionary, mockRepository.favoriteUsers.convertToDictionary.sortedValues)
    }
    
    // - didChangeQuery하고 filter된 결과가 잘나오는가?
    func testDidChangeQuery_filtersUsers() {
        // Setup
        let expectation = XCTestExpectation(description: "filter users successfully")
        let query = "A"
        mockRepository.shouldReturnErrorOnFetch(false)
        
        viewModel.notifyPublisher.sink { notification in
            switch notification {
            case .reload:
                expectation.fulfill()
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        viewModel.onViewDidLoad()
        
        // Act
        wait(for: [expectation], timeout: 1)
        viewModel.didChangeQuery(query: query)
        
        // Assert
        let filteredUsers = viewModel.usersDictionary.flatMap { $0.value }.filter { $0.name.contains(query) }
        XCTAssertTrue(filteredUsers.allSatisfy { $0.name.contains(query)})
    }
    
    // - favorite button을 누르면 isFavorite이 false로 잘 변하는가?
    func testDidTapStarButton_removeUserFromFavorites() {
        // Setup
        let expectation = expectation(description: "")
        
        viewModel
            .notifyPublisher
            .sink { notification in
                
            }
            .store(in: &cancellables)
        
        viewModel.onViewDidLoad()
        
        // Act
        let user = MockLocalContainerDomain.users.first!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            self.viewModel.didTapStarButton(user: user)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        // Assert
        let isFavorite = self.viewModel.usersDictionary[user.name.prefix(1).uppercased()]!.first!.isFavorite
        XCTAssertFalse(isFavorite)
    }
    
    // - favorite button을 눌러서 isFavorite이 true로 잘 변하는가
    func testDidTapStarButton_addUserToFavorites() {
        // Setup
        let expectation = expectation(description: "")
        
        viewModel.onViewDidLoad()
        
        // Act
        let user = MockLocalContainerDomain.users.last!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.didTapStarButton(user: user)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        // Assert
        let key = user.name.prefix(1).uppercased()
        let users = self.viewModel.usersDictionary[key]
        XCTAssertTrue(users!.last!.isFavorite)
    }
    
    // - didTapStarButton으로 잘못된 값을 눌렀을때 메세지 보여주기
    func testDidTapStarButton_showErrorMessage() {
        let expecation = expectation(description: "")
        
        var errorMessage = ""
        
        viewModel.didChangeQuery(query: "Apple")
        
        viewModel
            .notifyPublisher
            .sink { noti in
            switch noti {
            case .error(let error):
                errorMessage = error.description
                expecation.fulfill()
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        viewModel.didTapStarButton(user: .init(name: "", id: -1, avatarUrl: "", htmlUrl: "", isFavorite: false))
        
        wait(for: [expecation], timeout: 1)
        
        XCTAssertEqual(errorMessage, "Toggle favorite fail")
    }
    
    // - testDidChangeQuery해서 reload를 하는가?
    func testDidChangeQuery_reload() {
        // Set up
        let expectation = expectation(description: "")
        
        var isReloaded = false
        
        viewModel
            .notifyPublisher
            .sink { type in
                switch type {
                case .reload:
                    isReloaded = true
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        // Act
        viewModel.didChangeQuery(query: "Apple")
        
        wait(for: [expectation], timeout: 0.5)
        
        // Assert
        XCTAssertTrue(isReloaded)
    }
    
    // - testDidSelectItem을 해서 transitionPublisher로 선택한 url을 뱉어내는가?
    func testDidSelectItem() {
        let expecation = expectation(description: "")
        
        let targetItem = MockLocalContainerDomain.users[0]
        
        var doesMatch = false
        
        viewModel
            .transitionPublisher
            .sink { transition in
                switch transition {
                case .showGitHugPage(let url):
                    doesMatch = url == URL(string: targetItem.htmlUrl)
                    expecation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.onViewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.didSelectItem(at: 0)
        }
        
        wait(for: [expecation], timeout: 1)
        
        XCTAssertTrue(doesMatch)
    }
    
    // - userSearchViewModel에서 LocalSearchViewModel의 target element의 isFavorite을 false로 만들어준.
    // userSearchViewModel -> LocalSearchViewModel
    func testToggleFavoriteActionFromOtherViewModel() {
        //Set
        let expectation = expectation(description: "")
        
        let repo = MockUsersRepositoryImp()
        let userSearchViewModel = UserSearchViewModel(
            repository: repo,
            paginator: .init(
                itemsPerPage: MockUserContainerDomain.containerFirstPage.users.count
            )
        )
        userSearchViewModel.listener = viewModel
        
        userSearchViewModel.didChangeQuery(query: "a")
                
        viewModel.onViewDidLoad()
        
        //Act
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            userSearchViewModel.didTapStarButton(user: userSearchViewModel.users[1])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                //Assert
                let key = userSearchViewModel.users[1].name.prefix(1).uppercased()
                XCTAssertFalse(self.viewModel.usersDictionary[key]![0].isFavorite)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    // - userSearchViewModel에서 LocalSearchViewModel의 target element의 isFavorite가 true인것을 추가 한다.
    func testToggleFavoriteActionFromOtherViewModel2() {
        //Set
        let expectation = expectation(description: "")
        
        let otherViewModel = UserSearchViewModel(
            repository: MockUsersRepositoryImp(),
            paginator: .init(
                itemsPerPage: MockUserContainerDomain.containerFirstPage.users.count
            )
        )
        otherViewModel.listener = viewModel
        
        otherViewModel.didChangeQuery(query: "a")
        
        viewModel.onViewDidLoad()
        
        //Act
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            otherViewModel.didTapStarButton(user: otherViewModel.users[0])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        //Assert
        let key = otherViewModel.users[0].name.prefix(1).uppercased()
        XCTAssertTrue(viewModel.usersDictionary[key]![0].isFavorite)
    }
}
