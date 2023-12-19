//
//  ScreenConfigure.swift
//  henglinkiOS
//
//  Created by lian on 2022/7/27.
//  Copyright © 2022 恒力智能科技有限公司. All rights reserved.
//

import UIKit

struct ScreenConfigure {
    
    public static var ScreenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    /// 屏幕高度
    public static var ScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 屏幕宽度
    public static var ScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// 导航栏高度
    public static var navigationBarHeight: CGFloat {
        return 44
    }
    
    /// 状态栏高度
    public static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    /// 顶部高度
    public static var navigationBarTop: CGFloat {
        return navigationBarHeight + statusBarHeight
    }
    
    public static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
        } else {
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
        }
    }
    
    private init() {}
}

public extension Double {
    var scale: CGFloat {
        let scale = ScreenConfigure.ScreenWidth / 375
        return CGFloat(self * Double(scale))
    }
}
