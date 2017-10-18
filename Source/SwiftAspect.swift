//
//  SwiftAspect.swift
//  Aspect-Swift
//
//  Created by zhu zhe on 2017/10/18.
//  Copyright © 2017年 zhu zhe. All rights reserved.
//

import Foundation
import Aspects

public protocol IHook {
    func hook()
}

public enum Position:UInt {
    case after
    case instead
    case before
    
    func options() -> AspectOptions {
        let opt:AspectOptions
        switch self {
        case .after:
            opt = AspectOptions.positionAfter
        case .instead:
            opt = AspectOptions.positionInstead
        case .before:
            opt = AspectOptions.positionBefore
        }
        return opt
    }
}

extension AspectOptions {
    public static var positionAfter: AspectOptions {
        return AspectOptions.init(rawValue: 0)
    }
}

extension NSObject{
    
//    @discardableResult
//    open class func swift_hook(_ selector:Selector, options:AspectOptions, block:@escaping ((AspectInfo) -> Void)) -> AspectToken {
//        let wrappedBlock:@convention(block) (AspectInfo)-> Void = { aspectInfo in
//            block(aspectInfo)
//        }
//        let wrappedObject: AnyObject = unsafeBitCast(wrappedBlock, to: AnyObject.self)
//        
//        return try! aspect_hook(selector, with: options, usingBlock: wrappedObject)
//    }
    
    @discardableResult
    open func swift_hook(_ selector:Selector, position:Position, block:@escaping ((AspectInfo) -> Void)) -> AspectToken {
        let wrappedBlock:@convention(block) (AspectInfo)-> Void = { aspectInfo in
            block(aspectInfo)
        }
        let wrappedObject: AnyObject = unsafeBitCast(wrappedBlock, to: AnyObject.self)
        return try! self.aspect_hook(selector, with: position.options(), usingBlock: wrappedObject)
    }
}

open class HookObject: NSObject {
    
    override init() {
        super.init()
        if let hook = self as? IHook {
            hook.hook()
        }
    }
    
}

open class HookViewController: NSViewController {
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        if let hook = self as? IHook {
            hook.hook()
        }
    }
}
