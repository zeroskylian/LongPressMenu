//
//  ViewController.swift
//  LongPressMenu
//
//  Created by lian on 2022/4/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v1 = UIView(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        v1.backgroundColor = .red
        view.addSubview(v1)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
        v1.addGestureRecognizer(longPress)
        
        // Do any additional setup after loading the view.
    }

    @objc private func longPressAction(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let view = gesture.view else { break }
            let add = MenuItem(title: "测试", image: UIImage(named: "add")) {
                
            }
            MenuView.show(from: view, style: .horizontal(height: 0), items: [add])
        default:
            break
        }
    }
}

