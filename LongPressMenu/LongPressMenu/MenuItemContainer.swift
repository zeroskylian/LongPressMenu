//
//  MenuItemContainer.swift
//  SwiftiOS
//
//  Created by lian on 2021/6/2.
//

import UIKit
import SnapKit

protocol MenuItemContainerDelegate: AnyObject {
    func menuItemContainer(view: MenuItemContainer, didSelect item: MenuItem)
}

class MenuItemContainer: UIView {
    
    weak var delegate: MenuItemContainerDelegate?
    
    var items: [MenuItem]
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellWithClass: MenuItemContainerVerticalCell.self)
        collectionView.register(cellWithClass: MenuItemContainerHorizontalCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let style: MenuStyle
    
    init(style: MenuStyle, items: [MenuItem]) {
        self.style = style
        self.items = items
        super.init(frame: .zero)
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = .clear
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateSize() -> CGSize {
        let insetHeight = style.inset.top + style.inset.bottom
        let insetWidth = style.inset.left + style.inset.right
        let size = style.size
        if items.count <= style.max {
            var interLine: Int = 1
            let maxWidth = UIScreen.main.bounds.width - insetWidth - style.horizontalMiniSpace * 2
            let currentWidth = CGFloat(items.count) * size.width
            if currentWidth > maxWidth {
                let row: Int = Int(maxWidth / size.width)
                let reminder = items.count % row
                interLine = items.count / row + (reminder != 0 ? 1 : 0)
            }
            let cal = CGSize(width: insetWidth + min(currentWidth, maxWidth), height: insetHeight + size.height * CGFloat(interLine))
            return cal
        } else {
            let reminder = items.count % style.max
            let line = items.count / style.max + (reminder != 0 ? 1 : 0)
            let cal = CGSize(width: insetWidth + CGFloat(style.max) * size.width, height: insetHeight + size.height * CGFloat(line))
            return cal
        }
    }
}

extension MenuItemContainer: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return style.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return style.inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MenuItemContainer: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.menuItemContainer(view: self, didSelect: item)
    }
}

extension MenuItemContainer: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MenuItemContainerHorizontalCell.self, for: indexPath)
        cell.bind(item: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}

class MenuItemContainerVerticalCell: UICollectionViewCell {
    let imageView: UIImageView = UIImageView()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(item: MenuItem) {
        imageView.image = item.image
        titleLabel.text = item.title
    }
}

class MenuItemContainerHorizontalCell: UICollectionViewCell {
    let imageView: UIImageView = UIImageView()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.bottom.equalToSuperview()
            make.left.equalTo(imageView.snp.right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(item: MenuItem) {
        imageView.image = item.image
        titleLabel.text = item.title
    }
}
