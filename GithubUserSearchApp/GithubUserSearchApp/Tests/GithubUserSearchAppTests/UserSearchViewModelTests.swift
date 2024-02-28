import XCTest
import PresentationLayer
import DomainLayer
import Combine
//@testable import GithubUserSearchApp

class UserSearchViewModelTests: XCTestCase {
    var viewModel: UserSearchViewModel!
    var mockRepository: MockUsersRepositoryImp!
    
    var paginator: Paginator!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUsersRepositoryImp()
        paginator = .init(itemsPerPage: MockUserContainerDomain.containerFirstPage.users.count)
        viewModel = UserSearchViewModel(
            repository: mockRepository,
            paginator: paginator
        )
        cancellables = .init()
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        paginator = nil
        super.tearDown()
    }
    
    // - didChangeQuery에 값을 넣고 repository에서 값들이 정상적으로 잘 빠져나오는가?
    func testDidChangeQuery_fetchesUsers() {
        viewModel.didChangeQuery(query: "Apple")
        
        XCTAssertEqual(viewModel.users, mockRepository.mockUsersContainerDomain.users)
    }
    
    // - testDidChangeQuery에 ""을 넣고 empty array가 잘 나오는가?
    func testDidChangeQuery_ifInputQueryIsEmpty() {
        let expectation = expectation(description: "")
        
        viewModel
            .notifyPublisher
            .sink { type in
                switch type {
                case .reload:
                    XCTAssertTrue(self.viewModel.users.isEmpty)
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel.didChangeQuery(query: "")
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    // - didChangeQuery하고 reload가 잘되는가?
    func testDidChangeQuery_invokeReload() {
        let expectation = expectation(description: "")
        
        viewModel
            .notifyPublisher
            .sink { noti in
                switch noti {
                case .reload:
                    XCTAssertTrue(true)
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel.didChangeQuery(query: "Apple")
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    // - testDidTapStartButton을 하고 favorite을 잘 뒤집는가?
    func testDidTapStartButton_togglesFavorite() {
        //Set
        viewModel.didChangeQuery(query: "Apple")
        
        //Act
        viewModel.didTapStarButton(user: viewModel.users[0])
        
        //Assert
        XCTAssertTrue(viewModel.users[0].isFavorite)
    }
    
    // - testFetchNextPage하고 reachedLastPage에 잘 도달 하는지?
    func testFetchNextPage_reachedLastPage() {
        let expectation = expectation(description: "")
        
        viewModel
            .notifyPublisher
            .sink { noti in
                switch noti {
                case .reachedLastPage:
                    XCTAssertTrue(true)
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel.didChangeQuery(query: "Apple")
        viewModel.fetchNextPage()
        viewModel.fetchNextPage()
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    // - testFetchNextPage로 continue를 해서 users가 늘어 나는지?
    func testFetchNextPage_continue() {
        //Set
        viewModel.didChangeQuery(query: "Apple")
        
        //Act
        viewModel.fetchNextPage()
        
        //Assert
        XCTAssertEqual(viewModel.users, MockUserContainerDomain.containerFirstPage.users + MockUserContainerDomain.containerSecondPage.users)
    }
    
    // - didTapStarButton을 한번해서 기존의 isFavorite과 반대인지?
    func testToggleFavoriteAction() {
        viewModel.didChangeQuery(query: "Apple")
        
        let original = viewModel.users.first!.isFavorite
        
        viewModel.didTapStarButton(user: MockUserContainerDomain.containerFirstPage.users.first!)
        
        XCTAssertNotEqual(original, viewModel.users.first?.isFavorite)
    }
    
    // - didTapStarButton을 두번 해서 원래 isFavorite으로 돌아 오는지?
    func testDoubleDidTapStarButton() {
        viewModel.didChangeQuery(query: "Apple")
        
        let original = viewModel.users.first!.isFavorite
        
        viewModel.didTapStarButton(user: viewModel.users.first!)
        viewModel.didTapStarButton(user: viewModel.users.first!)
        
        XCTAssertEqual(original, viewModel.users.first!.isFavorite)
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
    
    // - LocalSearchVM에서 star버튼을 off로 바꿨을때,
    //targetVM에서 star 버튼이 off로 반영 되어야한다.
    func testToggleFavoriteActionFromOtherViewModel() {
        //Set
        let expectation = expectation(description: "")
        
        let repo = MockLocalSearchRepository()
        let localViewModel = LocalSearchViewModel(repository: repo)
        localViewModel.listener = viewModel
        
        localViewModel.onViewDidLoad()
        
        viewModel.didChangeQuery(query: "Apple")
        
        //Act
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            localViewModel.didTapStarButton(user: MockLocalContainerDomain.users[0])
            
            // Assert
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertFalse(self.viewModel.users[1].isFavorite)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    // - 해당 user를 선택해서 해당 유저의 url이 잘 나오는가?
    func testUserSelection() {
        let expectation = expectation(description: "")
        
        viewModel.didChangeQuery(query: "Apple")
        
        viewModel
            .transitionPublisher
            .sink { transition in
                switch transition {
                case .showGitHugPage(let url):
                    XCTAssertEqual(url, URL(string: MockUserContainerDomain.containerFirstPage.users.first!.htmlUrl))
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.didSelectItem(at: 0)
        wait(for: [expectation], timeout: 0.5)
    }
}
