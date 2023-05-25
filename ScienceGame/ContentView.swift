//
//  ContentView.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 26/04/23.
//

import SwiftUI
import CoreGraphics
import AVFoundation
import SpriteKit

struct ContentView: View {
    
    let displaySize: CGRect = UIScreen.main.bounds
    
    @State var audioPlayer: AVAudioPlayer!
    
    var scene : SKScene {
        let screenWidth: CGFloat = displaySize.width
        let screenHeight: CGFloat = displaySize.height
        
        let scene = StartScene()
        //        let scene = ShakeScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .fill
        return scene
    }
    

    
    var body: some View {
        ZStack{
            SpriteView(scene: scene)  //Adiciona debugging aqui
                .frame(width: displaySize.width, height: displaySize.height)
                .ignoresSafeArea()
        }
        .onAppear(){
            self.playSounds("soundtrack")
        }
    }
    
    
    func playSounds(_ soundFileName : String) {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav") else {
            fatalError("Unable to find \(soundFileName) in bundle")
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.numberOfLoops = -1
        } catch {
            print(error.localizedDescription)
        }
        audioPlayer.play()
    }
    
}

