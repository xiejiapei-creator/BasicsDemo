//
//  ViewController.swift
//  MemoryManagement
//
//  Created by 谢佳培 on 2021/1/20.
//

import UIKit

class ViewController: UIViewController
{
    var timer: Timer?
    let proxy: Proxy = Proxy()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 中介者模式
        //timerCircularReference()
        proxySolveCircularReference()
    }

    // MARK: 中介者模式
    // 使用Timer时的循环引用问题
    func timerCircularReference()
    {
        //self.timer = Timer.init(timeInterval: 1, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
        
        self.timer = Timer.init(timeInterval: 1, repeats: true, block:
        { (timer) in
            print("火箭🚀发射 \(timer)")
        })
        
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    
    // 使用Proxy中介者解决Timer的循环引用问题
    func proxySolveCircularReference()
    {
        let selector = NSSelectorFromString("timerFire")
        self.proxy.scheduledTimer(timeInterval: 1, target: self, selector: selector, userInfo: nil, repeats: true)
    }

    @objc func timerFire()
    {
        print("火箭🚀发射")
    }
    
    deinit
    {
        print("\(self) 界面销毁了")
    }
    
}







