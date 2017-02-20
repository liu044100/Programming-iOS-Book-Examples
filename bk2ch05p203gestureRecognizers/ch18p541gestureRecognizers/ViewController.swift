

import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    let which = 1
    var dest: CGPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view that can be single-tapped, double-tapped, or dragged
        
        let t2 = UITapGestureRecognizer(target:self, action:#selector(doubleTap))
        t2.numberOfTapsRequired = 2
        self.v.addGestureRecognizer(t2)
        
        let t1 = UITapGestureRecognizer(target:self, action:#selector(singleTap))
        t1.require(toFail:t2) // *
        self.v.addGestureRecognizer(t1)

        switch which {
        case 1:
            let p = UIPanGestureRecognizer(target: self, action: #selector(dragging))
            self.v.addGestureRecognizer(p)
        case 2:
            let p = HorizPanGestureRecognizer(target: self, action: #selector(dragging))
            self.v.addGestureRecognizer(p)
            let p2 = VertPanGestureRecognizer(target: self, action: #selector(dragging))
            self.v.addGestureRecognizer(p2)

        default: break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dest = v.center
    }
    
    func singleTap () {
        print("single tap")
    }
    func doubleTap () {
        print("double tap")
    }
    
    func dragging(_ p : UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in:v.superview)
            var c = v.center
            c.x += delta.x; c.y += delta.y
            v.center = c
            p.setTranslation(.zero, in: v.superview)
        case .ended:
            ended(p, damping: true)
        default: break
        }
    }
    
    func ended(_ p : UIPanGestureRecognizer, damping: Bool) {
        if damping {
            let vel = p.velocity(in: v.superview!)
            print(vel)
            let c = v.center
            let distx = abs(c.x - dest.x)
            let disty = abs(c.y - dest.y)
            let initVel = CGVector(dx: vel.x / distx, dy: vel.y / disty)
            
            let anim = UIViewPropertyAnimator(duration: 0.4, timingParameters: UISpringTimingParameters(dampingRatio: 0.6, initialVelocity: initVel))
            anim.addAnimations {
                self.v.center = self.dest
            }
            anim.startAnimation()
        } else {
            let anim = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: {
                self.v.center = self.dest
            })
            anim.startAnimation()
        }
    }

}
