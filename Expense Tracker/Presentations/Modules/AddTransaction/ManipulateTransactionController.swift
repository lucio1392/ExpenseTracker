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
    @IBOutlet fileprivate weak var saveTransactionButton: UIButton!
    @IBOutlet fileprivate weak var actionNumberCollectionView: UICollectionView!
    
    @IBOutlet fileprivate weak var titleTransactionTextField: UITextField!
    @IBOutlet fileprivate weak var amountTransactionLabel: UILabel!
    
    
    var viewModel: ManipulateTransactionViewModelType!
    
    private let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindViewModel()
        configUI()
    }
    
    fileprivate func configUI() {
        configActionNumberCollectionView()
    }
    
    fileprivate func configActionNumberCollectionView() {
        actionNumberCollectionView.register(UINib(nibName: InputNumberActionCollectionCell.reuseID, bundle: nil),
                                            forCellWithReuseIdentifier: InputNumberActionCollectionCell.reuseID)
        actionNumberCollectionView.isScrollEnabled = false
        if let layout = actionNumberCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = actionNumberCollectionView.bounds.width / 3
            let height = actionNumberCollectionView.bounds.height / 4
            layout.itemSize = CGSize(width: width, height: height)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .vertical
        }
        
    }

    fileprivate func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
//        outputs
        
        outputs
            .actionNumber
            .bind(to: actionNumberCollectionView.rx.items(cellIdentifier: InputNumberActionCollectionCell.reuseID, cellType: InputNumberActionCollectionCell.self)) { index, item, cell in
            cell.bind(item)
        }
            .disposed(by: disposedBag)
        
        outputs
            .amountTransaction
            .bind(to: amountTransactionLabel.rx.text)
            .disposed(by: disposedBag)
        
        outputs
            .titleTransaction
            .bind(to: titleTransactionTextField.rx.text)
            .disposed(by: disposedBag)
        
        outputs
            .trackError
            .flatMapLatest { [weak self] messageError -> Observable<Int> in
                
                guard let self = self else {
                    return .empty()
                }
                
                return self.showAlert(title: "Error",
                               message: messageError,
                               style: .alert,
                               actions: [AlertAction(title: "OK", style: .cancel)])
            }
            .subscribe()
            .disposed(by: disposedBag)
        
        
//        inputs
        
        saveTransactionButton
            .rx
            .tap
            .map { [weak self] in
                let amount = self?.amountTransactionLabel.text ?? "0"
                let title = self?.titleTransactionTextField.text ?? "No Title"
                return (amount, title)
            }
            .bind(to: inputs.onUpdateTransaction)
            .disposed(by: disposedBag)

        cancelButton
            .rx
            .tap
            .bind(to: inputs.onCancelManipulateTransaction)
            .disposed(by: disposedBag)
                
        actionNumberCollectionView
            .rx
            .modelSelected(InputNumberActionCellViewModel.self)
            .map { [weak self] inputAction in
                (inputAction.actionNumber, self?.amountTransactionLabel.text ?? "0")
            }
            .bind(to: inputs.onUpdateTransactionAmount)
            .disposed(by: disposedBag)
    
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    deinit {
        print("Deinit ViewController")
    }
}
