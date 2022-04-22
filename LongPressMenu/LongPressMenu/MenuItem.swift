//
//  MenuItem.swift
//  SwiftiOS
//
//  Created by lian on 2021/6/1.
//

import UIKit

struct MenuItem {
    let title: String
    let image: UIImage?
    let action: () -> Void
}

class MenuItemView: UIView {
    
    let item: MenuItem
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 30, width: 50, height: 20))
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    init(item: MenuItem) {
        self.item = item
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        addSubview(titleLabel)
        addSubview(imageView)
        titleLabel.text = item.title
        imageView.image = item.image
        
        let coverBtn = UIButton(frame: bounds)
        coverBtn.addTarget(self, action: #selector(coverAction), for: .touchUpInside)
        addSubview(coverBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func coverAction() {
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
}

