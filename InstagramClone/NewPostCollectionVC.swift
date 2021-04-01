//
//  NewPostCollectionVC.swift
//  InstagramClone
//
//  Created by Lova Krishna on 25/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit
import Photos


private let cellReuseIdentifier = "NewPostCell"
private let newPostHeaderReuseIdentifier = "ProfileHeader"

class NewPostCollectionVC: UICollectionViewController {
    
    var headerView: NewPostCollectionViewCell?
//    var user : User? {
//        didSet{
//            self.navigationItem.title = user?.username
//        }
//    }
    var images: [UIImage] = []
    var assests: [PHAsset] = []
    var selectedIndex = 0
    var index: Int?
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupNavgationBar()
        DispatchQueue.main.async {
            self.fetchPhotosFromDevice()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        FireBaseStore.loadUserData { (user) in
//            self.user = user
//            self.collectionView.reloadData()
//        }
    }
    
    fileprivate func setup() {
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        // Register cell classes
        collectionView.register(NewPostCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView?.register(NewPostCollectionViewCell.self, forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionHeader, withReuseIdentifier: newPostHeaderReuseIdentifier)
    }
    
    fileprivate func setupNavgationBar(){
        self.navigationItem.title = "Select Photo"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
    }
    
    @objc func nextButtonTapped() {
        print("next tapped")
        let controller = SharePostVC()
        controller.selecterdImage = images[selectedIndex]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func cancelButtonTapped() {
        print("Cancle tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func fetchPhotosFromDevice() {
        images = []
        assests = []
        let imageManager = PHImageManager()
        let options = PHFetchOptions()
        options.fetchLimit = 100
        let sortOptions = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortOptions]
        let photos = PHAsset.fetchAssets(with: .image, options: options)
        let reqOptions = PHImageRequestOptions()
        reqOptions.isSynchronous = true
        photos.enumerateObjects {[unowned self] (asset, count, _) in
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: reqOptions, resultHandler: {[unowned self] (image, _) in
                if let unwrappedImage = image {
                    self.assests.append(asset)
                    self.images.append(unwrappedImage)
                }
                if count == photos.count - 1{
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    fileprivate func loadResolutionImage(index: Int) {
        let imageManager = PHImageManager()
        let reqOptions = PHImageRequestOptions()
        reqOptions.isSynchronous = true
        imageManager.requestImage(for: assests[index], targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: reqOptions) {[unowned self] (image, _) in
            if let unwrappedImage = image {
                self.headerView?.setImage(image: unwrappedImage)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! NewPostCollectionViewCell
        // Configure the cell
        let image = images[indexPath.item]
        cell.setImage(image: image)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        loadResolutionImage(index: selectedIndex)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
    }
    
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
            newPostHeaderReuseIdentifier, for: indexPath) as! NewPostCollectionViewCell
        self.headerView = header
        if assests.count > 0 {
            loadResolutionImage(index: selectedIndex)
        }
        return header
    }
}

extension NewPostCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection
        section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
}
