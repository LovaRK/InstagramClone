//
//  SignInVc.swift
//  InstagramClone
//
//  Created by Lova Krishna on 19/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    let headerView : UIView = {
        let header = UIView()
        header.backgroundColor = UIColor.systemBlue
        return header
    }()
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment    = .center
        lbl.text             = "Instagram"
        lbl.font             = UIFont(name: "ChalkboardSE-Bold", size: 40)
        lbl.textColor        = UIColor.white
        return lbl
    }()
    
    let emailTF: UITextField = {
        let tf = UITextField()
        tf.placeholder        = "Enter Email"
        tf.backgroundColor    = UIColor.systemGray6
        tf.borderStyle        = .roundedRect
        tf.font               = UIFont.systemFont(ofSize: 16)
        tf.autocorrectionType = .no
        tf.keyboardType       = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder       = "Enter Password"
        tf.backgroundColor   = UIColor.systemGray6
        tf.borderStyle       = .roundedRect
        tf.font              = UIFont.systemFont(ofSize: 16)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signInButton: UIButton = {
        let btn                     = UIButton()
        btn.backgroundColor         = UIColor.systemBlue
        btn.layer.cornerRadius      = 5
        btn.clipsToBounds           = true
        btn.setTitle("Sign In", for: .normal)
        btn.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        return btn
    }()
    
    //Stack View
    let inPutFieldsStackView: UIStackView = {
        let stackView           = UIStackView()
        stackView.axis          = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.fillEqually
        stackView.alignment     = UIStackView.Alignment.fill
        stackView.spacing       = 10.0
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.configureHeaderView()
        self.configureTitleLbl()
        self.configureInPutFieldsStackView()
        self.configureaadSignUpAndSignInBtn()
        self.setupToHideKeyboardOnTapOnView()
    }
    
    let signUpAndSignInBtn: UIButton = {
        let btn = UIButton(type: .system)
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.systemBlue]
        let attributedString1 = NSMutableAttributedString(string:"Don’t have an account? ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"Sign Up.", attributes:attrs2)
        attributedString1.append(attributedString2)
        btn.setAttributedTitle(attributedString1, for: .normal)
        btn.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func configureHeaderView() {
        self.view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
    }
    
    func configureTitleLbl() {
        self.headerView.addSubview(titleLbl)
        titleLbl.center(inView: headerView, yConstant: 0)
    }
    
    func configureInPutFieldsStackView() {
        inPutFieldsStackView.addArrangedSubview(emailTF)
        inPutFieldsStackView.addArrangedSubview(passwordTF)
        inPutFieldsStackView.addArrangedSubview(signInButton)
        self.view.addSubview(inPutFieldsStackView)
        inPutFieldsStackView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 150)
    }
    
    func configureaadSignUpAndSignInBtn() {
        self.view.addSubview(signUpAndSignInBtn)
        signUpAndSignInBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom:0, paddingRight: 30, width: 0, height: 60)
    }
    
    @objc func didTapSignInButton() {
        let signUpVc = RegistrationVC()
        self.navigationController?.pushViewController(signUpVc, animated: true)
    }
    
    @objc private func handleSignInButton() {
        guard let email = emailTF.text else {  return  }
        guard let password = passwordTF.text else { return }
        self.displayActivityIndicator(shouldDisplay: true)
        FireBaseStore.login(withEmail: email, password: password) { (error) in
            self.displayActivityIndicator(shouldDisplay: false)
            if error != nil {
                self.presentAlertWithTitle(title: "Error", message: error?.localizedDescription ?? "Unknown Error.", options: "Ok") { (option) in
                    print("option: \(option)") }
                return
            }
            // navigate to home screen
            self.displayActivityIndicator(shouldDisplay: false)
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            sceneDelegate.showRootViewController()
        }
    }
    
}
