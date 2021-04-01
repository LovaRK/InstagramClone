//
//  CancelablePhotoCell.swift
//  InstagramClone
//
//  Created by Lova Krishna on 29/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit

protocol CancelablePhotoCellDelegate {
    func removeItem(index: Int)
}

class CancelablePhotoCell: UICollectionViewCell {
    
    var delegate: CancelablePhotoCellDelegate?
    
    var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        
        return image
    }()
    
    lazy var cancelView: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 0.75
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(cancellicked), for: .touchUpInside)
        return button
    }()
    
    func setup() {
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
        
        addSubview(cancelView)
        cancelView.anchor(top: self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        imageView.backgroundColor = .yellow
    }
    
    public func setImage(image: UIImage) {
        imageView.image = image
    }
    
    public func getImage() -> UIImage? {
        return imageView.image
    }
    
    @objc func cancellicked() {
        delegate?.removeItem(index: index)
    }
}
