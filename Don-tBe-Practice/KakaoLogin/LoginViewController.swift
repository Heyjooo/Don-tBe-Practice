//
//  LoginViewController.swift
//  Don-tBe-Practice
//
//  Created by 변희주 on 1/3/24.
//

import Combine
import UIKit

import SnapKit

final class LoginViewController: UIViewController {
    
    private var cancelBag = CancelBag()
    private let viewModel: LoginViewModel
    private let loginButtonTapped = PassthroughSubject<Void, Never>()
    private lazy var backButtonTapped = self.loginButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakaoLoginButton"), for: .normal)
        return button
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setLayout()
    }
    
    private func bind() {
        let input = LoginViewModel.Input(kakaoButtonTapped: backButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.userInfoPublisher
//            .receive(on: RunLoop.main)
            .sink { userInfo in
                print(userInfo)
            }
            .store(in: self.cancelBag)
    }
    
    private func setLayout() {
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(65)
        }
    }
}

