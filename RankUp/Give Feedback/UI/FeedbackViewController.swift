//
//  FeedbackViewController.swift
//  RankUp
//
//  Created by Miguel D Rojas Cortés on 8/18/19.
//

import UIKit

final class FeedbackViewController: UIViewController {
    
    private struct Constants {
        static let feedbackPlaceholder = "Enter your comment (max 140 chars)"
        static let privateTitleLabel = "Keep it private?"
        static let privateExplanationPrefix = "When enabled only"
        static let privateExplanationSuffix = "will see your message"
        static let privateExplanationDefault = "your peer"
        static let feedbackTypeLabel = "My feedback is to:"
        static let feedbackTypeExplanation = "You can recognize or give advice, but always be respectful."
    }
    
    @IBOutlet weak private var profileView: ProfileView!
    @IBOutlet weak private var valueView: UIView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!
    @IBOutlet weak private var valueDescriptionLabel: UILabel!
    @IBOutlet weak private var privacySwitch: UISwitch!
    @IBOutlet weak private var feedbackTextView: UITextView!
    @IBOutlet weak private var sendButton: UIButton!
    @IBOutlet weak private var viewContainer: UIView!
    @IBOutlet weak private var privateTitleLabel: UILabel!
    @IBOutlet weak private var privateSubheadLabel: UILabel!
    @IBOutlet weak var feedbackTypeLabel: UILabel!
    @IBOutlet weak var feedbackTypeExplanation: UILabel!
    
    var viewModel = FeedbackViewModel(apiClient: APIClient())
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        roundCorners()
        registerForKeyboardNotifications()
        feedbackTextView.delegate = self
        feedbackTextView.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
    }
    
    //MARK: - Configure
    
    private func configure() {
        userNameLabel.text = viewModel.feedback?.userName
        
        let valueColor = UIHelper.valueColor(forType: viewModel.companyValue?.name)
        
        valueView.backgroundColor = valueColor
        valueLabel.text = viewModel.companyValue?.name.uppercased()
        valueLabel.textColor = valueColor
        valueDescriptionLabel.text = viewModel.companyValue?.description
        
        privateTitleLabel.text = Constants.privateTitleLabel
        privateSubheadLabel.text = "\(Constants.privateExplanationPrefix) \(viewModel.feedback?.userName ?? Constants.privateExplanationDefault) \(Constants.privateExplanationSuffix)"
        
        feedbackTextView.attributedText = NSAttributedString(string: Constants.feedbackPlaceholder,
                                                             attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGreyBlue])
        
        profileView.configure(withName: viewModel.feedback?.userName, userMSID: viewModel.feedback?.userMSID)
        
        feedbackTypeLabel.text = Constants.feedbackTypeLabel
        feedbackTypeExplanation.text = Constants.feedbackTypeExplanation
    }
    
    private func roundCorners() {
        valueView.roundCorners(radius: 11)
        viewContainer.roundCorners(corners: [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner], radius: 66)
        feedbackTextView.roundCorners(radius: 9)
        sendButton.roundCorners(radius: 9)
    }
    
    //MARK: - Actions
    
    @IBAction private func didTapSendButton(_ sender: Any) {
        viewModel.sendFeedBack(comment: feedbackTextView.attributedText.string, isPublic: privacySwitch.isOn) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

extension FeedbackViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.attributedText.string == Constants.feedbackPlaceholder {
            textView.text = nil
            textView.typingAttributes = [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.dark]
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.attributedText.string.isEmpty {
            textView.text = Constants.feedbackPlaceholder
            textView.typingAttributes = [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGreyBlue]
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.attributedText.string.isEmpty {
            sendButton.setBackgroundColor(color: .aquaBlue, state: .normal)
            sendButton.setTitleColor(.white, for: .normal)
            sendButton.isEnabled = true
        } else {
            sendButton.setBackgroundColor(color: .iceBlue, state: .normal)
            sendButton.setTitleColor(.lightGreyBlue, for: .normal)
            sendButton.isEnabled = false
        }
    }
    
}
