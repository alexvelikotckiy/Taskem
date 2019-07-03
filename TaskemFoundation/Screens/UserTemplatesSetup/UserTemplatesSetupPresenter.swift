//
//  UserTemplatesSetupPresenter.swift
//  Taskem
//
//  Created by Wilson on 29/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class UserTemplatesSetupPresenter: UserTemplatesSetupViewDelegate {
    
    public weak var view: UserTemplatesSetupView?
    public var router: UserTemplatesSetupRouter
    public var interactor: UserTemplatesSetupInteractor
    
    public var onboardingSettings: OnboardingSettings

    public init(
        view: UserTemplatesSetupView,
        router: UserTemplatesSetupRouter,
        interactor: UserTemplatesSetupInteractor,
        onboardingSettings: OnboardingSettings
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.onboardingSettings = onboardingSettings
        //
        self.interactor.delegate = self
        self.view?.delegate = self
    }
    
    private var viewModel: UserTemplatesSetupListViewModel {
        get { return view?.viewModel ?? .init()}
        set { view?.viewModel = newValue }
    }
    
    private func produce(_ values: [PredefinedProject]) -> UserTemplatesSetupListViewModel {
        return .init(cells: produce(values))
    }

    private func produce(_ values: [PredefinedProject]) -> [UserTemplatesSetupViewModel] {
        return values.map {
            .init(
                template: $0,
                isSelected: $0.group.isDefault,
                isSelectable: !$0.group.isDefault
            )
        }.sorted(by: sortPredicate)
    }
    
    private func sortPredicate(_ lhs: UserTemplatesSetupViewModel, _ rhs: UserTemplatesSetupViewModel) -> Bool {
        if lhs.isDefault {
            return true
        } else {
            return false
        }
    }
    
    public func onViewWillAppear() {
        let templates = interactor.getTemplates()
        view?.display(produce(templates))
    }

    public func onTouchContinue() {
        onboardingSettings.onboardingDefaultDataWasChoose = true
        let selectedTemplates = viewModel.cells.filter { $0.isSelected }.map { $0.template }
        interactor.setupTemplates(selectedTemplates)
    }

    public func onSelectCell(at index: IndexPath) {
        guard viewModel.cell(for: index.row).isSelectable else { return }
        viewModel.cells[index.row].isSelected.toogle()
    }

    public func onDeselectCell(at index: IndexPath) {
        guard viewModel.cell(for: index.row).isSelectable else { return }
        viewModel.cells[index.row].isSelected.toogle()
    }
}

extension UserTemplatesSetupPresenter: UserTemplatesSetupInteractorOutput {
    public func usertemplatessetupInteractorDidAddTemplates(_ interactor: UserTemplatesSetupInteractor) {
        onboardingSettings.onboardingDefaultDataWasChoose = true
        router.dismiss()
    }
}
