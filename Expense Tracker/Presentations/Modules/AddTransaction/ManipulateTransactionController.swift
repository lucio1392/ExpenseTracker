//
//  AddTransactionController.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import UIKit
import RxSwift

class ManipulateTransactionController: UIViewController {

    
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    
    var viewModel: ManipulateTransactionViewModelType!
    
    private let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindViewModel()
    }

    fileprivate func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
//        inputs
        
        cancelButton
            .rx
            .tap
            .bind(to: inputs.onCancelManipulateTransaction)
            .disposed(by: disposedBag)
        
        
    }
}
