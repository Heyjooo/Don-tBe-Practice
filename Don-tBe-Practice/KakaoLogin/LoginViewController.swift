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
    
    private var cancellables: Set<AnyCancellable> = []

    private let loginViewModel: LoginViewModelIO
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakaoLoginButton"), for: .normal)
        button.addTarget(self, action: #selector(didTappedLoginButton), for: .touchUpInside)
        return button
    }()
    
    init(loginViewModel: LoginViewModelIO) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setLayout()
    }
    
    private func bindViewModel() {
        // ViewModel의 loginPublisher를 구독하여 로그인 성공 및 실패 시 처리
        loginViewModel.loginPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Login success")
                case .failure(let error):
                    print("Login error: \(error.localizedDescription)")
                }
            }, receiveValue: {})
            .store(in: &cancellables)
        
        // ViewModel의 userInfoPublisher를 구독하여 회원 정보 처리
        loginViewModel.userInfoPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("User info error: \(error.localizedDescription)")
                }
            }, receiveValue: { userInfo in
                // 회원 정보 처리
                print("Received user info: \(userInfo)")
            })
            .store(in: &cancellables)
    }
    
    private func setLayout() {
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(65)
        }
    }
    
    @objc
    private func didTappedLoginButton() {
        loginViewModel.didTappedLoginButton()
    }
}
