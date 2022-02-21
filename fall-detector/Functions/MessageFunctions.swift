//
//  MessageFunctions.swift
//  fall-detector
//
//  Created by Harry Wixley on 21/02/2022.
//

import Foundation
import Alamofire

func sendMessage(contact: Person) {
    if let accountSID = Bundle.main.infoDictionary?["TWILIO_SID"] as? String,
       let authToken = Bundle.main.infoDictionary?["TWILIO_AUTH_TOKEN"] as? String {
        print("sending")
            
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        let parameters = ["From": "+19107086043", "To": contact.phone, "Body": "Hi \(contact.name), this is a test message from Swift!"]
        
        AF.request(url, method: .post, parameters: parameters)
            .authenticate(username: accountSID, password: authToken)
            .responseJSON { response in
                debugPrint(response)
            }
    }
}
