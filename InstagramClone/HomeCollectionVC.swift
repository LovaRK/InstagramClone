//
//  HomeCollectionVC.swift
//  InstagramClone
//
//  Created by Lova Krishna on 25/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit
import Firebase



class HomeCollectionVC: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    var postsArray = [Post]()
    var user : User?
    
    let titleView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysOriginal)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.displayActivityIndicator(shouldDisplay: true)
        self.getDataFromFireBase {
            self.displayActivityIndicator(shouldDisplay: false)
            self.user = globalUser
            self.postsArray = []
            for post in posts {
                self.postsArray.append(post)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func getDataFromFireBase( completion: (() -> Void)? = nil) {
        FireBaseStore.loadUserData { (user) in
            // print("User:",user ?? User(data: [:]))
            FireBaseStore.loadPosts {
                posts.sort(by: { (p1, p2) -> Bool in
                    return p1.created > p2.created
                })
                completion?()
            }
        }
    }
    
    func configureView() {
        // Register cell classes
        self.collectionView!.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavBar() {
        self.collectionView.backgroundColor = .white
        navigationItem.titleView            = titleView
        navigationItem.leftBarButtonItem    = UIBarButtonItem(image: #imageLiteral(resourceName: "showCamera"), style: .plain, target: self, action: #selector(cemaraButtonTapped))
        navigationItem.rightBarButtonItem   = UIBarButtonItem(image: #imageLiteral(resourceName: "send2"), style: .plain, target: self, action: #selector(shareButtonPressed))
    }
    
    @objc func cemaraButtonTapped() {
        
    }
    
    @objc func shareButtonPressed() {
        
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return postsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        // Configure the cell
        let post = postsArray[indexPath.row]
        cell.post = post
        cell.populateCell(post: post)
        return cell
    }
}

extension HomeCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let textHeight = heightForView(post: posts[indexPath.item], width: view.frame.width - 16)
        var height = view.frame.width  + 50 + 56 + textHeight + 5
        if posts[indexPath.item].additionalImages.count > 0 {
            height += 10
        }
        return CGSize(width: view.frame.width, height: height)
    }
}
