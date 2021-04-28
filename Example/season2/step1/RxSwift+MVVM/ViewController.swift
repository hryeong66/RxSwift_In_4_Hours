//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }

    // MARK: SYNC

//    func downloadJson(_ url: String) -> Observable<String?>{
//        //1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
//        //여기있는 Hello, world가 각각 event의 next로 들어올것이다.
//        return Observable.create() { emitter in
//            emitter.onNext("hello")
//            emitter.onNext("world")
//            emitter.onCompleted()
//
//            return Disposables.create()
//        }
//    }
    
    func downloadJson(_ url: String) -> Observable<String?>{
        //1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
        //여기있는 Hello, world가 각각 event의 next로 들어올것이다.
        return Observable.create() { emitter in
            let utl
            
            emitter.onNext("hello")
            emitter.onNext("world")
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)

        let observable = downloadJson(MEMBER_LIST_URL)
        
        
        observable.subscribe{ event in
            
            
        }
        
        let url = URL(string: MEMBER_LIST_URL)!
        let data = try! Data(contentsOf: url)
        let json = String(data: data, encoding: .utf8)
        self.editView.text = json
        
        self.setVisibleWithAnimation(self.activityIndicator, false)
    }
}
