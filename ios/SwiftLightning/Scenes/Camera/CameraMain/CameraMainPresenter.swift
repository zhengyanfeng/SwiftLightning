//
//  CameraMainPresenter.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-05-02.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CameraMainPresentationLogic {
  func presentUpdate(response: CameraMain.Update.Response)
}

class CameraMainPresenter: CameraMainPresentationLogic {
  
  weak var viewController: CameraMainDisplayLogic?
  
  func presentUpdate(response: CameraMain.Update.Response) {
    var labelText: String
    
    switch response.cameraMode {
    case .payment:
      labelText = "Please scan a QR code containing a Bitcoin \naddress or a Lightning payment request"
    case .channel:
      labelText = "Please scan a QR code containing \nLightning peer Node info"
    }
    
    var viewModel: CameraMain.Update.ViewModel
    
    guard let valid = response.addressValid else {
      viewModel = CameraMain.Update.ViewModel(labelText: labelText,
                                              scanFrameColor: UIColor.white,
                                              validAddress: nil)
      viewController?.displayUpdate(viewModel: viewModel)
      
      let errorVM = CameraMain.Update.ErrorVM(errTitle: "QR Decode Error",
                                          errLabel: "Problem decoding detected QR. Please restart app and try again")
      viewController?.displayUpdateError(viewModel: errorVM)
      return
    }
    
    if let address = response.address {
      if valid {
        viewModel = CameraMain.Update.ViewModel(labelText: labelText,
                                                    scanFrameColor: UIColor.medAquamarine,
                                                    validAddress: address)
      } else {
        viewModel = CameraMain.Update.ViewModel(labelText: labelText,
                                                    scanFrameColor: UIColor.jellyBeanRed,
                                                    validAddress: nil)
      }
    } else {
      viewModel = CameraMain.Update.ViewModel(labelText: labelText,
                                                  scanFrameColor: UIColor.white,
                                                  validAddress: nil)
    }
    
    viewController?.displayUpdate(viewModel: viewModel)
  }
}