//
//  GameProtocol.swift
//  airhawkey
//
//  Created by Stanley Kim on 4/22/18.
//  Copyright © 2018 Danny Peng. All rights reserved.
//

import SpriteKit

protocol GameProtocol: class {
    func showLogin()
    func showLobby()
    func showStartGame()
    func showGameOver()
}
