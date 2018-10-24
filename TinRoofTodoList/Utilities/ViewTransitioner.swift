//
//  ViewTransitioner.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/23/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import Foundation
import UIKit

public enum TransitionDirection {
    case left
    case right
}

class ViewTransitioner {
    /// Amount of time, in seconds, that it will take to complete a transition
    private let transitionDuration: TimeInterval = 0.5
    /// The active container will always reference the on-screen view
    private var activeViewContainer: UIView
    /// The inactive container references an off-screen view that holds the next view for a future transition
    private var inactiveViewContainer: UIView
    
    init(parent: UIView) {
        // create containers
        let inactiveFrame = CGRect(x: parent.bounds.origin.x + parent.bounds.width,
                                   y: parent.bounds.origin.y,
                                   width: parent.bounds.width,
                                   height: parent.bounds.height)
        inactiveViewContainer = UIView(frame: inactiveFrame)
        parent.addSubview(inactiveViewContainer)
        activeViewContainer = UIView(frame: parent.bounds)
        parent.addSubview(activeViewContainer)
    }
    
    /// Moves our off-screen, inactive view to either the left or right side of the active view
    ///
    /// - Parameter direction: where the inactive view should be placed relative to the active view
    private func placeInactiveView(on direction: TransitionDirection) {
        var newFrameX: CGFloat
        switch direction {
        case .left:
            newFrameX = -activeViewContainer.frame.width
        case .right:
            newFrameX = activeViewContainer.frame.width
        }
        
        let newFrame = CGRect(x: newFrameX,
                              y: activeViewContainer.bounds.origin.y,
                              width: activeViewContainer.bounds.width,
                              height: activeViewContainer.bounds.height)
        inactiveViewContainer.frame = newFrame
    }
    
    /// Adds a view to our "stack" of two views. If there are already two views, the view currently in the inactive container is replaced
    /// with the new provided view.
    ///
    /// - Parameter view: <#view description#>
    public func addView(_ view: UIView) {
        // if we don't have a view in our active view, then this new view will go in there
        if activeViewContainer.subviews.isEmpty {
            view.frame = activeViewContainer.bounds
            activeViewContainer.addSubview(view)
            return
        }
        
        // if our active view is already filled with a subview, then this new view will go in the off-screen container
        // remove a previously added subview if present
        if !inactiveViewContainer.subviews.isEmpty {
            _ = inactiveViewContainer.subviews.map { $0.removeFromSuperview() }
        }
        view.frame = inactiveViewContainer.bounds
        inactiveViewContainer.addSubview(view)
    }
    
    /// Places the transitioner's inactiveview at the correct position and performs the correct animation to bring the new view
    /// on-screen
    ///
    /// - Parameter direction: direction of the animation's movement
    public func transition(inDirection direction: TransitionDirection) {
        let originalActiveTransform = activeViewContainer.transform
        let originalInactiveTransform = inactiveViewContainer.transform
        var newActiveTransform: CGAffineTransform
        var newInactiveTransform: CGAffineTransform
        // need to place the off-screen container on the side of the active container
        var newInactivePositionDirection: TransitionDirection
        // determine our transform values via the transition direction
        switch direction {
        case .left:
            newActiveTransform = originalActiveTransform.translatedBy(x: -activeViewContainer.frame.width, y: 0.0)
            newInactiveTransform = originalInactiveTransform.translatedBy(x: -inactiveViewContainer.frame.width, y: 0.0)
            newInactivePositionDirection = .right
        case .right:
            newActiveTransform = originalActiveTransform.translatedBy(x: activeViewContainer.frame.width, y: 0.0)
            newInactiveTransform = originalInactiveTransform.translatedBy(x: inactiveViewContainer.frame.width, y: 0.0)
            newInactivePositionDirection = .left
        }
        
        placeInactiveView(on: newInactivePositionDirection)
        
        // animate both containers simultaneously and switch their references once the animation completes
        UIView.animate(withDuration: transitionDuration, animations: {
            self.activeViewContainer.transform = newActiveTransform
            self.inactiveViewContainer.transform = newInactiveTransform
        }) { [weak self] _ in
            guard self != nil else {
                return
            }
            let hold = self!.activeViewContainer
            self!.activeViewContainer = self!.inactiveViewContainer
            self!.inactiveViewContainer = hold
        }
    }
}
