//
//  SettingsMainViewController.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-05-11.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SettingsMainDisplayLogic: class {

}

class SettingsMainViewController: SLViewController, SettingsMainDisplayLogic {
  var interactor: SettingsMainBusinessLogic?
  var router: (NSObjectProtocol & SettingsMainRoutingLogic & SettingsMainDataPassing)?

  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = SettingsMainInteractor()
    let presenter = SettingsMainPresenter()
    let router = SettingsMainRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  // MARK: Route to Specific Settings
  
  @IBAction func lndDebugLevelTapped(_ sender: UITapGestureRecognizer) {
    router?.routeToLndDebugLevel()
  }
  
  @IBAction func logConsoleTapped(_ sender: UITapGestureRecognizer) {
    router?.routeToLogConsole()
  }
  
  
  // MARK: Close Cross Tapped
  
  @IBAction func closeCrossTapped(_ sender: UIBarButtonItem) {
    router?.routeToWalletMain()
  }
  
}
