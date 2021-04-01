//
//  ProfileCollectionVC:
//  InstagramClone
//
//  Created by Lova Krishna on 25/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit
import Firebase

private let cellReuseIdentifier = "HomeCell"
private let profileHeaderReuseIdentifier = "ProfileHeader"

class ProfileCollectionVC: UICollectionViewController {
    
    var postImages = [String]()
        
    var user : User? {
        didSet{
            self.navigationItem.title = user?.username
        }
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupNavgationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.user = globalUser
        print("\(String(describing: globalUser))")
        self.postImages = []
         print("\(posts)")
        for post in posts {
            if post.uid == Auth.auth().currentUser?.uid {
                self.postImages.append(post.image)
            }
        }
            self.collectionView.reloadData()
    }
    
    fileprivate func setup() {
        self.collectionView.backgroundColor = UIColor.clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        // Register cell classes
        collectionView.register(NewPostCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView?.register(ProfileHeaderCollectionViewCell.self, forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionHeader, withReuseIdentifier: profileHeaderReuseIdentifier)
    }
    
    fileprivate func setupNavgationBar(){
        self.navigationItem.title = Auth.auth().currentUser?.displayName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(logOut))
    }
    
    @objc fileprivate func logOut() {
        self.presentActionSheet(title: "Logout", message: "Are you sure you want to log out?", actionTitles: ["Log out", "Cancel"], actionStyle: [.default, .default], actions: [{ action in
            self.displayActivityIndicator(shouldDisplay: true)
            if FireBaseStore.signOut() {
                self.postImages = []
                posts = []
                globalUser = nil
                self.displayActivityIndicator(shouldDisplay: false)
                let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate
                sceneDelegate.showRootViewController()
            }else{
                self.displayActivityIndicator(shouldDisplay: false)
                print("Error to logout")
            }
            }, nil], vc: self)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.postImages.count == 0 {
            self.collectionView.setEmptyMessage("This user has no posts yet to show. Please share one to see 😊")
        } else {
            self.collectionView.restore()
        }
        return postImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! NewPostCollectionViewCell
        // Configure the cell
        let imageUrl = postImages[indexPath.row]
        cell.imageView.loadImageUsingCache(withUrl: imageUrl, placeholder: UIImage(named: "placeholder"))
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 3) / 3
        return CGSize(width: size, height: size)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
            profileHeaderReuseIdentifier, for: indexPath) as! ProfileHeaderCollectionViewCell
        header.user = self.user
        return header
    }
}

extension ProfileCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection
        section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
}

