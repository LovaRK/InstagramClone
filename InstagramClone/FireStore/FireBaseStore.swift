//
//  FireStore.swift
//  InstagramClone
//
//  Created by Lova Krishna on 24/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit
import Firebase

class FireBaseStore: NSObject {
    
    // Login
    class func login(withEmail email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let e = error{
                callback?(e)
                return
            }
            callback?(nil)
        }
    }
    
    //Register
    class func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let e = error{
                callback?(e)
                return
            }
            print("UserCreated")
            callback?(nil)
        }
    }
    
    // Sign Out
    class func signOut() -> Bool{
        do{
            try Auth.auth().signOut()
            print("User Signout sucessfully")
            return true
        }catch{
            return false
        }
    }
    
    //  Verify Email
    class func sendEmailVerification(_ callback: ((Error?) -> ())? = nil){
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            callback?(error)
        })
    }
    
    // Reloading User Details
    class func reloadUser(_ callback: ((Error?) -> ())? = nil){
        Auth.auth().currentUser?.reload(completion: { (error) in
            callback?(error)
        })
    }
    
    // Reset Password
    class func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    
    // Create a Profile Change Request
    class func createProfileChangeRequest(photoUrl: URL? = nil, name: String? = nil, _ callback: ((Error?) -> ())? = nil){
        if let request = Auth.auth().currentUser?.createProfileChangeRequest(){
            guard let name = name else { return }
            guard let url = photoUrl else { return }
            request.displayName = name
            request.photoURL = url
            let values = [Auth.auth().currentUser?.uid: ["username": name, "profile": url.absoluteString, "posts": 0, "followers": 0, "following": 0]]
            Database.database().reference().child("users").updateChildValues(values)
            print("createProfileChangeRequest sucessfull")
            request.commitChanges(completion: { (error) in
                callback?(error)
            })
        }
    }
    
    //Update Profile Picture and Display Name
    class func updateProfileInfo(withImage image: Data? = nil, name: String? = nil, _ callback: ((Error?) -> ())? = nil){
        guard let user = Auth.auth().currentUser else {
            callback?(nil)
            return
        }
        if let image = image{
            let profileImgReference = Storage.storage().reference().child("profile_pictures").child("\(user.uid).png")
            _ = profileImgReference.putData(image, metadata: nil) { (metadata, error) in
                if let error = error {
                    callback?(error)
                } else {
                    profileImgReference.downloadURL(completion: { (url, error) in
                        if let url = url{
                            print("\(url)")
                            self.createProfileChangeRequest(photoUrl: url, name: name, { (error) in
                                callback?(error)
                            })
                        }else{
                            callback?(error)
                        }
                    })
                }
            }
        }else if let name = name{
            self.createProfileChangeRequest(name: name, { (error) in
                callback?(error)
            })
        }else{
            callback?(nil)
        }
    }
    
    class func loadUserData(_ callback: ((User?) -> ())? = nil) {
        guard let userId =  Auth.auth().currentUser?.uid else {
            callback?(nil)
            return
        }
        
        Database.database().reference().child("users").child(userId).observe(.value) {(snap) in
            let data = snap.value as! [String: Any]
            let userData = User(data: data)
            globalUser = userData
            callback?(userData)
        }
    }
    
    class func incrementUserIntegerMetaDataByOne(child: String, key: String, completion: (() -> Void)? = nil) {
        Database.database().reference().child("users").child(child).observeSingleEvent(of: .value, with: { (snap) in
            let dict = snap.value as! [String: Any]
            let previous = dict[key] as! Int
            Database.database().reference().child("users").child(child).updateChildValues([key : previous + 1])
            completion?()
        })
    }
    
    
    // App Functions
    
    class func loadPosts(completion: (() -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("posts").child(uid).queryOrdered(byChild: "created").observeSingleEvent(of: .value, with: { (snap) in
            posts = []
            if snap.value is NSNull {
                fetchFollowersPosts(uid: uid, completion: completion)
                return
            }
            let data = snap.value as! [String: Any]
            data.forEach({ (key, val) in
                let value = val as! [String: Any]
                let post = Post(uid: uid, id: key, dictionary: value)
                posts.append(post)
            })
            fetchFollowersPosts(uid: uid, completion: completion)
        })
    }

    class func fetchFollowersPosts(uid: String, completion: (() -> Void)? = nil) {
        Database.database().reference().child("users").child(uid).child("usersFollowed").observeSingleEvent(of: .value, with: { (snap) in
            guard let dat = snap.value as? [String: Any] else {
                completion?()
                return
            }
            dat.forEach({ (otherUID,_) in   Database.database().reference().child("posts").child(otherUID).observeSingleEvent(of: .value, with: { (snap) in
                if snap.value is NSNull {
                    completion?()
                    return
                }
                let data = snap.value as! [String: Any]
                data.forEach({ (id, val) in
                    let value = val as! [String: Any]
                    let post = Post(uid: otherUID, id: id, dictionary: value)
                    posts.append(post)
                })
                completion?()
            })
            })
        })
    }
    
}
