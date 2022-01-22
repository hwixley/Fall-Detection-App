//
//  FirebaseHandling.swift
//  fall-detector
//
//  Created by Harry Wixley on 22/01/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

func initUser(authDataResult: AuthDataResult) -> User? {
    var user: User? = nil

    Firestore.firestore().collection("users").document(authDataResult.user.uid).getDocument { docSnapshot, err in
        if err != nil {
        } else if docSnapshot != nil && docSnapshot!.exists && docSnapshot!.data() != nil {
            let ddata = docSnapshot!.data()!
            
            user = User(id: authDataResult.user.uid, name: ddata["name"] as! String, email: ddata["email"] as! String, phone: ddata["phone"] as! String, age: ddata["age"] as! Int, height: ddata["height"] as! Int, weight: ddata["weight"] as! Int, is_female: ddata["is_female"] as! Bool, medical_conditions: ddata["medical_conditions"] as! String, contacts: getContacts(id: authDataResult.user.uid))
        }
    }
    return user
}

func getContacts(id: String) -> [Person] {
    var contacts: [Person] = []
    
    Firestore.firestore().collection("users").document(id).collection("contacts").getDocuments { querySnapshot, err in
        if err != nil {
        } else if querySnapshot != nil {
            for doc in querySnapshot!.documents {
                let ddata = doc.data()
                
                contacts.append(Person(id: doc.documentID, name: ddata["name"] as! String, email: ddata["email"] as! String, phone: ddata["phone"] as! String))
            }
        }
    }
    return contacts
}
