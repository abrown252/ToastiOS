//
//  UIView+Toast.swift
//  ToastIOS
//
//  Created by Alex Brown on 20/04/2020.
//  Copyright © 2020 AJB. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

@available(iOS 9.0, *)
public extension UIView {
    
    // Wrappers for < iOS11 support
    private var safeAreaInsetTop: CGFloat {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets.top
        }
        return 0
    }
    
    private var safeAreaInsetBottom: CGFloat {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets.bottom
        }
        return 0
    }
    
    private var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        
        return topAnchor
    }
    
    private var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        
        return bottomAnchor
    }
    
    private func isShowingToast(for edge: ToastEdge) -> Bool {
        return getActiveToast(for: edge) != nil
    }
    
    private func getActiveToast(for edge: ToastEdge) -> ToastNotification? {
        return viewWithTag(edge.tag) as? ToastNotification
    }
    
    func makeToast(title: String, edge: ToastEdge = .top) {
        if isShowingToast(for: edge) {return}
        
        let toast = ToastNotification(title: title)
        toast.tag = edge.tag
        addSubview(toast)
        
        toast.setNeedsLayout()
        toast.layoutIfNeeded()
        
        layout(edge: edge, toast: toast)
    }
    
    func makeToast(configuration: ToastConfiguration) {
        if isShowingToast(for: configuration.edge) {return}
        
        let toast = ToastNotification(title: configuration.title, body: configuration.body, accessoryView: configuration.accessoryView)
        toast.tag = configuration.edge.tag
        addSubview(toast)
        
        toast.setNeedsLayout()
        toast.layoutIfNeeded()
        
        layout(edge: configuration.edge, toast: toast, duration: configuration.displayDuration, autoDismiss: configuration.autoDismiss)
    }
    
    func dismissActiveToast(for edge: ToastEdge) {
        guard let toast = getActiveToast(for: edge)
            else {assert(false, "Could not find toast at edge \(edge)"); return}
        
        animateOut(toast: toast, delay: 0, edge: edge)
    }
    
    func updateActiveToast(for edge: ToastEdge, title: String?, body: String?, accessoryView: UIView?) {
        guard let toast = getActiveToast(for: edge)
            else {assert(false, "Could not find toast at edge \(edge)"); return}
        
        toast.updateToast(title: title, body: body, accessoryView: accessoryView)
    }
    
    private func layout(edge: ToastEdge, toast: ToastNotification, duration: TimeInterval = 3, autoDismiss: Bool = true) {

        let constraints = self.constraints(for: edge, toast: toast)
        let yConstraint = constraints.y
        toast.yConstraint = yConstraint
        NSLayoutConstraint.activate([constraints.x, yConstraint])
        self.layoutIfNeeded()
        
        animate(toast: toast, duration: duration, edge: edge, autoDismiss: autoDismiss)
    }

    private func animate(toast: ToastNotification, duration: TimeInterval, edge: ToastEdge, autoDismiss: Bool = true) {
        guard let yConstraint = toast.yConstraint
            else {return}
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
            yConstraint.constant = 0
            self.layoutIfNeeded()
        }, completion: nil)
        
        if autoDismiss {
            self.animateOut(toast: toast, delay: duration, edge: edge)
        }
    }

    private func animateOut(toast: ToastNotification, delay: TimeInterval, edge: ToastEdge) {
        guard let yConstraint = toast.yConstraint
            else {return}
        
        UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseInOut, animations: {
            if edge == .top {
                yConstraint.constant = -(toast.frame.height + self.safeAreaInsetTop)
            } else {
                yConstraint.constant += (toast.frame.height + self.safeAreaInsetBottom)
            }

            self.layoutIfNeeded()
        }) { (complete) in
            toast.removeFromSuperview()
        }
    }
    
    private func constraints(for edge: ToastEdge, toast: ToastNotification) -> (x: NSLayoutConstraint, y: NSLayoutConstraint) {
        let xCenter = toast.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        
        if edge == .top {
            let yConstraint = toast.topAnchor.constraint(equalTo: safeAreaTopAnchor, constant: -(toast.frame.height + safeAreaInsetTop))
            return (x: xCenter, y: yConstraint)
        }
        
        let yConstraint = toast.bottomAnchor.constraint(equalTo: safeAreaBottomAnchor, constant: toast.frame.height + safeAreaInsetBottom)
        return (x: xCenter, y: yConstraint)
    }
}
