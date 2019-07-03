//
//  NotificationSoundPickerPresenter.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class NotificationSoundPickerPresenter: NotificationSoundPickerViewDelegate {

    weak var view: NotificationSoundPickerView?
    var router: NotificationSoundPickerRouter
    var interactor: NotificationSoundPickerInteractor

    private let userPreference: UserPreferencesProtocol
    
    public init(view: NotificationSoundPickerView,
                router: NotificationSoundPickerRouter,
                interactor: NotificationSoundPickerInteractor,
                userPreference: UserPreferencesProtocol) {
        self.router = router
        self.interactor = interactor
        
        self.userPreference = userPreference
        
        self.interactor.delegate = self
        
        self.view = view
        if let view = self.view {
            view.delegate = self
        }
    }

    public func onViewWillAppear() {
        reload()
    }
    
    public func onSelect(at index: IndexPath) {
        guard let view = self.view else { return }
        
        if let previousIndex = view.viewModel.index({ $0.selected }) {
            view.viewModel[previousIndex].selected = false
            view.reload(at: previousIndex)
        }
        
        view.viewModel[index].selected = true
        view.reload(at: index)
        
        let newSound = view.viewModel[index].sound
        userPreference.reminderSound = newSound.name
        interactor.selectAndPlay(newSound)
    }
    
    private func display(_ viewModel: NotificationSoundPickerListViewModel) {
        view?.display(viewModel)
    }

    private func produceViewModel() -> NotificationSoundPickerListViewModel {
        return .init(sections: produceSections())
    }

    private func produceSections() -> [NotificationSoundPickerSectionViewModel] {
        return [
            .init(cells: produceDefaultSoundCell()),
            .init(cells: produceCustomSoundCells())
        ]
    }
    
    private func produceCustomSoundCells() -> [NotificationSoundPickerViewModel] {
        let selectedSound = userPreference.reminderSound
        return interactor.allSound().map { .init(sound: $0, selected: selectedSound.lowercased() == $0.name.lowercased()) }
    }
    
    private func produceDefaultSoundCell() -> [NotificationSoundPickerViewModel] {
        return [
            .init(sound: .init(name: "Default", fileName: "Default"),
                     selected: userPreference.reminderSound == "default")
        ]
    }
    
    private func reload() {
        let viewModel = produceViewModel()
        display(viewModel)
    }
}

extension NotificationSoundPickerPresenter: NotificationSoundPickerInteractorOutput {

}
