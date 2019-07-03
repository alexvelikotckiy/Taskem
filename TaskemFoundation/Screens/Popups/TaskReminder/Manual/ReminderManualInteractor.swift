//
//  ReminderManualInteractor.swift
//  Taskem
//
//  Created by Wilson on 09/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ReminderManualInteractorOutput: class {
    func remindermanualIteractorDidGetRemindPermission(_ interactor: ReminderManualInteractor)
    func remindermanualIteractor(_ interactor: ReminderManualInteractor, didFailGetRemindPermission error: Error?)
    func remindermanualIteractorDidDiniedRemindPermission(_ interactor: ReminderManualInteractor)
}

public protocol ReminderManualInteractor: class {
    var delegate: ReminderManualInteractorOutput? { get set }
    
    func registerRemindPermission()
}

public class ReminderManualDefaultInteractor: ReminderManualInteractor {
    public weak var delegate: ReminderManualInteractorOutput?
    
    public var remindScheduler: RemindScheduleManager

    public init(remindScheduler: RemindScheduleManager) {
        self.remindScheduler = remindScheduler
    }

    public func registerRemindPermission() {
        remindScheduler.getPermissions { [weak self] permissions in
            guard let strongSelf = self else { return }
            switch permissions {
            case .authorized, .provisional:
                strongSelf.delegate?.remindermanualIteractorDidGetRemindPermission(strongSelf)

            case .notDetermined:
                strongSelf.askForPermissions()

            case .denied:
                strongSelf.delegate?.remindermanualIteractorDidDiniedRemindPermission(strongSelf)
                
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
                strongSelf.delegate?.remindermanualIteractorDidGetRemindPermission(strongSelf)

            case .prohibited:
                strongSelf.delegate?.remindermanualIteractorDidDiniedRemindPermission(strongSelf)

            case .failure(let error):
                strongSelf.delegate?.remindermanualIteractor(strongSelf, didFailGetRemindPermission: error)

            }
        }
    }
}
