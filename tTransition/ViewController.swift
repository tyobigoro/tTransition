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
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
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

    @IBOutlet weak var label: UILabel!
    
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
        
        let green = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! GreenVC
        let orange = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! OrangeVC
        let container: UIView! = transitionContext.containerView
        
        let animationLabelImageView = UIImageView(image: green.label.getImage())
        
        let fromFrame = container.convert(green.label.frame, from: green.view)
        let toFrame = container.convert(orange.label.frame, from: orange.view)
        
        animationLabelImageView.frame = fromFrame
        
        orange.view.frame = container.frame
        orange.view.alpha = .zero
        
        container.addSubview(orange.view)
        container.addSubview(animationLabelImageView)
        
        orange.label.isHidden = true
        green.label.isHidden = true
        
        // アニメーションしながら遷移元と遷移先を入れ替える
        UIView.animate(withDuration: duration, animations: {
            orange.view.alpha = 1.0
            animationLabelImageView.frame = toFrame
            
        }, completion: {_ in
            orange.label.isHidden = false
            green.removeFromParent()
            animationLabelImageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }

    // 復帰時の処理
    func animateDissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        fatalError("dismissalTransition has not been implemented")
        
        //// from: 遷移元, to:遷移先, container: 枠？を取得する
        //let from: UIViewController!
        //    = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        //let to: UIViewController!
        //    = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        //let container: UIView! = transitionContext.containerView
        //
        //// viewを変形させる設定
        //let transform: CGAffineTransform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        //
        //// 遷移先画面(to)を用意する
        //to.view.frame = container.frame
        //container.insertSubview(from.view, belowSubview: to.view)
        //
        //// アニメーションしながら遷移元と遷移先を入れ替える
        //UIView.animate(withDuration: duration, animations: {
        //    from.view.transform = transform
        //    from.view.alpha = .zero
        //}, completion: {_ in
        //    from.removeFromParent()
        //    transitionContext.completeTransition(true)
        //})
    }
}

extension UIView {
    
    func getImage() -> UIImage{
        
        // キャプチャする範囲を取得.
        let rect = self.bounds
        
        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        // 対象のview内の描画をcontextに複写する.
        self.layer.render(in: context)
        
        // 現在のcontextのビットマップをUIImageとして取得.
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
 
        // contextを閉じる.
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
}
