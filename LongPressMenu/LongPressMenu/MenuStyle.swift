//
//  MenuStyle.swift
//  henglinkiOS
//
//  Created by lian on 2021/6/7.
//  Copyright © 2021 恒力智能科技有限公司. All rights reserved.
//

import UIKit

class MenuStyle {
    
    enum ArrowDirection {
        
        case top
        
        case center
        
        case bottom
    }
    
    /// 每个单元格size
    var size: CGSize = CGSize(width: 50, height: 50)
    
    /// 箭头方向
    var arrowDirection: ArrowDirection = .top
    
    /// 每行最多几个
    var max: Int = 1
    
    /// 内边距
    var inset: UIEdgeInsets = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
    
    /// 箭头高度
    var arrowSpace: CGFloat = 10
    
    /// 水平方向最小边距
    var horizontalMiniSpace: CGFloat = 20
    
    /// 水平方向单元格间距
    var horizontalSpace: CGFloat = 12
    
    /// 垂直方向单元格间距
    var verticalSpace: CGFloat = 0
    
    var cornerRadius: CGFloat = 6
    
    var backgroundColor: UIColor? = UIColor(hexString: "#303030")
    
    var borderColor: UIColor = UIColor.clear
    
    var borderWidth: CGFloat = 1
    
    var shadow: Bool = false
    
    /// 是否需要自动适配
    var autoAdapt: Bool = false
    
    var minY: CGFloat = 0
    
    var maxY: CGFloat = 0
    
    init() {}
}

extension MenuStyle {
    
    static func horizontal(height: CGFloat) -> MenuStyle {
        let style = MenuStyle()
        style.size = CGSize(width: 48, height: 48)
        style.max = 5
        style.arrowDirection = .bottom
        style.verticalSpace = 24
        style.autoAdapt = true
        style.minY = ScreenConfigure.navigationBarTop
        style.maxY = ScreenConfigure.ScreenHeight - ScreenConfigure.safeAreaInsets.bottom - height
        return style
    }
}
