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
    let image: UIImage?
    
    var titleWeight: UIFont.Weight {
        return body != nil ? .bold : .medium
    }
    
    var titleSize: CGFloat {
        return body != nil ? 18 : 16
    }
     
    var textAlignment: NSTextAlignment {
        return image != nil ? .left : .center
    }
    
    var stackViewFill: UIStackView.Distribution {
        return image != nil ? .fillProportionally : .fillEqually
    }
    
    init(title: String, body: String? = nil, image: UIImage? = nil) {
        self.title = title
        self.body = body
        self.image = image
        stackView = UIStackView()
        super.init(frame: .zero)
        
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.systemBackground
        } else {
            backgroundColor = UIColor.white
        }
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) not supported")
    }
    
    private func setupView() {
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

        let bottomConstant: CGFloat = body != nil ? -15 : -15
        let topConstant: CGFloat = body != nil ? 10 : 15
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant)
        ])
    }
    
    private func addContent() {
        addImage()
        
        let textContainerStackView = UIStackView()
        textContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        textContainerStackView.axis = .vertical
        textContainerStackView.spacing = 5
        textContainerStackView.distribution = .fillEqually
        textContainerStackView.addArrangedSubview(addLabel(text: title, weight: titleWeight, size: titleSize))
                
        addBody(stackView: textContainerStackView)
        
        stackView.addArrangedSubview(textContainerStackView)
    }
    
    private func addBody(stackView: UIStackView) {
        guard let body = body
            else {return}
        
        let bodyLabel = addLabel(text: body, weight: .medium, size: 16)
        stackView.addArrangedSubview(bodyLabel)
    }
    
    private func addImage()  {
        guard let image = image
            else {return }
        
        let imageView = UIImageView(image: image)
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant: 30),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
        
        stackView.addArrangedSubview(container)
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
