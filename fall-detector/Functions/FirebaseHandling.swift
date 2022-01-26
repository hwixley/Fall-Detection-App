//
//  FirebaseHandling.swift
//  fall-detector
//
//  Created by Harry Wixley on 22/01/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import RxSwift
import UIKit
import SwiftUI


func resetPassword(email: String, completion: @escaping ((Bool) -> Void)) {
    Auth.auth().fetchSignInMethods(forEmail: email) { providers, err in
        if err == nil && providers != nil {
            Auth.auth().sendPasswordReset(withEmail: email) { err in
                if err == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
}


func createAccount(user: User, completion: @escaping ((Bool) -> Void)) {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    
    Auth.auth().createUser(withEmail: user.email, password: user.password) { authDataResult, err in
        if err == nil && authDataResult != nil {
            Firestore.firestore().collection("users").document(authDataResult!.user.uid).setData(["name": user.name, "email": user.email, "phone": user.phone, "yob": user.yob, "height": user.height, "weight": user.weight, "is_female": user.is_female, "medical_conditions": user.medical_conditions]) { (err) in
                if err == nil {
                    for c in user.contacts {
                        Firestore.firestore().collection("users").document(authDataResult!.user.uid).collection("contacts").addDocument(data: ["name": c.name, "phone": c.phone])
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
}

func loginUser(email: String, password: String, completion: @escaping ((Bool) -> Void)) {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    
    Auth.auth().signIn(withEmail: email, password: password) { authDataResult, err in
        if err == nil && authDataResult != nil {
            Firestore.firestore().collection("users").document(authDataResult!.user.uid).getDocument { docSnapshot, err in
                if err == nil && docSnapshot != nil && docSnapshot!.exists && docSnapshot!.data() != nil {
                    let ddata = docSnapshot!.data()!
                    
                    MyData.user = User(id: authDataResult!.user.uid, name: ddata["name"] as! String, email: ddata["email"] as! String, password: password, phone: ddata["phone"] as! String, yob: ddata["yob"] as! Int, height: ddata["height"] as! Int, weight: ddata["weight"] as! Int, is_female: ddata["is_female"] as! Bool, medical_conditions: ddata["medical_conditions"] as! String, contacts: [])
                    
                    getContacts(id: authDataResult!.user.uid, completion: { success in
                        completion(success)
                    })
                } else {
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
}

func getContacts(id: String, completion: @escaping ((Bool) -> Void)) {
    var contacts: [Person] = []
    
    Firestore.firestore().collection("users").document(id).collection("contacts").getDocuments { querySnapshot, err in
        if err == nil && querySnapshot != nil {
            for doc in querySnapshot!.documents {
                let ddata = doc.data()
                
                contacts.append(Person(id: doc.documentID, name: ddata["name"] as! String, phone: ddata["phone"] as! String, isOnFirebase: true))
            }
            MyData.user!.contacts = contacts
            completion(true)
        } else {
            completion(false)
        }
    }
}

func updateUser(updatedFields: [AnyHashable : Any], newContacts: [Person], oldContacts: [Person]) {
    Firestore.firestore().collection("users").document(MyData.user!.id).updateData(updatedFields) { err in
        if err == nil {
            // Delete all deleted contacts on Firestore
            if oldContacts.count > 0 {
                for c in oldContacts {
                    var found = false
                    
                    for nc in newContacts {
                        if nc.isEqual(pers: c) {
                            found = true
                            break
                        }
                    }
                    if !found {
                        deleteContact(uid: MyData.user!.id, contactID: c.id)
                    }
                }
            }
            
            // Add all new contacts on Firestore
            for c in newContacts {
                if !c.isOnFirebase {
                    addContact(uid: MyData.user!.id, contact: c)
                }
            }
        }
    }
}

func addContact(uid: String, contact: Person) {
    Firestore.firestore().collection("users").document(uid).collection("contacts").document(contact.id).setData(["name": contact.name, "phone": contact.phone])
}

func deleteContact(uid: String, contactID: String) {
    Firestore.firestore().collection("users").document(uid).collection("contacts").document(contactID).delete()
}
