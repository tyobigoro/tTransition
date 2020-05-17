//
//  ViewController.swift
//  tTransition
//
//  Created by tyobigoro on 2020/05/17.
//  Copyright © 2020 tyobigoro. All rights reserved.
//

import UIKit

class GreenVC: UIViewController {

    let customTransition = CustomTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 遷移処理
    @IBAction func transitionToOrange(_ sender: Any) {
        
        let toVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "OrangeVC")
        
        toVC.modalPresentationStyle = .overCurrentContext
        toVC.transitioningDelegate  = customTransition
        
        present(toVC, animated: true, completion: nil)
    }
    
    // 戻ってきたときの処理
    @IBAction func backFromOrangeVC(segue: UIStoryboardSegue) {
        
    }
    
}

class OrangeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnDidTap(_ sender: Any) {
        performSegue(withIdentifier: "BacktoGreenVC", sender: nil)
        
    }
    
}


class CustomTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    fileprivate var isPresent: Bool = false
    fileprivate let duration : TimeInterval = 0.6

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            animatePresentTransition(transitionContext: transitionContext)
        } else {
            animateDissmissalTransition(transitionContext: transitionContext)
        }
    }

    // 遷移時の処理
    func animatePresentTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // from: 遷移元, to:遷移先, container: 枠？を取得する
        let from: UIViewController!
            = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let to: UIViewController!
            = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let container: UIView! = transitionContext.containerView
        
        // viewを変形させる設定
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        // 遷移先画面(to)を用意する
        to.view.frame = container.frame
        to.view.alpha = .zero
        container.insertSubview(to.view, belowSubview: from.view)
        to.view.transform = transform
        
        // アニメーションしながら遷移元と遷移先を入れ替える
        UIView.animate(withDuration: duration, animations: {
            to.view.transform = .identity
            to.view.alpha = 1.0
        }, completion: {_ in
            from.removeFromParent()
            transitionContext.completeTransition(true)
        })
    }

    // 復帰時の処理
    func animateDissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // from: 遷移元, to:遷移先, container: 枠？を取得する
        let from: UIViewController!
            = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let to: UIViewController!
            = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let container: UIView! = transitionContext.containerView
        
        // viewを変形させる設定
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        // 遷移先画面(to)を用意する
        to.view.frame = container.frame
        container.insertSubview(from.view, belowSubview: to.view)
        
        // アニメーションしながら遷移元と遷移先を入れ替える
        UIView.animate(withDuration: duration, animations: {
            from.view.transform = transform
            from.view.alpha = .zero
        }, completion: {_ in
            from.removeFromParent()
            transitionContext.completeTransition(true)
        })
    }
}

