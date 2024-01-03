//
//  LoginViewModel.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/3/24.
//

import Foundation
import Combine

protocol LoginViewModelInput {
    func didTappedLoginButton()
}

protocol LoginViewModelOutput {
    var loginPublisher: PassthroughSubject<Void, Error> { get set }
}

protocol LoginViewModelIO: LoginViewModelInput & LoginViewModelOutput { }

class LoginViewModel: NSObject, LoginViewModelIO {
    var loginPublisher = PassthroughSubject<Void, Error>()
    
    override init() {
        super.init()
    }
    
    func didTappedLoginButton() {
        <#code#>
    }
}
