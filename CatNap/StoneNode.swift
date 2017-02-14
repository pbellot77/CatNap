//
//  StoneNode.swift
//  CatNap
//
//  Created by Patrick Bellot on 2/13/17.
//  Copyright © 2017 Bell OS, LLC. All rights reserved.
//

import SpriteKit

class StoneNode: SKSpriteNode, EventListnerNode, InteractiveNode {
	
	func didMoveToScene() {
		guard let scene = scene else {
			return
		}
		
		if parent == scene {
			scene.addChild(StoneNode.makeCompoundNode(in: scene))
		}
	}
	
	func interact() {
		isUserInteractionEnabled = false
		run(SKAction.sequence([
			SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
			SKAction.removeFromParent()
			]))
	}
	
	static func makeCompoundNode(in scene: SKScene) -> SKNode {
		let compound = StoneNode()
		
		for stone in scene.children.filter({ node in node is StoneNode}) {
			stone.removeFromParent()
			compound.addChild(stone)
		}
		
		let bodies = compound.children.map({ node in
			SKPhysicsBody(rectangleOf: node.frame.size, center: node.position)
		})
		
		compound.physicsBody = SKPhysicsBody(bodies: bodies)
		compound.physicsBody!.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Cat | PhysicsCategory.Block
		compound.physicsBody!.categoryBitMask = PhysicsCategory.Block
		compound.isUserInteractionEnabled = true
		compound.zPosition = 1
		return compound
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		interact()
	}
	
} // end of class
