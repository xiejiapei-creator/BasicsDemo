//
//  DutyHandle.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

class DutyHandle : NSObject
{
    /// 下一个
    var next : DutyHandle?
    
    /// 处理请求操作
    func handleRequest(str:String)
    {
        /// 如果可以则直接处理
        if (self.canDealWithRequest(str: str))
        {
            print(str)
        }
        else
        {
            /// 否则如果有下一个，则下一个进行处理判断
            if ((next) != nil)
            {
                next?.handleRequest(str: str)
            }
        }
    }
    
    /// 判断能否处理请求
    func canDealWithRequest(str:String) -> Bool
    {
        return false
    }
}
