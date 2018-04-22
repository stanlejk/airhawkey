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
    var joinButton = ButtonNode(normalImageNamed: "join", activeImageNamed: "join", disabledImageNamed: "join")
    
    func setController(_ controller: GameProtocol) {
        self.controller = controller
    }
    
    override func didMove(to view: SKView) {
        addChild(joinButton)
        joinButton.zPosition = 3
        joinButton.position.x = 20
        joinButton.position.y = -115
        joinButton.setScale(0.8)
        joinButton.selectedHandler = {
            self.controller.showStartGame()
        }
    }
}
