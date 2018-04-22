//
//  Controller.swift
//  airhawkey
//
//  Created by Stanley Kim on 4/22/18.
//  Copyright © 2018 Danny Peng. All rights reserved.
//

import Foundation

protocol Controller: class {
    func showLogin()
    func showLobby()
    func showStartGame()
    func showGameOver()
}
