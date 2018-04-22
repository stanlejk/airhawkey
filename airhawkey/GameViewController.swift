//
//  GameViewController.swift
//  airhawkey
//
//  Created by Danny Peng on 4/21/18.
//  Copyright © 2018 Danny Peng. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SocketIO

class GameViewController: UIViewController, GameProtocol {
    
    let SockIOManager = SocketManager(socketURL: URL(string: "https://airhawkey-ifvictr.c9users.io")!,config:[.log(true)])
    var socket:SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.socket = SockIOManager.defaultSocket
        self.setSocketEvents()
        self.socket.connect()
        showLogin()
    }
    
    func showLogin() {
        if let scene = LoginScene(fileNamed: "LoginScene") {
            massageScene(scene: scene)
        }
    }
    
    func showLobby() {
        if let scene = LobbyScene(fileNamed: "LobbyScene") {
            massageScene(scene: scene)
        }
    }
    func showStartGame(){
        
    }
    func showGameOver(){
        
    }
    
    func massageScene(scene: SKScene) {
        let skView = self.view as! SKView
        let ss = scene as! Scene
        ss.setController(self)
        
        skView.showsFPS = false
        
        scene.scaleMode = .fill
        
        skView.presentScene(scene)
    }
    
    private func setSocketEvents() {
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        self.socket.on("got players") {data, ack in
            print(data)
        }
        self.socket.on("") {data, ack in
            
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
