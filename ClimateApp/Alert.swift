//
//  Alert.swift
//  ClimateApp
//
//  Created by Talari Praveen kumar on 05/01/25.
//

import Foundation
import UIKit
final class Alert {
    
    public enum Action {
        typealias Handler = (UIAlertAction) -> Void
        
        case `default`(String?, Handler?)
        case cancel(String?, Handler?)
        case destructive(String?, Handler?)
        
        init(title: String?) {
            self = .default(title, nil)
        }
        
        var title: String? {
            switch self {
            case .default(let title, _): return title
            case .destructive(let title, _): return title
            case .cancel(let title, _): return title
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .default: return .default
            case .destructive: return .destructive
            case .cancel: return .cancel
            }
        }
        
        var handler: Handler? {
            switch self {
            case .default(_, let handler), .cancel(_, let handler), .destructive(_, let handler):
                return handler
            }
        }
    }
    
    private init() {}
    
    @discardableResult
    static func make(with title: String? = nil, description: String? = nil) -> UIAlertController {
        return UIAlertController(title: title, message: description, preferredStyle: .alert)
    }
    //Bundle.main.displayName
    @discardableResult
    static func makeWithAppNameTitle(and description: String? = nil, title: String? = "Alert") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
    
        return alertController
    }
}
extension UIAlertController {
    
    func action(_ action: Alert.Action, isPreferred: Bool = false) -> Self {
        let alertAction = UIAlertAction(title: action.title, style: action.style, handler: action.handler)
        self.addAction(alertAction)
        if isPreferred {
            self.preferredAction = alertAction
        }
        return self
    }
    
    func okAction(isPreferred: Bool = true) -> Self {
        return action(.default("Ok", nil), isPreferred: isPreferred)
    }
    
    func show(on viewController: UIViewController, completion: (() -> Void)? = nil) {
    
        viewController.present(self, animated: true, completion: completion)
    }
}
