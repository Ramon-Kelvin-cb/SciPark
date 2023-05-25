//
//  BodiesNode.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 04/05/23.
//

import Foundation
import SpriteKit

class ShipNode : SKNode{
    
    var intensities : [CGFloat] = [0.8 , 1 , 1]
    //[0] -> All, [1] -> Coh, [2] -> Sep
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    var shape: SKSpriteNode
    
    var velocity = CGPoint(x: .random(in: -0.1..<0.1), y: .random(in: -0.1..<0.1)).normalized
    var acc = CGPoint(x: .random(in: -0.1..<0.1), y: .random(in: -0.1..<0.1))
    
    var maxSteering : CGFloat = 0.2
    var maxVelocity : CGFloat = 7
    
    var front: CGPoint = .init(x: 0, y: 1)
    
    override init() {
        self.shape = SKSpriteNode(imageNamed: "body.png")
        
        
        super.init()
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.shape.size.width/2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = .enemy
        self.physicsBody?.contactTestBitMask = .player
        self.physicsBody?.collisionBitMask = .player
     
        self.addChild(self.shape)
        self.x = self.position.x
        self.y = self.position.y
        
        self.setMag()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func edges(size : CGSize){
        if self.position.x > size.width/2{
            self.position.x = -size.width/2
        }else if self.position.x < -size.width/2{
            self.position.x = size.width/2
        }else if self.position.y > size.height/2{
            self.position.y = -size.height/2
        }else if self.position.y < -size.height/2{
            self.position.y = size.height/2
        }
    }
    
    func setMag(){
        self.velocity = self.velocity.normalized * CGFloat.random(in: 2..<4)
    }
    
    func updatePos() {
        self.position += self.velocity
        self.velocity += self.acc
        
        self.zRotation = front.angle(to: self.velocity)
        
        if self.velocity.magnitude > self.maxVelocity{
            self.velocity = self.velocity.normalized * maxVelocity
        }
        
        self.acc *= 0
    }
    
    func allign(_ bodies : [ShipNode]) -> CGPoint{
        let perception : CGFloat = 100
        let nearby = bodies.filter({
            $0.position.distance(to: self.position) < perception && $0 != self
        })
        
        if nearby.count > 0{
            var steering : CGPoint = nearby.reduce(self.velocity/CGFloat(nearby.count + 1), {
                $0 + $1.velocity/CGFloat(nearby.count + 1)
            })
            
            steering = steering.normalized * maxVelocity - self.velocity
            
            //Limitando o steering pelo maxSteering
            if steering.magnitude > maxSteering {
                steering = steering.normalized * maxSteering
            }
            
            return steering
        } else {
            return .init(x: 0, y: 0)
        }
    }
    
    func cohesion(_ bodies : [ShipNode]) -> CGPoint{
        let perception : CGFloat = 100
        let nearby = bodies.filter({
            $0.position.distance(to: self.position) < perception && $0 != self
        })
        
        if nearby.count > 0{
            var steering : CGPoint = nearby.reduce(self.position/CGFloat(nearby.count + 1), {
                $0 + $1.position/CGFloat(nearby.count + 1)
            })
            
            steering = ((steering - self.position).normalized * maxVelocity) - self.velocity
            
            //Limitando o steering pelo maxSteering
            if steering.magnitude > maxSteering {
                steering = steering.normalized * maxSteering
            }
            
            return steering
        } else {
            return .init(x: 0, y: 0)
        }
    }
    
    func separation(_ bodies : [ShipNode]) -> CGPoint{
        let perception : CGFloat = 100
        let nearby = bodies.filter({
            $0.position.distance(to: self.position) < perception && $0 != self
        })
        
        if nearby.count > 0 {
            var steering : CGPoint = nearby.reduce(.init(x: 0, y: 0), {x , y in
                
                var dif = self.position - y.position
                let d = self.position.distance(to: y.position)
                dif = dif/(d * d)
                
                return x + dif/CGFloat(nearby.count)
            })
            
            steering = (steering.normalized * maxVelocity) - self.velocity
            
            //Limitando o steering pelo maxSteering
            if steering.magnitude > maxSteering {
                steering = steering.normalized * maxSteering
            }
            
            return steering
        } else {
            return .init(x: 0, y: 0)
        }
    }
    
    func flock(_ bodies :[ShipNode]){
        let allignment = self.allign(bodies) * self.intensities[0]
        let cohesion = self.cohesion(bodies) * self.intensities[1]
        let separation = self.separation(bodies) * self.intensities[2]
        
        self.acc += allignment
        self.acc += cohesion
        self.acc += separation
    }
    
    func allingnFunc(_ bodies : [ShipNode]){
        let allignment = self.allign(bodies) * self.intensities[0]
        self.acc += allignment
    }
    
    func cohesionFunc(_ bodies : [ShipNode]){
        let allignment = self.cohesion(bodies) * self.intensities[1]
        self.acc += allignment
    }
    
    func separateFunc(_ bodies : [ShipNode]){
        let allignment = self.separation(bodies) * self.intensities[2]
        self.acc += allignment
    }
}
