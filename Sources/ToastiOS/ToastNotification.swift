//
//  ToastNotification.swift
//  ToastIOS
//
//  Created by Alex Brown on 20/04/2020.
//  Copyright © 2020 AJB. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif

@available(iOS 9.0, *)
internal class ToastNotification: UIView {

    var stackView: UIStackView
    let title: String
    let body: String?
    let accessoryView: ToastAccessory?
    let theme: ToastTheme
    
    var titleLabel: UILabel?
    var bodyLabel: UILabel?
    var accessoryViewContainer: UIView?
        
    var yConstraint: NSLayoutConstraint?
    
    var titleWeight: UIFont.Weight {
        return body != nil ? .bold : .medium
    }
    
    var titleSize: CGFloat {
        return body != nil ? 18 : 16
    }
     
    var textAlignment: NSTextAlignment {
        return accessoryView != nil ? .left : .center
    }
    
    var stackViewFill: UIStackView.Distribution {
        return accessoryView != nil ? .fillProportionally : .fillEqually
    }
    
    init(title: String, body: String? = nil, accessoryView: ToastAccessory? = nil, theme: ToastTheme = .standard) {
        self.title = title
        self.body = body
        self.accessoryView = accessoryView
        self.theme = theme
        stackView = UIStackView()
        super.init(frame: .zero)

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) not supported")
    }
    
    func updateToast(title: String?, body: String? = nil, accessoryView: UIView? = nil) {
        
        self.titleLabel?.text = title
        self.bodyLabel?.text = body

        // We don't want the container to shrink with the new text, but it can get bigger
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: self.frame.size.width).isActive = true
        
        if let accessoryView = accessoryView,
            let container = accessoryViewContainer {
            accessoryView.translatesAutoresizingMaskIntoConstraints = false
            container.subviews.forEach({ $0.removeFromSuperview() })
            container.addSubview(accessoryView)
            NSLayoutConstraint.activate([
                accessoryView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                accessoryView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
            ])
        }
        self.layoutIfNeeded()
    }
    
    private func setupView() {
        backgroundColor = theme.backgroundColor
        translatesAutoresizingMaskIntoConstraints = false

        addDefaultStackView()
        
        addContent()
        
        let width = UIScreen.main.bounds.width * 0.85
        layer.cornerRadius = 20
        NSLayoutConstraint.activate([
            widthAnchor.constraint(lessThanOrEqualToConstant: width),
            widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 20.0
    }
    
    private func addDefaultStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = stackViewFill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        let topConstant: CGFloat = body != nil ? 10 : 15
        let trailingConstraint: CGFloat = accessoryView != nil ? -20 : -15
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstraint),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    
    private func addContent() {
        let textContainerStackView = UIStackView()
        textContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        textContainerStackView.axis = .vertical
        textContainerStackView.spacing = 5
        textContainerStackView.distribution = .fillEqually
        
        titleLabel = addLabel(text: title, weight: titleWeight, size: titleSize)
        titleLabel?.textColor = theme.titleColor
        textContainerStackView.addArrangedSubview(titleLabel!)
        
        addBody(stackView: textContainerStackView)
        stackView.addArrangedSubview(textContainerStackView)
        
        addAccessoryView()
    }
    
    private func addBody(stackView: UIStackView) {
        guard let body = body
            else {return}
        
        bodyLabel = addLabel(text: body, weight: .medium, size: 16)
        bodyLabel?.textColor = theme.bodyColor
        stackView.addArrangedSubview(bodyLabel!)
    }
    
    private func addAccessoryView()  {
        guard let accessoryView = accessoryView
            else {return }
        
        accessoryViewContainer = UIView(frame: .zero)
        accessoryView.accessoryView.translatesAutoresizingMaskIntoConstraints = false
        accessoryViewContainer?.translatesAutoresizingMaskIntoConstraints = false
        
        accessoryViewContainer?.addSubview(accessoryView.accessoryView)
        
        NSLayoutConstraint.activate([
            accessoryView.accessoryView.centerYAnchor.constraint(equalTo: accessoryViewContainer!.centerYAnchor),
            accessoryView.accessoryView.centerXAnchor.constraint(equalTo: accessoryViewContainer!.centerXAnchor),
            accessoryViewContainer!.widthAnchor.constraint(equalToConstant: 30),
            accessoryViewContainer!.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
        
        let position = accessoryView.position == .right && !stackView.arrangedSubviews.isEmpty ? 1 : 0
        
        stackView.insertArrangedSubview(accessoryViewContainer!, at: position)
    }
    
    private func addLabel(text: String, weight: UIFont.Weight, size: CGFloat = 18) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
                
        label.numberOfLines = 3
        label.textAlignment = textAlignment
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        
        return label
    }
}
