//
//  TransactionDetailsViewController.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-05-08.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TransactionDetailsDisplayLogic: class {
  func displayRefresh(viewModel: TransactionDetails.Refresh.ViewModel)
  func displayError(viewModel: TransactionDetails.ErrorVM) 
}


final class TransactionDetailsViewController: UIViewController, TransactionDetailsDisplayLogic {
  var interactor: TransactionDetailsBusinessLogic?
  var router: (NSObjectProtocol & TransactionDetailsRoutingLogic & TransactionDetailsDataPassing)?

  
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
    let interactor = TransactionDetailsInteractor()
    let presenter = TransactionDetailsPresenter()
    let router = TransactionDetailsRouter()
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
    refresh()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Re-subscribe to events
    interactor?.subscribeEvents()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    txHashView.copyDialogSuperview = view
    amountView.copyDialogSuperview = view
    feesView.copyDialogSuperview = view
    dateView.copyDialogSuperview = view
    confirmationsView.copyDialogSuperview = view
    blockHeightView.copyDialogSuperview = view
    hashPreimageView.copyDialogSuperview = view
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  
    // Unsubscribe from events
    interactor?.unsubscribeEvents()
  }
  
  
  // MARK: Refresh
  
  @IBOutlet private weak var stackView: UIStackView!
  @IBOutlet private weak var bottomSpacer: UIView!
  
  @IBOutlet private weak var headerView: SLFormHeaderView!
  @IBOutlet private weak var txHashView: SLFormLabelView!
  @IBOutlet private weak var amountView: SLFormCompactView!
  @IBOutlet private weak var feesView: SLFormCompactView!
  @IBOutlet private weak var dateView: SLFormLabelView!
  
  @IBOutlet private weak var confirmationsSpacer: UIView!
  @IBOutlet private weak var confirmationsView: SLFormCompactView!
  @IBOutlet private weak var blockHeightSpacer: UIView!
  @IBOutlet private weak var blockHeightView: SLFormCompactView!
  
  @IBOutlet private weak var hashPreimageView: SLFormLabelView!
  @IBOutlet private weak var destPathTitleLabel: SLFormTitleLabel!
  
  
  private var destPathLabels = [SLFormTextLabel]()
  
  private func refresh() {
    let request = TransactionDetails.Refresh.Request()
    interactor?.refresh(request: request)
  }
  
  func displayRefresh(viewModel: TransactionDetails.Refresh.ViewModel) {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.5) {
        switch viewModel.txType {
        case .onChain:
          self.headerView.iconImageView.image = UIImage(named: "ChainColored")
        case .lightning:
          self.headerView.iconImageView.image = UIImage(named: "BoltColored")
        }
        self.headerView.headerLabel.text = viewModel.txHeaderText
        
        self.txHashView.titleLabel.text = viewModel.txHashTitle
        self.txHashView.textLabel.text = viewModel.txHashText
        
        self.amountView.textLabel.text = viewModel.amountText
        self.feesView.textLabel.text = viewModel.feesText
        self.dateView.textLabel.text = viewModel.dateText
        
        if let confirmationsText = viewModel.confirmationsText {
          self.confirmationsSpacer.isHidden = false
          self.confirmationsView.isHidden = false
          self.confirmationsView.textLabel.text = confirmationsText
        } else {
          self.confirmationsSpacer.isHidden = true
          self.confirmationsView.isHidden = true
        }
        
        if let blockHeightText = viewModel.blockHeightText {
          self.blockHeightSpacer.isHidden = false
          self.blockHeightView.isHidden = false
          self.blockHeightView.textLabel.text = blockHeightText
        } else {
          self.blockHeightSpacer.isHidden = true
          self.blockHeightView.isHidden = true
        }
        
        self.hashPreimageView.titleLabel.text = viewModel.hashPreimageTitle
        self.hashPreimageView.textLabel.text = viewModel.hashPreimageText
        
        self.destPathTitleLabel.titleLabel.text = viewModel.destPathTitle
        
        // Remove old views
        for destPath in self.destPathLabels {
          self.stackView.removeArrangedSubview(destPath)
        }
        self.destPathLabels.removeAll(keepingCapacity: true)
        self.stackView.removeArrangedSubview(self.bottomSpacer)
        
        // Add new views
        for destPath in viewModel.destPaths {
          let destPathLabel = SLFormTextLabel()
          destPathLabel.textLabel.text = destPath
          destPathLabel.copyDialogSuperview = self.view
          destPathLabel.setContentCompressionResistancePriority(.required, for: .vertical)
          self.stackView.addArrangedSubview(destPathLabel)
          self.destPathLabels.append(destPathLabel)
        }
        self.stackView.addArrangedSubview(self.bottomSpacer)
      }
    }
  }
  
  
  // MARK: Error Display
  
  func displayError(viewModel: TransactionDetails.ErrorVM) {
    let alertDialog = UIAlertController(title: viewModel.errTitle,
                                        message: viewModel.errMsg, preferredStyle: .alert).addAction(title: "OK", style: .default)
    DispatchQueue.main.async {
      self.present(alertDialog, animated: true, completion: nil)
      // self.activityIndicator.remove()
    }
  }
  
  
  // MARK: Dismiss Tapped
  
  @IBAction private func closeCrossTapped(_ sender: UIBarButtonItem) {
    router?.routeToWalletMain()
  }
}














