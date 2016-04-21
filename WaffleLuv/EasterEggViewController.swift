//
//  EasterEggViewController.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/14/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit
import QuartzCore
import CoreMotion

class EasterEggViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var maxX : CGFloat = 320
    
    var maxY : CGFloat = 500
    
    let boxSize : CGFloat = 35.0

    let startPoint = CGPointMake(50, 50)
    
    // var prevBox = UIView()
    
    var boxes = [UIView]()
    
    var animator:UIDynamicAnimator?
    
    let gravity = UIGravityBehavior()
    
    let collider = UICollisionBehavior()
    
    let itemBehavior = UIDynamicItemBehavior()
    
    let imageView = UIView()

    // For getting device motion updates
    let motionQueue = NSOperationQueue.mainQueue()
    
    let motionManager = CMMotionManager()
    
    //MARK: - Views did
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load")
        
        createAnimatorStuff()
        generateBoxes()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSLog("Starting gravity")
        
        motionManager.startDeviceMotionUpdatesToQueue(motionQueue, withHandler:gravityUpdated)
        
        
    }
    
    override func viewDidDisappear(animated: Bool)  {
        super.viewDidDisappear(animated)
        NSLog("Stopping gravity")
        motionManager.stopDeviceMotionUpdates()
    }
    
    //MARK: - Add and generate boxes
    
    func addBox(location: CGRect) -> UIView {
        
        // Creates new box and appends new box into box array
        
        let newBox = UIView(frame: location)

        newBox.backgroundColor = UIColor.darkGrayColor()

        view.addSubview(newBox)
        
        addBoxToBehaviors(newBox)
        
        newBox.layer.masksToBounds = true
        
        newBox.layer.cornerRadius = 15
        
        let imageName = "waffle"
        
        let image = UIImage(named: imageName)
        
        let imageView = UIImageView(image: image!)
        
        imageView.frame.size = CGSize(width: 30, height: 30)
        
        imageView.layer.cornerRadius = 15
        
        imageView.layer.masksToBounds = true
        
        newBox.addSubview(imageView)
        
        boxes.append(newBox)
        
        return newBox
  
    }
    
    func generateBoxes() {
        // generates new boxes and gives them properties
        
        for _ in 0...60 {
            
            let frame = randomFrame()

            _ = addBox(frame)
            
        }

        print("boxes generated")
    }
    
    func randomFrame() -> CGRect {
        
        var guess = CGRectMake(9, 9, 9, 9)
        
        repeat {

            let guessX = CGFloat(arc4random()) % maxX
            
            let guessY = CGFloat(arc4random()) % maxY
            
            guess = CGRectMake(guessX, guessY, boxSize, boxSize)
            
        } while(!doesNotCollide(guess))
        
        
        
        return guess
    }
    
    
    
    func doesNotCollide(testRect: CGRect) -> Bool {
        
        for box in boxes {
            
            // print("boxes will not collide")
            
            let viewRect = box.frame
            
            
            if(CGRectIntersectsRect(testRect, viewRect)) {
                
                return false
            }
        }
        return true
    }
    
    
    
    //----------------- UIDynamicAllocator
    
    //MARK: - Create animator and give boxes animation properties
    
    
    func createAnimatorStuff() {
        
        print("animations created")
        
        // Adds behaviors to UIDynamicAnimator
        
        animator = UIDynamicAnimator(referenceView:self.view)
        
        gravity.gravityDirection = CGVectorMake(0, 0.8)
        
        animator?.addBehavior(gravity)
        
        // We're bouncin' off the walls
        collider.translatesReferenceBoundsIntoBoundary = true
        
        collider.collisionDelegate = self
        
        collider.collisionMode = .Everything
        
        animator?.addBehavior(collider)
        
        itemBehavior.friction = 0.2
        itemBehavior.elasticity = 0.8

        animator?.addBehavior(itemBehavior)
    }
    
    func addBoxToBehaviors(box: UIView) {
        // gives each new box gravity and collision behaviors
        
        print("behaviors added to boxes")
        gravity.addItem(box)
        collider.addItem(box)
        itemBehavior.addItem(box)
        itemBehavior.angularVelocityForItem(box)
    }
    
    //----------------- Core Motion
    
    //MARK: - Gravity Closure
    
    func gravityUpdated(motion: CMDeviceMotion?, error: NSError?) {
        
        // print("gravity updated")
        
        // This is the gravity closure used in the Motion Manager
        
        let grav : CMAcceleration = motion!.gravity;
        
        let x = CGFloat(grav.x)
        
        let y = CGFloat(grav.y)
        
        var p = CGPointMake(x,y)
        
        if (error != nil) {
            NSLog("\(error)")
        }
        
        // Have to correct for orientation.
        let orientation = UIApplication.sharedApplication().statusBarOrientation;
        
        if(orientation == UIInterfaceOrientation.LandscapeLeft) {
            let t = p.x
            p.x = 0 - p.y
            p.y = t
        } else if (orientation == UIInterfaceOrientation.LandscapeRight) {
            let t = p.x
            p.x = p.y
            p.y = 0 - t
        } else if (orientation == UIInterfaceOrientation.PortraitUpsideDown) {
            p.x *= -1
            p.y *= -1
        }
        
        let v = CGVectorMake(p.x, 0 - p.y);
        gravity.gravityDirection = v;
    }



}
