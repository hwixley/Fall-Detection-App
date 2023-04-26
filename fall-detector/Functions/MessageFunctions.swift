//
//  MessageFunctions.swift
//  fall-detector
//
//  Created by Harry Wixley on 21/02/2022.
//

import Foundation
import Alamofire
import CoreLocation


func sendMessage(contact: Person, completion: @escaping ((Bool) -> Void)) {
    if MyData.user != nil {
        if let accountSID = Bundle.main.infoDictionary?["TWILIO_SID"] as? String,
            let authToken = Bundle.main.infoDictionary?["TWILIO_AUTH_TOKEN"] as? String {
            print("sending")
            print(contact.phone)
            print(authToken)
            
            
            let locationManager = CLLocationManager()
                
            let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages.json"
            var msgBody = "URGENT MESSAGE!\nHi \(contact.name), you are one of \(MyData.user!.name)'s emergency contacts in their fall detection app. You have been contacted as it has been detected that \(MyData.user!.name) has taken a fall and is not responding."
            
            if locationManager.location != nil {
                msgBody += "\nTheir location is LATITUDE: \(locationManager.location!.coordinate.latitude), LONGITUDE: \(locationManager.location!.coordinate.longitude)."
                
                let placemark = getPlacemark(forLocation: locationManager.location!) { placemark, err in
                    if err == nil && placemark != nil {
                        let pm = placemark!
                        var addr = ""
                        
                        if pm.subThoroughfare != nil {
                            addr += pm.subThoroughfare! + " "
                        }
                        if pm.thoroughfare != nil {
                            addr += pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addr += pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addr += pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addr += pm.postalCode!
                        }
                        msgBody += "\nWhich corresponds to the following address: \(addr)"
                        msgBody += "\nPlease get there ASAP their life may depend on it!"
                        
                        let parameters = ["From": "+447360267816", "To": "+44" + contact.phone, "Body": msgBody]
                            
                        AF.request(url, method: .post, parameters: parameters)
                            .authenticate(username: accountSID, password: authToken)
                            .responseJSON { response in
                                print(response.response ?? "respoonse is nil")
                                if response.response != nil {
                                    print(response.response!.statusCode)
                                    print(response.error ?? "error is nil")
                                    if response.response!.statusCode == 201 {
                                        completion(true)
                                    } else {
                                        completion(false)
                                    }
                                } else {
                                    completion(false)
                                }
                            }
                        
                    } else {
                        
                        
                        msgBody += "\nPlease get there ASAP their life may depend on it!"
                        let parameters = ["From": "+19107086043", "To": contact.phone, "Body": msgBody]
                            
                        AF.request(url, method: .post, parameters: parameters)
                            .authenticate(username: accountSID, password: authToken)
                            .responseJSON { response in
                                if response.response != nil {
                                    if response.response!.statusCode == 201 {
                                        completion(true)
                                    } else {
                                        completion(false)
                                    }
                                } else {
                                    completion(false)
                                }
                            }
                    }
                }
            }
        }
    }
}

func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
    let geocoder = CLGeocoder()

    geocoder.reverseGeocodeLocation(location, completionHandler: {
        placemarks, error in

        if let err = error {
            completionHandler(nil, err.localizedDescription)
        } else if let placemarkArray = placemarks {
            if let placemark = placemarkArray.first {
                completionHandler(placemark, nil)
            } else {
                completionHandler(nil, "Placemark was nil")
            }
        } else {
            completionHandler(nil, "Unknown error")
        }
    })

}
