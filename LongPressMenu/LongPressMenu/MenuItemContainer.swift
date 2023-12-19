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
        collectionView.register(cellWithClass: MenuItemContainerDefaultCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(hexString: "#F1F1F1")?.withAlphaComponent(0.2)
        line.isHidden = true
        return line
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
        collectionView.addSubview(line)
        let size = calculateSize()
        let width = size.width - 24
        let originY = style.size.height + style.inset.top + style.verticalSpace / 2.0
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(width)
            make.top.equalToSuperview().offset(originY)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 计算大小
    /// - Returns: size
    func calculateSize() -> CGSize {
        let insetHeight = style.inset.top + style.inset.bottom
        let insetWidth = style.inset.left + style.inset.right
        let size = style.size
        // 单行
        if items.count <= style.max {
            var interLine: Int = 1
            let maxWidth = UIScreen.main.bounds.width - insetWidth - style.horizontalMiniSpace * 2
            let currentWidth = CGFloat(items.count) * size.width + CGFloat(items.count - 1) * style.horizontalSpace
            if currentWidth > maxWidth {
                let row: Int = Int(maxWidth / (size.width + style.horizontalSpace))
                let reminder = items.count % row
                interLine = items.count / row + (reminder != 0 ? 1 : 0)
                line.isHidden = false
            }
            let cal = CGSize(width: insetWidth + min(currentWidth, maxWidth), height: insetHeight + size.height * CGFloat(interLine) + CGFloat(max(interLine - 1, 0)) * style.verticalSpace)
            return cal
        } else {
            let reminder = items.count % style.max
            let line = items.count / style.max + (reminder != 0 ? 1 : 0)
            let cal = CGSize(width: insetWidth + CGFloat(style.max) * size.width + CGFloat(style.max - 1) * style.horizontalSpace,
                             height: insetHeight + size.height * CGFloat(line) + CGFloat(max(line - 1, 0)) * style.verticalSpace)
            self.line.isHidden = false
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
        return style.verticalSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return style.horizontalSpace
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
        let cell = collectionView.dequeueReusableCell(withClass: MenuItemContainerDefaultCell.self, for: indexPath)
        cell.bind(item: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}

class MenuItemContainerDefaultCell: UICollectionViewCell {
    let imageView: UIImageView = UIImageView()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 11)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.size.equalTo(CGSize(width: 22, height: 22))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(8)
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
