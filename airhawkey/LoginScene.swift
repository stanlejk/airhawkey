//
//  LoginScene.swift
//  airhawkey
//
//  Created by Stanley Kim on 4/22/18.
//  Copyright © 2018 Danny Peng. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit
import SocketIO

class LoginScene : SKScene, Scene {
    var controller : GameProtocol!
    var loginButton = ButtonNode(normalImageNamed: "login", activeImageNamed: "login", disabledImageNamed: "login")
    
    func setController(_ controller: GameProtocol) {
        self.controller = controller
    }
    
    override func didMove(to view: SKView) {
        
        let emailFieldFrame = CGRect(origin: CGPoint(x: 90, y: 450), size: CGSize(width: 200, height: 35))
        let emailField = UITextField(frame: emailFieldFrame)
        emailField.backgroundColor = UIColor.white
        emailField.layer.borderColor = UIColor.gray.cgColor
        emailField.layer.borderWidth = 1.0
        emailField.placeholder = "Email"
        self.view!.addSubview(emailField)
        
        let passwordFieldFrame = CGRect(origin: CGPoint(x: 90, y: 500), size: CGSize(width: 200, height: 35))
        let passwordField = UITextField(frame: passwordFieldFrame)
        passwordField.backgroundColor = UIColor.white
        passwordField.layer.borderColor = UIColor.gray.cgColor
        passwordField.layer.borderWidth = 1.0
        passwordField.placeholder = "Password"
        self.view!.addSubview(passwordField)
        
        addChild(loginButton)
        loginButton.zPosition = 3
        loginButton.position.x = 15
        loginButton.position.y = 300
        loginButton.setScale(0.3)
        loginButton.selectedHandler = {
//            self.view!.subviews.forEach({ $0.removeFromSuperview() })
            for view in self.view!.subviews {
                view.removeFromSuperview()
            }
            self.controller.showLobby()
        }
        
    }
}

