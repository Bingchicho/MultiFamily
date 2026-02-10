//
//  ProfileViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

@MainActor
final class ProfileViewModel {
    
    private let useCase: ProfileUseCase
    
    var onStateChange: ((ProfileViewState) -> Void)?
    var onProfileUpdated: (() -> Void)?
    
    private(set) var state: ProfileViewState = .idle {
        didSet { onStateChange?(state) }
    }
    
    var onRoute: ((ProfileRoute) -> Void)?
    
    private(set) var name: String = "-"
    private(set) var email: String = "-"
    private(set) var phone: String = "-"
    
    init(useCase: ProfileUseCase) {
        self.useCase = useCase
    }
    
    
    func load() {

        name = AppAssembler.userAttributeStore.currentUser?.username ?? "-"
        email = AppAssembler.userAttributeStore.currentEmail ?? "-"
        phone = AppAssembler.userAttributeStore.currentUser?.phone ?? "-"
        state = .idle
    }
    
    func updateName(_ name: String) {
        
        Task {
            state = .loading
            
            let result = await useCase.changeName(email: email, name: name)
            
            handle(result)
        }
    }
    
    func changePassword(
        oldPassword: String,
        newPassword: String
    ) {
        
        Task {
            
            state = .loading
            
            let result = await useCase.changePassword(email: email, oldPassword: oldPassword, password: newPassword)
            
            handle(result)
        }
    }
    
    func changeMobile(
        _ mobile: String
    ) {
        
        Task {
            
            state = .loading
            
            let result = await useCase.changeMobile(email: email, mobile: mobile)
            
            handle(result)
        }
    }
    
    func logout() {
        
        Task {
            
            state = .loading
            
            let result = await useCase.logout()
            
            switch result {
                
            case .success:
                state = .idle
                AppAssembler.userAttributeStore.clear()
                AppAssembler.siteSelectionStore.clear()
                AppAssembler.tokenStore.clear()
                
                onRoute?(.logout)
                
            case .failure(let message):
                
                onStateChange?(.error(message))
            }
            
          
        }
    
    }
    
    func deleteAccount() {
        
        Task {
            
            state = .loading
            
            let result = await useCase.deleteAccount()
            
            switch result {
                
            case .success:
                state = .idle
                AppAssembler.userAttributeStore.clear()
                AppAssembler.siteSelectionStore.clear()
                AppAssembler.tokenStore.clear()
                
                onRoute?(.logout)
                
            case .failure(let message):
                
                onStateChange?(.error(message))
            }
            
          
        }
    
    }
    
    private func handle(_ result: UpdateProfileResult) {
        
        switch result {
            
        case .success:
            state = .idle
            onProfileUpdated?()
            
        case .failure(let message):
            
            onStateChange?(.error(message))
        }
    }
}
