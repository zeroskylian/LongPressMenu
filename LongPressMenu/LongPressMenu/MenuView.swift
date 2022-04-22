//
//  MenuView.swift
//  SwiftiOS
//
//  Created by lian on 2021/6/2.
//

import UIKit

class MenuView: UIView {
    
    static func show(from sender: UIView, style: MenuStyle, items: [MenuItem]) {
        let menu = MenuView(sender: sender, style: style, items: items)
        menu.show()
    }
    
    /// 背景视图
    private(set) lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return backgroundView
    }()
    
    let sender: UIView
    
    fileprivate let container: MenuItemContainer
    
    fileprivate let arrowView: UIView = UIView()
    
    fileprivate lazy var backgroundLayer: CAShapeLayer = {
        let layer: CAShapeLayer = CAShapeLayer()
        return layer
    }()
    
    let style: MenuStyle
    
    init(sender: UIView,style: MenuStyle, items: [MenuItem]) {
        self.sender = sender
        self.style = style
        container = MenuItemContainer(style: style, items: items)
        super.init(frame: UIScreen.main.bounds)
        container.delegate = self
        configureUI()
    }
    
    private func configureUI() {
        addSubview(backgroundView)
        addSubview(arrowView)
        backgroundView.frame = bounds
        arrowView.addSubview(container)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        backgroundView.addGestureRecognizer(tap)
        let arrowPoint = configureFrame()
        drawBackgroundLayerWithArrowPoint(arrowPoint: arrowPoint)
    }
    
    private func configureFrame() -> CGPoint {
        let rect = convert(sender.frame, to: self)
        let containerSize = container.calculateSize()
        let arrowSize = CGSize(width: containerSize.width, height: containerSize.height + style.arrowSpace)
        var y: CGFloat = 0
        if style.arrowDirection == .top {
            y = rect.maxY
        } else {
            y = rect.minY - arrowSize.height
        }
        let anchorPoint = CGPoint(x: max(style.horizontalMiniSpace, rect.minX + rect.width / 2.0 - arrowSize.width / 2.0), y: y)
        let arrowRect: CGRect = CGRect(origin: anchorPoint, size: arrowSize)
        arrowView.frame = arrowRect
        container.frame = CGRect(x: 0, y: style.arrowDirection == .top ? style.arrowSpace : 0, width: containerSize.width, height: containerSize.height)
        let originCenter = CGPoint(x: 150, y: 0)
        let tr = arrowView.convert(originCenter, from: sender)
        return CGPoint(x: tr.x, y: style.arrowDirection == .top ? 0 : arrowSize.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let animationDuration: TimeInterval = 0.2
    
    func show() {
        guard let keyWindow = keyWindow() else { return }
        keyWindow.addSubview(self)
        self.arrowView.alpha = 0
        UIView.animate(withDuration: animationDuration) {
            self.arrowView.alpha = 1
        } completion: { _ in
            
        }
    }
    
    func hide() {
        self.arrowView.alpha = 1
        UIView.animate(withDuration: animationDuration) {
            self.arrowView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    
    func keyWindow() -> UIWindow? {
        var originalKeyWindow : UIWindow? = nil
        
        #if swift(>=5.1)
        if #available(iOS 13, *) {
            originalKeyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            originalKeyWindow = UIApplication.shared.keyWindow
        }
        #else
        originalKeyWindow = UIApplication.shared.keyWindow
        #endif
        return originalKeyWindow
    }
    
    @objc private func tapGestureAction(_ tap: UITapGestureRecognizer) {
        hide()
    }
    
    deinit {
        print("deinit === meun")
    }
    fileprivate func drawBackgroundLayerWithArrowPoint(arrowPoint: CGPoint) {
        if self.backgroundLayer.superlayer != nil {
            self.backgroundLayer.removeFromSuperlayer()
        }
        
        backgroundLayer.path = getBackgroundPath(arrowPoint: arrowPoint).cgPath
        backgroundLayer.fillColor = style.backgroundColor.cgColor
        backgroundLayer.strokeColor = style.borderColor.cgColor
        backgroundLayer.lineWidth = style.borderWidth
        
        if style.shadow {
            backgroundLayer.shadowColor = UIColor.black.cgColor
            backgroundLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            backgroundLayer.shadowRadius = 24.0
            backgroundLayer.shadowOpacity = 0.9
            backgroundLayer.masksToBounds = false
            backgroundLayer.shouldRasterize = true
            backgroundLayer.rasterizationScale = UIScreen.main.scale
        }
        arrowView.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    private func getBackgroundPath(arrowPoint: CGPoint) -> UIBezierPath {
        
        let viewWidth = arrowView.frame.width
        let viewHeight = arrowView.frame.height
        
        let radius: CGFloat = style.cornerRadius
        
        let path: UIBezierPath = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        let arrowDirection = style.arrowDirection
        if (arrowDirection == .top){
            path.move(to: CGPoint(x: arrowPoint.x - MenuConstant.DefaultMenuArrowWidth, y: MenuConstant.DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: 0))
            path.addLine(to: CGPoint(x: arrowPoint.x + MenuConstant.DefaultMenuArrowWidth, y: MenuConstant.DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x:viewWidth - radius, y: MenuConstant.DefaultMenuArrowHeight))
            path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: MenuConstant.DefaultMenuArrowHeight + radius),
                        radius: radius,
                        startAngle: .pi / 2 * 3,
                        endAngle: 0,
                        clockwise: true)
            path.addLine(to: CGPoint(x: viewWidth, y: viewHeight - radius))
            path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: viewHeight - radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: .pi / 2,
                        clockwise: true)
            path.addLine(to: CGPoint(x: radius, y: viewHeight))
            path.addArc(withCenter: CGPoint(x: radius, y: viewHeight - radius),
                        radius: radius,
                        startAngle: .pi / 2,
                        endAngle: .pi,
                        clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: MenuConstant.DefaultMenuArrowHeight + radius))
            path.addArc(withCenter: CGPoint(x: radius, y: MenuConstant.DefaultMenuArrowHeight + radius),
                        radius: radius,
                        startAngle: .pi,
                        endAngle: .pi / 2 * 3,
                        clockwise: true)
            path.close()
        }else{
            path.move(to: CGPoint(x: arrowPoint.x - MenuConstant.DefaultMenuArrowWidth, y: viewHeight - MenuConstant.DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: viewHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x + MenuConstant.DefaultMenuArrowWidth, y: viewHeight - MenuConstant.DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: viewWidth - radius, y: viewHeight - MenuConstant.DefaultMenuArrowHeight))
            path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: viewHeight - MenuConstant.DefaultMenuArrowHeight - radius),
                        radius: radius,
                        startAngle: .pi / 2,
                        endAngle: 0,
                        clockwise: false)
            path.addLine(to: CGPoint(x: viewWidth, y: radius))
            path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: .pi / 2 * 3,
                        clockwise: false)
            path.addLine(to: CGPoint(x: radius, y: 0))
            path.addArc(withCenter: CGPoint(x: radius, y: radius),
                        radius: radius,
                        startAngle: .pi / 2 * 3,
                        endAngle: .pi,
                        clockwise: false)
            path.addLine(to: CGPoint(x: 0, y: viewHeight - MenuConstant.DefaultMenuArrowHeight - radius))
            path.addArc(withCenter: CGPoint(x: radius, y: viewHeight - MenuConstant.DefaultMenuArrowHeight - radius),
                        radius: radius,
                        startAngle: .pi,
                        endAngle: .pi / 2,
                        clockwise: false)
            path.close()
        }
        return path
    }
}

extension MenuView: MenuItemContainerDelegate {
    func menuItemContainer(view: MenuItemContainer, didSelect item: MenuItem) {
        item.action()
        hide()
    }
}
