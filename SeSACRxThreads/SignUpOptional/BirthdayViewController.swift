//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    var year = BehaviorSubject(value: 2023)
    var month = BehaviorSubject(value: 11)
    var day = BehaviorSubject(value: 02)
    var isSignButtonEnable = BehaviorSubject(value: false)
    var isSign = BehaviorSubject(value: "")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        isSignButtonEnable.bind(to: nextButton.rx.isEnabled).disposed(by: disposeBag)
        isSign.bind(to: infoLabel.rx.text).disposed(by: disposeBag)
        
        birthDayPicker.rx.date.changed.bind(with: self, onNext: { owner ,day in
            let date = Calendar.current.dateComponents([.year, .month, .day], from: day)
            owner.year.onNext(date.year!)
            owner.month.onNext(date.month!)
            owner.day.onNext(date.day!)
            
            let is17YearsOld = Calendar.current.date(byAdding: .year, value: 17, to: day)! <= Date()
            owner.isSignButtonEnable.onNext(is17YearsOld)
            owner.isSign.onNext(is17YearsOld ? "가입이 가능합니다" : "만 17세 이상만 가입 가능합니다.")
        }).disposed(by: disposeBag)
        
        year.subscribe(with: self) { owner, value in
            owner.yearLabel.text = "\(value)년"
        }.disposed(by: disposeBag)

        month.subscribe(with: self) { owner, value in
            owner.monthLabel.text = "\(value)월"
        }.disposed(by: disposeBag)
        
        day.subscribe(with: self) { owner, value in
            owner.dayLabel.text = "\(value)일"
        }.disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
       print("가입완료")
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
