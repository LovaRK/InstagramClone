//
//  SharePostVC.swift
//  InstagramClone
//
//  Created by Lova Krishna on 27/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit
import Firebase

class SharePostVC: UIViewController {
    
    let cellID = "SharePostCells"
    
    var currentCount = 0
    
    var selecterdImage: UIImage?  {
        didSet{
            imageView.image = selecterdImage
        }
    }
    
    var user : User? {
        didSet{
            // self.navigationItem.title = user?.username
        }
    }
    
    var supplementaryImages: [UIImage] = []
    
    var imagePicker: ImagePicker!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let textView: UITextView = {
        let text = UITextView()
        text.font = UIFont.boldSystemFont(ofSize: 14)
        text.text = "Write something here.......✍️"
        text.textColor = UIColor.lightGray
        return text
    }()
    
    lazy var buttonContainer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        view.backgroundColor = UIColor.init(red: 240, green: 240, blue: 240)
        return view
    }()
    
    lazy var buttonContainerLineView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    
    lazy var addImagesButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add Images", for: .normal)
        let image  = #imageLiteral(resourceName: "photo-add")
        btn.setImage(image, for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(addImagesTaped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var supplementartImagesCV: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.backgroundColor = UIColor.init(red: 240, green: 240, blue: 240)
        collection.showsVerticalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        collection.keyboardDismissMode = .interactive
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FireBaseStore.loadUserData { (user) in
            self.user = user
        }
    }
    
    fileprivate func setupViews() {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.setupToHideKeyboardOnTapOnView()
        self.configureNavBar()
        self.configuretopViewContainer()
        self.configurebuttonContainer()
        self.setupSupplementaryView()
    }
    
    fileprivate func configureNavBar(){
        self.view.backgroundColor =  UIColor.init(red: 240, green: 240, blue: 240)
        textView.delegate = self
        self.title = " New Post"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func shareButtonTapped() {
        guard let username    = self.user?.username else { return }
        guard let profile     = self.user?.profileurl else { return }
        guard let uid         = Auth.auth().currentUser?.uid else { return }
        guard let data        = selecterdImage?.jpeg(.medium) else { return }
        let postText          = textView.text!
        let filename          = UUID().uuidString
        self.displayActivityIndicator(shouldDisplay: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let storage = Storage.storage().reference().child("posts").child(filename)
        storage.putData(data, metadata: nil) { [unowned self] (metaData, error) in
            if error != nil {
                self.displayActivityIndicator(shouldDisplay: false)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.presentAlertWithTitle(title: "Error", message: error?.localizedDescription ?? "Unknown Error", options: "OK") { (option) in }
                return
            }
            print("Sucessfully added selected image")
            storage.downloadURL {[unowned self] (url, error) in
                if error != nil {
                    self.displayActivityIndicator(shouldDisplay: false)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.presentAlertWithTitle(title: "Error", message: error?.localizedDescription ?? "Unknown Error", options: "OK") { (option) in }
                    return
                }
                let downloadUrl = url?.absoluteString
                let values: [String: Any] = ["image" : downloadUrl!, "post": postText,  "username" : username ,"profile": profile, "created": Date().timeIntervalSince1970]
                let refrence = Database.database().reference().child("posts").child(uid).childByAutoId()
                let autoID = refrence.key!
                refrence.updateChildValues(values) { (error, dataBseRef) in
                    if error != nil {
                        self.displayActivityIndicator(shouldDisplay: false)
                        self.presentAlertWithTitle(title: "Error", message: error?.localizedDescription ?? "Unknown Error", options: "OK") { (option) in }
                        return
                    }
                    FireBaseStore.incrementUserIntegerMetaDataByOne(child: uid, key: "posts", completion: nil)
                }
                var count = 0
                if self.supplementaryImages.count == 0 {
                    self.doneUploading()
                    return
                }
                for image in self.supplementaryImages {
                    guard let data        = image.jpeg(.medium) else { return }
                    count += 1
                    let key = "url" + String(count)
                    let addFilename = UUID().uuidString
                    let add_storage = Storage.storage().reference().child("posts").child(addFilename)
                    add_storage.putData(data , metadata: nil) { (metadata, error) in
                        if error != nil {
                            self.displayActivityIndicator(shouldDisplay: false)
                            self.navigationItem.rightBarButtonItem?.isEnabled = true
                            self.presentAlertWithTitle(title: "Error", message: error?.localizedDescription ?? "Unknown Error", options: "OK") { (option) in }
                            return
                        }
                        add_storage.downloadURL { (url, error) in
                            let add_downloadUrl = url?.absoluteString
                            Database.database().reference().child("posts").child(uid).child(autoID).child("additionalImages").updateChildValues([key : add_downloadUrl as AnyObject])
                            self.currentCount += 1
                            self.doneUploading()
                        }
                        
                    }
                }
            }
        }
    }
    
    fileprivate func doneUploading() {
        if currentCount == supplementaryImages.count {
            self.displayActivityIndicator(shouldDisplay: false)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func addImagesTaped() {
        self.imagePicker.present(from: self.view)
    }
    
    fileprivate func configuretopViewContainer() {
        view.addSubview(container)
        container.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        container.addSubview(imageView)
        imageView.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        container.addSubview(textView)
        textView.anchor(top: container.topAnchor, left: imageView.rightAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
    }
    
    fileprivate func configurebuttonContainer(){
        view.addSubview(buttonContainer)
        buttonContainer.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 51.5)
        
        view.addSubview(buttonContainerLineView)
        buttonContainerLineView.anchor(top: buttonContainer.topAnchor, left: buttonContainer.leftAnchor , bottom: nil, right: buttonContainer.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        view.addSubview(addImagesButton)
        addImagesButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 40)
        addImagesButton.center(inView: buttonContainer)
    }
    
    fileprivate func setupSupplementaryView() {
        self.view.addSubview(supplementartImagesCV)
        supplementartImagesCV.anchor(top: container.bottomAnchor, left: view.leftAnchor, bottom: buttonContainer.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        supplementartImagesCV.register(CancelablePhotoCell.self, forCellWithReuseIdentifier: cellID)
    }
    
}


extension SharePostVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write something here.......✍️"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension SharePostVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let image = image {
            self.supplementaryImages.append(image)
            self.supplementartImagesCV.reloadData()
        }
    }
}

extension SharePostVC: CancelablePhotoCellDelegate {
    func removeItem(index: Int) {
        supplementaryImages.remove(at: index)
        supplementartImagesCV.reloadData()
    }
    
}

extension SharePostVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.supplementaryImages.count == 0) {
            self.supplementartImagesCV.setEmptyMessage("Please add the Supplementry Images by click on add imaage button below👇")
        } else {
            self.supplementartImagesCV.restore()
        }
        return supplementaryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CancelablePhotoCell
        cell.setImage(image: supplementaryImages[indexPath.item])
        cell.index = indexPath.item
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.height * 0.16
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
