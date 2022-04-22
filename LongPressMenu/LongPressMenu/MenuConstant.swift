//
//  MenuConstant.swift
//  SwiftiOS
//
//  Created by lian on 2021/6/2.
//

import UIKit

class MenuStyle {
    
    enum ArrowDirection {
        case top
        case bottom
    }
    
    /// 每个单元格size
    var size: CGSize = CGSize(width: 50, height: 50)
    
    /// 箭头方向
    var arrowDirection: ArrowDirection = .top
    
    /// 每行最多几个
    var max: Int = 1
    
    /// 内边距
    var inset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    /// 箭头高度
    var arrowSpace: CGFloat = 10
    
    /// 水平方向最小边距
    var horizontalMiniSpace: CGFloat = 20
    
    var cornerRadius: CGFloat = 6
    
    var backgroundColor: UIColor = UIColor.black
    
    var borderColor: UIColor = UIColor.clear
    
    var borderWidth: CGFloat = 1
    
    var shadow: Bool = false
    
    init() {}
}

extension MenuStyle {
    
    static let vertical: MenuStyle = {
        let style = MenuStyle()
        style.size = CGSize(width: 100, height: 50)
        style.max = 1
        return style
    }()
    
    static let horizontal: MenuStyle = {
        let style = MenuStyle()
        style.size = CGSize(width: 100, height: 50)
        style.max = 5
        style.arrowDirection = .bottom
        return style
    }()
}


struct MenuConstant {
    internal static let DefaultMenuArrowWidth = CGFloat(8)
    internal static let DefaultMenuArrowHeight = CGFloat(10)
}
