//
//  Proxy.swift
//  MemoryManagement
//
//  Created by 谢佳培 on 2021/1/19.
//

import UIKit

class Proxy: NSObject
{
    // target要实现协议里面的isProxy方法
    weak var target: NSObjectProtocol?
    // 调用的方法
    var selector: Selector?
    // 创建计时器
    var timer: Timer? = nil
    
    func scheduledTimer(timeInterval interval: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool)
    {
        // 在Proxy里创建计时器，计时器的target为self（Proxy）
        self.timer = Timer.init(timeInterval: interval, target: self, selector: aSelector, userInfo: userInfo, repeats: yesOrNo)
        RunLoop.current.add(self.timer!, forMode: .common)
        
        // 将外界传入的aTarget赋给Proxy中的target
        self.target = aTarget as? NSObjectProtocol
        self.selector = aSelector

        // self.target虽然是Proxy中的target，但其实是外界传入的aTarget
        // 所以如果外界的Target对象能够响应selector方法则可以调用，否则直接返回
        guard self.target?.responds(to: self.selector) == true else
        {
            return
        }
        
        // 将外部的selector和Proxy里面的#selector实现进行交换
        // 计时器本来应该调用外界的selector(timerFire)，但是经过runtime的方法实现交换之后调用了Proxy里面的proxyTimerFire
        let method = class_getInstanceMethod(self.classForCoder, #selector(proxyTimerFire))
        class_replaceMethod(self.classForCoder, self.selector!, method_getImplementation(method!), method_getTypeEncoding(method!))
    }
    
    @objc fileprivate func proxyTimerFire()
    {
        // 当外界传入的aTarget为空的时候将计时器销毁掉，存在的时候就调用外界的selector(timerFire)
        if self.target != nil
        {
            self.target!.perform(self.selector)
        }
        else
        {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    // 针对NSSelectorFromString找不到Selector导致奔溃问题的特殊处理
    override func forwardingTarget(for aSelector: Selector!) -> Any?
    {
        // 找到selector就正常响应，否则给出错误提示并可以进行处理（比如消息二次转发或者添加方法）
        if self.target?.responds(to: self.selector) == true
        {
            return self.target
        }
        else
        {
            print("老大，老大，你不要为难我呀，我不想浪费时间给你填坑呀！")
            return super.forwardingTarget(for: aSelector)
        }
    }
    
    deinit
    {
        print("\(self) 销毁了")
    }

}


 
 

