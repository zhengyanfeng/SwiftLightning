//
//  WalletMainInteractor.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-20.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol WalletMainBusinessLogic {
  func updateBalances(request: WalletMain.UpdateBalances.Request)
}

protocol WalletMainDataStore { }


class WalletMainInteractor: WalletMainBusinessLogic, WalletMainDataStore {
  
  var presenter: WalletMainPresentationLogic?
  
  // MARK: Update Balances
  
  func updateBalances(request: WalletMain.UpdateBalances.Request) {
    
    LNServices.walletBalance() { (walletResponder) in
      do {
        let onChainBalance = try walletResponder()
        let onChainBitcoin = Bitcoin(inSatoshi: onChainBalance.confirmed)
        
        LNServices.channelBalance() { (channelResponder) in
          do {
            let channelBalance = try channelResponder()
            let channelBitcoin = Bitcoin(inSatoshi: channelBalance)
            
            let response = WalletMain.UpdateBalances.Response(onChainBalance: onChainBitcoin, channelBalance: channelBitcoin)
            self.presenter?.presentUpdatedBalances(response: response)

          } catch {
            let response = WalletMain.UpdateBalances.Response(onChainBalance: onChainBitcoin, channelBalance: nil)
            self.presenter?.presentUpdatedBalances(response: response)
          }
        }

      } catch {
        let response = WalletMain.UpdateBalances.Response(onChainBalance: nil, channelBalance: nil)
        self.presenter?.presentUpdatedBalances(response: response)
      }
    }

  }
}
