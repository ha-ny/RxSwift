//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneNumber = BehaviorSubject(value: "010")
    let nextButtonColor = BehaviorSubject(value: UIColor.red)
    let isButtonEnable = BehaviorSubject(value: false)
    let disposeBag = DisposeBag()
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        phoneTextField.rx.text.orEmpty.bind(to: phoneNumber).disposed(by: disposeBag)
        nextButtonColor.bind(to: nextButton.rx.backgroundColor).disposed(by: disposeBag)
        isButtonEnable.bind(to: nextButton.rx.isEnabled).disposed(by: disposeBag)
        phoneNumber.map { $0.formated(by: "###-####-####") }.subscribe(with: self) { owner, value in
            owner.phoneTextField.rx.text.onNext(value)
            owner.nextButtonColor.onNext(value.count == 13 ? .blue : .red)
        }.disposed(by: disposeBag)
        nextButtonColor.map{ $0 == .blue }.subscribe(with: self) { owner, value in
            owner.isButtonEnable.onNext(value)
        }.disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
