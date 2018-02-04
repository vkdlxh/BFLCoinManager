//
//  ViewController.swift
//  BFLCoinManager
//
//  Created by jaeeun on 2018/01/30.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet var tableView : UITableView?
    
    let requestItems = ["マーケットの一覧",
                        "板情報",
                        "Ticker",
                        "約定履歴",
                        "板の状態",
                        "取引所の状態",
                        "チャット",
                        "Chart",]
    
    let realtimeItems = ["全てのチャンネル",
                         "マーケットチャンネル",
                         "板情報チャンネル",
                         "Tickerチャンネル",
                         "約定チャンネル"]
    
    var realtimeToggleFlags = [false,
                               false,
                               false,
                               false,
                               false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        BFLCoinManager.shared.addObserver(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "request" : "realtime";
    }
}

extension ViewController : UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (section == 0) ? requestItems.count : realtimeItems.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        if (indexPath.section == 0) {
            cell.textLabel?.text = requestItems[indexPath.row]
        }else {
            let flag = realtimeToggleFlags[indexPath.row] ? "ON" : "OFF"
            let menuTitle = "\(realtimeItems[indexPath.row]) \( (flag))"
            cell.textLabel?.text = menuTitle
        }
        
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let menuTitle = (indexPath.section == 0) ? requestItems[indexPath.row] : realtimeItems[indexPath.row];
        print("\(menuTitle) selected.")
        
        let mgr = BFLCoinManager.shared
        
        if (indexPath.section == 0) {
            //Request
            switch indexPath.row {
            case 0:
                BFCoinAPI.requestMarkets({ (markets) in
                    for market in markets {
                        print(market)
                    }
                })
                break
            case 1:
                BFCoinAPI.requestBoard(nil, completion: { (board) in
                    //
                })
                break
            case 2:
                BFCoinAPI.requestTicker(nil, completion: { (ticker) in
                    //
                })
                break
            case 3:
                BFCoinAPI.requestExecutions(nil, before: nil, after: nil, count: nil, completion: { (executions) in
                    //
                })
                break
            case 4:
                BFCoinAPI.requestBoardState(nil, completion: { (boardState) in
                    //
                })
                break
            case 5:
                BFCoinAPI.requestHealth(nil, completion: { (health) in
                    //
                })
                break
            case 6:
                BFCoinAPI.requestChats(Date(), completion: {(chats) in
                    //
                })
                break
            case 7:
                BFCoinAPI.requestCharts("BTC_JPY", completion: { (data) in
                    //
                })
                break
            default: break
                //
            }
        }else if(indexPath.section == 1) {
            //Realtime
            switch indexPath.row {
            case 0:
                if (realtimeToggleFlags[0]) {
                    mgr.realtimeApi.releaseChannelsAll()
                    realtimeToggleFlags[0] = false
                }else {
                    mgr.realtimeApi.registChannelsAll("BTC_JPY")
                    realtimeToggleFlags[0] = true
                }
                
                break
            case 1:
                if (realtimeToggleFlags[1]) {
                    mgr.realtimeApi.releaseMarketChannel("BTC_JPY")
                    realtimeToggleFlags[1] = false
                }else {
                    mgr.realtimeApi.registMarketChannel("BTC_JPY")
                    realtimeToggleFlags[1] = true
                }
                break
            case 2:
                if (realtimeToggleFlags[2]) {
                    mgr.realtimeApi.releaseBoardChannel("BTC_JPY")
                    realtimeToggleFlags[2] = false
                }else {
                    mgr.realtimeApi.registBoardChannel("BTC_JPY")
                    realtimeToggleFlags[2] = true
                }
                break
            case 3:
                if (realtimeToggleFlags[3]) {
                    mgr.realtimeApi.releaseTickerChannel("BTC_JPY")
                    realtimeToggleFlags[3] = false
                }else {
                    mgr.realtimeApi.registTickerChannel("BTC_JPY")
                    realtimeToggleFlags[3] = true
                }
                break
            case 4:
                if (realtimeToggleFlags[4]) {
                    mgr.realtimeApi.releaseExecutionsChannel("BTC_JPY")
                    realtimeToggleFlags[4] = false
                }else {
                    mgr.realtimeApi.registExecutionsChannel("BTC_JPY")
                    realtimeToggleFlags[4] = true
                }
                break
            default: break
                //
            }
            
            tableView.reloadData()
        }
        
        
    }
}

extension ViewController : BFLCoinManagerDataChanged {
    
    func coinDataDidLoad(_ context:BFContext) {
        print("context loaded!!")
        //print(context)
    }
    
    func coinDataChanged(channel: Channel, productCode: String, data: Any) {
        print("context changed!!")
        //print(data)
        
        if channel == Channel.board {
            //
        }else if channel == Channel.ticker {
            
            //Context更新確認
            for ticker in BFLCoinManager.shared.context.tickers {
                if (ticker.productCode == productCode) {
                    print("ticker.bestBid--->\(ticker.bestBid)")
                    break
                }
            }
        }else if channel == Channel.executions {
            
            //!!! BUG: 更新ができてない。
            //Context更新確認
            if  let items = BFLCoinManager.shared.context.executions[productCode] {
                
                if let exeDate = items.first?.exeDate {
                    print("exeDate--->\(exeDate)")
                }
            }
        }
    }
}
