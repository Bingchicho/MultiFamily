//
//  DefaultUserProfileStore.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

protocol UserAttributeStore {
    var currentUser: UserAttribute? { get }
    func save(_ user: UserAttribute)
    func clear()
}

final class DefaultUserAttributeStore: UserAttributeStore {

    private(set) var currentUser: UserAttribute?

    func save(_ user: UserAttribute) {
        currentUser = user
    }

    func clear() {
        currentUser = nil
    }
}
