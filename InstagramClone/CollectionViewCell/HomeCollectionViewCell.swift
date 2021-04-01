//
//  HomeCollectionViewCell.swift
//  InstagramClone
//
//  Created by Lova Krishna on 25/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    var additionalImages: [String] = []
    var isPostLiked = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var stackHeight: NSLayoutConstraint?
    
    let cellID = "HomeCellPhotoCell"
    
    var post: Post? {
        didSet {
            //self.populateCell(post: post!)
        }
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode   = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    let profileName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(likePost), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(showComments), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(sharePost), for: .touchUpInside)
        return button
    }()
    
    lazy var bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(bookmarkPost), for: .touchUpInside)
        return button
    }()
    
    lazy var postDescriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var dateLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .darkGray
        return lbl
    }()
    
    lazy var page: UIPageControl = {
        let page = UIPageControl()
        page.currentPageIndicatorTintColor = .systemBlue
        page.pageIndicatorTintColor =  UIColor.lightGray.withAlphaComponent(0.57)
        page.hidesForSinglePage = true
        return page
    }()
    
    lazy var imageViewCV: UICollectionView = {
           let flow = UICollectionViewFlowLayout()
           flow.scrollDirection = .horizontal
           let collections = UICollectionView(frame: .zero, collectionViewLayout: flow)
           collections.showsHorizontalScrollIndicator = false
           collections.register(NewPostCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
           collections.delegate = self
           collections.dataSource = self
           collections.isPagingEnabled = true
           collections.backgroundColor = .white
           return collections
       }()
    
    //Stack View
    lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var pageStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [page])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    func setup() {
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.clipsToBounds = true
        addSubview(profileName)
        profileName.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 10, paddingBottom: 0, paddingRight: 8, width: 0, height: 40)
        addSubview(imageView)
        imageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.setupPageControll()
        addSubview(buttonsStack)
        buttonsStack.anchor(top: pageStack.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 50)
        addSubview(bookMarkButton)
        bookMarkButton.anchor(top: imageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 40, height: 50)
        addSubview(postDescriptionLbl)
        postDescriptionLbl.anchor(top: buttonsStack.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        addSubview(dateLbl)
        dateLbl.anchor(top: postDescriptionLbl.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        
    }
    
    fileprivate func setupPageControll() {
        addSubview(pageStack)
        pageStack.backgroundColor = .red
        pageStack.anchor(top: imageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 10)
        pageStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        stackHeight = pageStack.heightAnchor.constraint(equalToConstant: 10)
        stackHeight?.isActive = true
        centerX(inView: pageStack)
    }
    
    func populateCell(post: Post) {
        additionalImages = []
        if post.additionalImages.count > 0 {
            //prepare Arrray of Urls
            additionalImages.append(post.image)
            let dict = post.additionalImages
            dict.forEach { (arg) in
                let (_, value) = arg
                additionalImages.append(value)
            }
            print(additionalImages)
            // set pagination
            addSubview(imageViewCV)
            imageViewCV.backgroundColor = .red
            imageViewCV.anchor(top: imageView.topAnchor, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: imageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            imageViewCV.reloadData()
            page.numberOfPages = post.additionalImages.count
            if additionalImages.count == 0 {
                stackHeight?.constant = 0
            } else {
                stackHeight?.constant = 12
            }
            if imageViewCV.visibleCells.count > 0 {
                if let cell = imageViewCV.visibleCells[0] as? NewPostCollectionViewCell {
                    page.currentPage = cell.index ?? 0
                }
            }
        }else{
            self.imageView.loadImageUsingCache(withUrl: post.image, placeholder: UIImage(named: "placeholder"))
        }
        self.profileName.text = post.username
        self.profileImageView.loadImageUsingCache(withUrl: post.profile + "", placeholder: UIImage(named: "placeholder"))
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attributedString1 = NSMutableAttributedString(string:post.username, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:post.post, attributes:attrs2)
        attributedString1.append(attributedString2)
        self.postDescriptionLbl.attributedText = attributedString1
        self.dateLbl.text = getTimeElapsed(post.created)
    }
    
    public func setImage(image: UIImage) {
        imageView.image = image
    }
    
    public func getImage() -> UIImage? {
        return imageView.image
    }
    
    @objc func likePost() {
        
    }
    
    @objc func showComments() {
        
    }
    
    @objc func sharePost() {
        
    }
    
    @objc func bookmarkPost() {
        
    }
    
    @objc func likeGesture() {
        if !isPostLiked {
            likePost()
            let heartIcon: UIImageView = {
                let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
                image.image = #imageLiteral(resourceName: "red-heart").withRenderingMode(.alwaysOriginal)
                image.contentMode = .scaleAspectFit
                return image
            }()
            heartIcon.center = imageView.center
            addSubview(heartIcon)
            heartIcon.layer.transform = CATransform3DMakeScale(0, 0, 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                heartIcon.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }) { (_) in
                UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    heartIcon.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    heartIcon.alpha = 0
                }, completion: { (_) in
                    heartIcon.removeFromSuperview()
                })
            }
        }
    }
    
}

extension HomeCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = post {
            return additionalImages.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! NewPostCollectionViewCell
//        if let post = post {
//            if indexPath.item == 0 {
//                cell.imageView.loadImageUsingCache(withUrl: post.image, placeholder: UIImage(named: "placeholder"))
//            } else {
                cell.imageView.loadImageUsingCache(withUrl: additionalImages[indexPath.row], placeholder: UIImage(named: "placeholder"))
//            }
//        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(likeGesture))
        gesture.numberOfTapsRequired = 2
        cell.imageView.addGestureRecognizer(gesture)
        cell.imageView.isUserInteractionEnabled = true
        cell.index = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        page.currentPage = Int(x / frame.width)
        
    }
}
