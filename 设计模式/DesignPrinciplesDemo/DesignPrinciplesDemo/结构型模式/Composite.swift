//
//  Composite.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit

class Composite: NSObject
{
    var subComposites: NSMutableArray = {NSMutableArray()}()
    var parentComposite: Composite?
    
    func addComposite(comp: Composite)
    {
        subComposites.add(comp)
        comp.parentComposite = self
    }

    func removeCompositeAtIndex(index:Int)
    {
        subComposites.remove(index)
    }

    func removeComposite(comp: Composite)
    {
        subComposites.remove(comp)
    }

    func removeFromParent()
    {
        if (self.parentComposite != nil)
        {
            self.parentComposite?.removeComposite(comp: self)
        }
    }
}
