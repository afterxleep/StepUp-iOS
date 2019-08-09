//
//  APIClientRepository.swift
//  StepUp
//
//  Created by Juan combariza on 7/31/19.
//

import Foundation

class APIClient: APIClientFacade {
    private let locationKey = "location"
    private let areaKey = "area"
    private let pageKey = "page"
    private let valueKey = "value"
    private let fromKey = "from"
    private let toKey = "to"
    private let userKey = "user"
    private let isPrivateKey = "isPrivate"
    private let isPinnedKey = "isPinned"
    private let skipKey = "skip"
    private let limitKey = "limit"
    
    private lazy var area: AreaService = { return AreaRepository() }()
    private lazy var location: LocationService = { return LocationRepository() }()
    private lazy var msal: MSALService = { return MSALRepository() }()
    private lazy var loggedInUser: LoggedInUserService = { return LoggedInUserRepository() }()
    private lazy var value: CompanyValuesService = { return CompanyValuesRepository() }()
    private lazy var feedback: FeedbackService = { return FeedbackRepository() }()
    private lazy var rank: RankService = { return RankRepository() }()
    
    weak var msalDelegate: MSALDelegate? {
        didSet {
            msal.delegate = msalDelegate
        }
    }
    
    // MARK: - areas

    func allCompanyAreas(completion: @escaping RetrieveAreaCompletion) {
        msal.retrieveSecurityToken { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(.unableToMakeRequest))
                return
            }
            
            switch result {
            case .success(let token):
                strongSelf.area.retrieveAreaList(API.area(token).request(), completion: completion)
            case .failure( _ ):
                completion(.failure(.unableToMakeRequest))
            }
        }
    }
    
    // MARK: - locations
    
    func allCompanyLocations(completion: @escaping RetrieveLocationCompletion) {
        msal.retrieveSecurityToken { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(.unableToMakeRequest))
                return
            }
            
            switch result {
            case .success(let token):
                strongSelf.location.retrieveLocationList(API.location(token).request(), completion: completion)
            case .failure( _ ):
                completion(.failure(.unableToMakeRequest))
            }
        }
    }
    
    // MARK: - values
    
    func allCompanyValues(completion: @escaping RetrieveCompanyValuesCompletion) {
        msal.retrieveSecurityToken { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(.unableToMakeRequest))
                return
            }
            
            switch result {
            case .success(let token):
                strongSelf.value.retrieveCompanyValues(API.companyValues(token).request(), completion: completion)
            case .failure( _ ):
                completion(.failure(.unableToMakeRequest))
            }
        }
    }
    
    // MARK: - Logged In User
    
    func userInformation(completion: @escaping RetrieveUserInformationCompletion) {
        msal.retrieveSecurityToken { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(.unableToMakeRequest))
                return
            }
            
            switch result {
            case .success(let token):
                strongSelf.loggedInUser.retrieveUserInformation(API.loggedInUser(token).request(), completion: completion)
            case .failure( _ ):
                completion(.failure(.unableToMakeRequest))
            }
        }
    }
    
    func registerUser(location: String, area: String, completion: @escaping RetrieveLoggedInUserCompletion) {
        msal.retrieveSecurityToken { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(.unableToMakeRequest))
                return
            }
            
            switch result {
            case .success(let token):
                let body = [strongSelf.locationKey: location,
                            strongSelf.areaKey: area]
                
                strongSelf.loggedInUser.registerUser(API.registerUser(token, body).request(), completion: completion)
            case .failure( _ ):
                completion(.failure(.unableToMakeRequest))
            }
        }
    }
    
    func updateUser(location: String, area: String, completion: @escaping RetrieveLoggedInUserCompletion) {
        msal.retrieveSecurityToken { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(.unableToMakeRequest))
                return
            }
            
            switch result {
            case .success(let token):
                let body = [strongSelf.locationKey: location,
                            strongSelf.areaKey: area]
                
                strongSelf.loggedInUser.updateUser(API.updateUser(token, body).request(), completion: completion)
            case .failure( _ ):
                completion(.failure(.unableToMakeRequest))
            }
        }
    }
    
    func relevantContacts(completion: @escaping RetrieveRelevantContactsCompletion) {
        msal.retrieveSecurityToken { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(.unableToMakeRequest))
                return
            }
            
            switch result {
            case .success(let token):
                strongSelf.loggedInUser.retrieveRelevantContacts(API.contacts(token).request(), completion: completion)
            case .failure( _ ):
                completion(.failure(.unableToMakeRequest))
            }
        }
    }
    
    // MARK: - Feedback
    
    func feedbacks(filter: FeedbackFilter, completion: @escaping RetrieveFeedbackCompletion) {
        msal.retrieveSecurityToken { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(.unableToMakeRequest))
                return
            }
            
            switch result {
            case .success(let token):
                let filter = [strongSelf.fromKey: "\(filter.from)",
                              strongSelf.toKey: "\(filter.to)",
                              strongSelf.valueKey: filter.value,
                              strongSelf.userKey: "\(filter.user)",
                              strongSelf.isPrivateKey: "\(filter.isPrivate)",
                              strongSelf.isPinnedKey: "\(filter.isPinned)",
                              strongSelf.skipKey: "\(filter.skip)",
                              strongSelf.limitKey: "\(filter.limit)"]
                
                strongSelf.feedback.retrieveFeedbacks(API.feedback(token).request(parameters: filter), completion: completion)
            case .failure( _ ):
                completion(.failure(.unableToMakeRequest))
            }
        }
    }
    
    func createFeedbacks(filter: FeedbackFilter, completion: @escaping RetrieveFeedbackCompletion) {
        
    }
    
    // MARK: - Rank
    
    func rankings(page: String, value: String, location: String, area: String, completion: @escaping RetrieveRanksCompletion) {
        msal.retrieveSecurityToken { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(.unableToMakeRequest))
                return
            }
            
            switch result {
            case .success(let token):
                let filter = [strongSelf.pageKey: page,
                              strongSelf.valueKey: value,
                              strongSelf.locationKey: location,
                              strongSelf.areaKey: area]
                
                strongSelf.rank.retrieveRanks(API.rank(token).request(parameters: filter), completion: completion)
            case .failure( _ ):
                completion(.failure(.unableToMakeRequest))
            }
        }
    }
}
