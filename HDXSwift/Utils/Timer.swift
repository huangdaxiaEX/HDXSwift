//
//  Timer.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/19.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import Foundation

class Timer {
    private let timerSource: dispatch_source_t
    init(interval: NSTimeInterval, _repeat: Bool = false, queue: dispatch_queue_t, block: dispatch_block_t) {
        timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        let intervalUInt64 = UInt64(max(0, interval) * 1000000000)
        dispatch_source_set_timer(timerSource, dispatch_time(DISPATCH_TIME_NOW, Int64(intervalUInt64)), _repeat ? intervalUInt64: DISPATCH_TIME_FOREVER, 0)
        dispatch_source_set_event_handler(timerSource) { 
            block()
            if !_repeat {
                self.cancel()
            }
        }
         dispatch_resume(timerSource)
    }
    
    func cancel() {
        dispatch_source_cancel(timerSource)
    }
    
}

extension Timer {
    class func after(interval: NSTimeInterval, queue: dispatch_queue_t = dispatch_get_main_queue(), block: dispatch_block_t) -> Timer {
        return Timer(interval: interval, queue: queue, block: block)
    }
    
    class func every(interval: NSTimeInterval, queue: dispatch_queue_t = dispatch_get_main_queue(), block: dispatch_block_t) -> Timer {
        return Timer(interval: interval, _repeat: true, queue: queue, block: block)
    }
    
}
