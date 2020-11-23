//
//  UIControl+Helper.swift
//  CountNumberPicker
//
//  Created by Dmitry Anokhin on 23.11.2020.
//

import UIKit

private final class ClosureSleeve {
    private let closure: () -> Void

    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc
    func invoke() {
        closure()
    }
}

extension UIControl {
    @objc
    func addAction(for controlEvents: UIControl.Event, closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        let random = String(format: "[%d]", arc4random())
        objc_setAssociatedObject(
            self,
            random,
            sleeve,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}

