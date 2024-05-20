//
//  ReviewViewModel.swift
//  MarketingApp
//
//  Created by George Stratulat on 20.05.2024.
//

import Foundation
import MessageUI
import Combine

final class ReviewViewModel: NSObject, ObservableObject {
    @Published var providers: [Provider]
    
    init(providers: [Provider]) {
        self.providers = providers
    }
    
    func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            print("Device cannot send mail")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setToRecipients(["bogus@bogus.com"])
        mailComposer.setSubject("Marketing Campaign Details")
        for provider in providers {
            mailComposer.setMessageBody(provider.emailBody, isHTML: false)
        }
        
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController {
            rootViewController.present(mailComposer, animated: true, completion: nil)
        }
    }
}

extension ReviewViewModel: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension Provider {
    var emailBody: String {
        var body = "This is your marketing campaign details:\n\n"
        body += "Details:\n"
        body += "Provider: \(name)\n\n"
        body += "Campaigns:\n"
        for campaign in campaigns {
            body += "Price: \(campaign.price)\n"
            body += "Options:\n"
            for option in campaign.options {
                body += "\(option.name)\n"
            }
            body += "\n"
        }
        return body
    }
}
