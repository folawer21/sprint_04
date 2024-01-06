import Foundation
import UIKit

protocol AlertPresenterProtocol {
    
    func show(alertModel: AlertModel)
}

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil ){
        self.viewController = viewController
    }
    
    func show (alertModel: AlertModel){
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {  _ in
            alertModel.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
  
