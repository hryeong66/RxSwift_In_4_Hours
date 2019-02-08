//
//  MemberViewModel.swift
//  RxViewControllerExample
//
//  Created by iamchiwon on 09/02/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import CWUtils
import Foundation
import RxSwift
import SwiftyJSON

struct LikableMember {
    let member: Member
    let liked: Bool
}

class MemberViewModel {
    let members = BehaviorSubject<[LikableMember]>(value: [])

    func fetch() {
        let url = "https://my.api.mockaroo.com/example_members.json?key=44ce18f0".url()
        _ = Observable.just(url)
            .map { try Data(contentsOf: $0) }
            .map { try JSON(data: $0) }
            .map { json in
                if let error = json["error"].string {
                    throw NSError(domain: error, code: 500, userInfo: nil)
                }

                return json.arrayValue
                    .map { it -> Member? in it.dictionaryObject?.decode() }
                    .filter { $0 != nil }
                    .map { $0! }
                    .map { LikableMember(member: $0, liked: false) }
            }
            .take(1)
            .catchError { error in
                ELog(error)
                return Observable.empty()
            }
            .bind(to: members)
    }

    func update(_ member: LikableMember) {
        do {
            let updated = try members.value().map { it -> LikableMember in
                guard it.member.id == member.member.id else { return it }
                return member
            }
            members.onNext(updated)

        } catch let error {
            ELog(error)
        }
    }

    func like(_ id: Int) {
        updateLiked(id, to: true)
    }

    func unlike(_ id: Int) {
        updateLiked(id, to: false)
    }

    private func updateLiked(_ id: Int, to liked: Bool) {
        do {
            let updated = try members.value().map { it -> LikableMember in
                guard it.member.id == id else { return it }
                return LikableMember(member: it.member, liked: liked)
            }
            members.onNext(updated)

        } catch let error {
            ELog(error)
        }
    }
}
