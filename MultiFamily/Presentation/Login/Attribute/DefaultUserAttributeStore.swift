//
//  DefaultUserProfileStore.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

protocol UserAttributeStore {
    var currentUser: UserAttribute? { get }
    var currentEmail: String? { get }
    func save(_ user: UserAttribute, email: String)
    func clear()
}

final class DefaultUserAttributeStore: UserAttributeStore {
    
    static let shared = DefaultUserAttributeStore()

    private(set) var currentUser: UserAttribute?
    private(set) var currentEmail: String?

    func save(_ user: UserAttribute, email: String) {
        currentUser = user
        currentEmail = email
    }

    func clear() {
        currentUser = nil
        currentEmail = nil
    }
}
