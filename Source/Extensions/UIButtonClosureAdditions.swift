//
//  UIButtonClosureAdditions.swift


import UIKit
import ObjectiveC

class ClosureWrapper: NSObject { //, NSCopying {
 var closure: (() -> Void)?
 convenience init(closure: (() -> Void)?) {
   self.init()
   self.closure = closure
 }
 func copyWithZone(zone: NSZone) -> AnyObject {
   let wrapper: ClosureWrapper = ClosureWrapper()
   wrapper.closure = closure
   return wrapper
 }
}

extension UIButton {
 private struct AssociatedKeys {
   static var SNGLSActionHandlerTapKey   = "sngls_ActionHandlerTapKey"
 }
 func handleControlEvent(event: UIControlEvents, handler:(() -> Void)?) {
   let aBlockClassWrapper = ClosureWrapper(closure: handler)
   objc_setAssociatedObject(self, &AssociatedKeys.SNGLSActionHandlerTapKey, aBlockClassWrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   self.addTarget(self, action: #selector(UIButton.callActionBlock(_:)), for: event)
 }

 func callActionBlock(_ sender: AnyObject) {
   let actionBlockAnyObject = objc_getAssociatedObject(self, &AssociatedKeys.SNGLSActionHandlerTapKey) as? ClosureWrapper
   actionBlockAnyObject?.closure?()
 }
}

