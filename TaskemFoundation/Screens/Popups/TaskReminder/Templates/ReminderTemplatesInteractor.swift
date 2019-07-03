//
//  ReminderTemplatesInteractor.swift
//  Taskem
//
//  Created by Wilson on 13/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ReminderTemplatesInteractorOutput: class {
    func remindertemplatesIteractorDidGetRemindPermission(_ interactor: ReminderTemplatesInteractor)
    func remindertemplatesIteractor(_ interactor: ReminderTemplatesInteractor, didFailGetRemindPermission error: Error?)
    func remindertemplatesIteractorDidDiniedRemindPermission(_ interactor: ReminderTemplatesInteractor)
}

public protocol ReminderTemplatesInteractor: class {
    var delegate: ReminderTemplatesInteractorOutput? { get set }
    
    func registerRemindPermission()
}

public class ReminderTemplatesDefaultInteractor: ReminderTemplatesInteractor {
    public weak var delegate: ReminderTemplatesInteractorOutput?
    
    public var remindScheduler: RemindScheduleManager

    public init(remindScheduler: RemindScheduleManager) {
        self.remindScheduler = remindScheduler
    }

    public func registerRemindPermission() {
        remindScheduler.getPermissions { [weak self] permissions in
            guard let strongSelf = self else { return }
            switch permissions {
            case .authorized, .provisional:
                strongSelf.delegate?.remindertemplatesIteractorDidGetRemindPermission(strongSelf)

            case .notDetermined:
                strongSelf.askForPermissions()

            case .denied:
                strongSelf.delegate?.remindertemplatesIteractorDidDiniedRemindPermission(strongSelf)
                
            @unknown default:
                fatalError()
            }
        }
    }

    private func askForPermissions() {
        remindScheduler.askForPermissions { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .allowed:
                strongSelf.delegate?.remindertemplatesIteractorDidGetRemindPermission(strongSelf)

            case .prohibited:
                strongSelf.delegate?.remindertemplatesIteractorDidDiniedRemindPermission(strongSelf)

            case .failure(let error):
                strongSelf.delegate?.remindertemplatesIteractor(strongSelf, didFailGetRemindPermission: error)

            }
        }
    }
}
