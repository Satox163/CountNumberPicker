//
//  CountNumberPickerView.swift
//  CountNumberPicker
//
//  Created by Dmitry Anokhin on 23.11.2020.
//

import UIKit

open class InputTimerContainerView: UIControl, UIKeyInput, UITextInputTraits {

    public let items: [Item] = [
        Item(),
        Item(),
        Item(),
        Item(),
    ]

    public var itemFont: UIFont = .systemFont(ofSize: 100, weight: .semibold) {
        didSet {
            items.forEach { $0.label.font = itemFont }
            separator.font = itemFont
        }
    }
    
    public var selectedColor: UIColor = .blue {
        didSet {
            items.forEach { $0.color = selectedColor }
        }
    }
    
    public var normalColor: UIColor = .black {
        didSet {
            items
                .lazy
                .filter { $0.isSelected == false }
                .forEach { $0.label.textColor = normalColor }
        }
    }
    
    public let stackView = setup(UIStackView()) {
        $0.axis = .horizontal
        $0.spacing = 2
    }
    
    private(set) lazy var separator = setup(UILabel()) {
        $0.text = ":"
        $0.font = itemFont
        $0.textColor = .black
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.3
    }
    
    public var hasText: Bool = true
    public var keyboardType: UIKeyboardType = .numberPad
    
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        isUserInteractionEnabled = true
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        items.forEach { element in
            element.label.text = "0"
            element.label.font = itemFont
            element.addAction(for: .touchUpInside) { [weak self, weak element] in
                if self?.isFirstResponder == false {
                    self?.becomeFirstResponder()
                }
                self?.items.first(where: \.isSelected)?.isSelected = false
                element?.isSelected = true
            }
        }
        Array<UIView>(
            Array(items[0...1]) + [separator] + Array(items[2...])
        ).forEach(stackView.addArrangedSubview)
    }
    
    public func insertText(_ text: String) {
        guard let value = Int(text) else { return }
        items
            .lastIndex { $0.isSelected == true }
            .flatMap { items[$0].validRange.contains(value) ? $0 : nil }
            .map { index in
                items[index].label.text = text
                items[index].isSelected = false
                if let newItem = items[safe: index + 1] {
                    newItem.isSelected = true
                } else {
                    items.first?.isSelected = true
                }
            }
    }
    
    public func deleteBackward() {
        items
            .lastIndex { $0.isSelected == true }
            .map { index in
                items[index].label.text = "0"
                guard index != 0 else { return }
                items[index].isSelected = false
                if let newItem = items[safe: index - 1] {
                    newItem.isSelected = true
                }
            }
    }
        
    private var _isFirstResponder: Bool = false
    
    public override var isFirstResponder: Bool {
        return _isFirstResponder
    }
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        _isFirstResponder = false
        items.first(where: \.isSelected)?.isSelected = false
        return super.resignFirstResponder()
    }
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        _isFirstResponder = true
        return super.becomeFirstResponder()
    }
    
    public override var canResignFirstResponder: Bool { true }
    
    public override var canBecomeFirstResponder: Bool { true }
}

public extension InputTimerContainerView {
    
    final class Item: UIControl {
        
        public let label = setup(UILabel()) {
            $0.font = .systemFont(ofSize: 100, weight: .semibold)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.3
            $0.isUserInteractionEnabled = false
        }
        
        public var color: UIColor = .blue {
            didSet {
                label.textColor = isSelected ? color : normalColor
            }
        }
        
        public var normalColor: UIColor = .black {
            didSet {
                label.textColor = isSelected ? color : normalColor
            }
        }
        
        public override var isSelected: Bool {
            didSet {
                label.textColor = isSelected ? color : normalColor
            }
        }
        
        public var validRange: ClosedRange<Int> = (0...1)
        
        public init() {
            super.init(frame: .zero)
            commonInit()
        }
        
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
        func commonInit() {
            addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: leadingAnchor),
                label.trailingAnchor.constraint(equalTo: trailingAnchor),
                label.topAnchor.constraint(equalTo: topAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
    }
    
}

