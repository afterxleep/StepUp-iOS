//
//  APIClientService.swift
//  StepUp
//
//  Created by Juan combariza on 7/31/19.
//

import Foundation

protocol APIClientFacade: AnyObject {
    func allCompanyAreas(completion: @escaping RetrieveAreaCompletion)
    func allCompanyLocations(completion: @escaping RetrieveLocationCompletion)
    func allCompanyValues(completion: @escaping RetrieveCompanyValuesCompletion)
    func userInformation(completion: @escaping RetrieveUserInformationCompletion)
    func registerUser(location: String, area: String, completion: @escaping RetrieveLoggedInUserCompletion)
    func updateUser(location: String, area: String, completion: @escaping RetrieveLoggedInUserCompletion)
    func relevantContacts(completion: @escaping RetrieveRelevantContactsCompletion)
    func feedbacks(filter: FeedbackFilter, completion: @escaping RetrieveFeedbackCompletion)
    func createFeedback(body: CreateFeedbackBody, completion: @escaping FeedbackCompletion)
    func likeFeedback(feedbackId: String, completion: @escaping FeedbackCompletion)
    func flagFeedback(feedbackId: String, completion: @escaping FeedbackCompletion)
    func rankings(page: String, value: String, location: String, area: String, completion: @escaping RetrieveRanksCompletion)
}
