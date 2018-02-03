//
//  BFContext.swift
//  BFLCoinManager
//
//  Created by jaeeun on 2018/02/03.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation

struct BFContext {
    
    var markets = [Market]()
    var boards  = [Board]()
    var tickers = [Ticker]()
    var executions = [Dictionary<String, [Execution]>]()
    var boardStates = [Dictionary<String,BoardState>]()
    var healths = [Dictionary<String,Health>]()
    var chats = [Chat]()
}
