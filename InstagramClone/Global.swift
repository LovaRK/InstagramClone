//
//  Global.swift
//  InstagramClone
//
//  Created by Lova Krishna on 02/05/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit

var posts: [Post] = []

var globalUser: User?

public func getTimeElapsed(_ time: TimeInterval) -> String{
    let diff = Date().timeIntervalSince1970 - time
    if diff < 60 {
        return String.init(format: "%.0f seconds ago", diff)
    } else if diff < 3600 {
        return String.init(format: "%.0f minutes ago", diff/60)
    } else if diff < 86400 {
        return String.init(format: "%.0f hours ago", diff/3600)
    } else if diff < 604800 {
        return String.init(format: "%.0f days ago", diff/86400)
    } else if diff < 2.628e+6 {
        return String.init(format: "%.0f weeks ago", diff/604800)
    } else if diff < 3.154e+7 {
        return String.init(format: "%.0f months ago", diff/2.628e+6)
    }
    return String.init(format: "%.0f years ago", diff/3.154e+7)
}


func heightForView(post: Post, width: CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    let attributedText = NSMutableAttributedString(string: post.username + " ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: post.post , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
    attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
    attributedText.append(NSAttributedString(string: getTimeElapsed(post.created), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
    label.attributedText = attributedText
    label.sizeToFit()
    return label.frame.height
}

//func heightForCommentView(comment: CommentItem, width: CGFloat) -> CGFloat{
//    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
//    label.numberOfLines = 0
//    label.lineBreakMode = NSLineBreakMode.byWordWrapping
//    let attributedText = NSMutableAttributedString(string: comment.username + " ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
//    attributedText.append(NSAttributedString(string: comment.comment, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.black]))
//    label.attributedText = attributedText
//    label.sizeToFit()
//    return label.frame.height
//}

