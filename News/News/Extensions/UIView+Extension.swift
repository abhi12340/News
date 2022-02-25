//
//  UIView+Extension.swift
//  News
//
//  Created by Abhishek Kumar on 25/02/22.
//

import UIKit


extension UIView {
    
    func showToast(message : String, yPosition: CGFloat, duration: Int) {
        
            let toastLabel = UILabel(frame: CGRect(x: 50, y: yPosition,
                                                   width: self.frame.size.width - 100,
                                                   height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont.systemFont(ofSize: 12)
            toastLabel.text = message
            toastLabel.numberOfLines = 0
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.addSubview(toastLabel)
            self.bringSubviewToFront(toastLabel)

            UIView.animate(withDuration: TimeInterval(duration), delay: 0,
            options: [.curveEaseIn], animations: { () -> Void in

            toastLabel.alpha = 0.0

            }) { _ in

            toastLabel.removeFromSuperview()
            }
        }
}
