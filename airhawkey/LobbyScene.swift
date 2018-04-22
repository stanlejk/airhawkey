//
//  Lobby.swift
//  airhawkey
//
//  Created by Stanley Kim on 4/22/18.
//  Copyright © 2018 Danny Peng. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit
import SocketIO

class LobbyScene : SKScene, Scene {
    var controller : GameProtocol!
    var loginButton = ButtonNode(normalImageNamed: "login", activeImageNamed: "login", disabledImageNamed: "login")
    
    func setController(_ controller: GameProtocol) {
        self.controller = controller
    }
    
    override func didMove(to view: SKView) {
        let emailFieldFrame = CGRect(origin: CGPoint(x: 90, y: 450), size: CGSize(width: 200, height: 35))
        let emailField = UITextField(frame: emailFieldFrame)
        emailField.backgroundColor = UIColor.white
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.layer.borderWidth = 1.0
        emailField.placeholder = "Host A Game"
        self.view!.addSubview(emailField)
    }
}
