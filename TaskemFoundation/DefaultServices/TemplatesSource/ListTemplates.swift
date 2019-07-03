//
//  ListTemplates.swift
//  TaskemFoundation
//
//  Created by Wilson on 10.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public extension PredefinedProject {
    static var inbox: PredefinedProject {
        return .init(
            name: "Inbox",
            icon: Images.Lists.icEmailinbox,
            color: Color.TaskemLists.greyDark,
            isDefault: true
        )
    }
    
    static var travel: PredefinedProject {
        return .init(
            name: "Travel",
            icon: Images.Lists.icAirTransport,
            color: Color.TaskemLists.blueDark
        )
    }
    
    static var work: PredefinedProject {
        return .init(
            name: "Work",
            icon: Images.Lists.icBriefcase,
            color: Color.TaskemLists.turquoise
        )
    }
    
    static var study: PredefinedProject {
        return .init(
            name: "Study",
            icon: Images.Lists.icCollegeGraduation,
            color: Color.TaskemLists.redDeep
        )
    }
    
    static var food: PredefinedProject {
        return .init(
            name: "Glocery",
            icon: Images.Lists.icAppleBlackSilhouetteWithALeaf,
            color: Color.TaskemLists.green
        )
    }
    
    static var health: PredefinedProject {
        return .init(
            name: "Health",
            icon: Images.Lists.icHeartbeat,
            color: Color.TaskemLists.orangeLight
        )
    }
    
    static var birthdays: PredefinedProject {
        return .init(
            name: "Birthdays",
            icon: Images.Lists.icGift,
            color: Color.TaskemLists.yellowLight
        )
    }
    
    static var books: PredefinedProject {
        return .init(
            name: "Books",
            icon: Images.Lists.icOpenBook,
            color: Color.TaskemLists.grey
        )
    }
    
    static var movies: PredefinedProject {
        return .init(
            name: "Movies",
            icon: Images.Lists.icVideoCamera,
            color: Color.TaskemLists.blueDeep
        )
    }
    
    static var habits: PredefinedProject {
        return .init(
            name: "Habits",
            icon: Images.Lists.icBuddhistYogaPose,
            color: Color.TaskemLists.pink
        )
    }
    
    static var shopping: PredefinedProject {
        return .init(
            name: "Shopping",
            icon: Images.Lists.icShoppingCart,
            color: Color.TaskemLists.turquoiseLight
        )
    }

    
    static var computers: PredefinedProject {
        return .init(
            name: "Computers",
            icon: Images.Lists.icDesktopMonitor,
            color: Color.TaskemLists.blueDark
        )
    }
    
    static var workout: PredefinedProject {
        return .init(
            name: "Workout",
            icon: Images.Lists.icDumbbellVariantOutline,
            color: Color.TaskemLists.purpleDeep
        )
    }
    
    static var music: PredefinedProject {
        return .init(
            name: "Music",
            icon: Images.Lists.icMusicPlayer,
            color: Color.TaskemLists.redDeep
        )
    }
    
    static var water: PredefinedProject {
        return .init(
            name: "Water",
            icon: Images.Lists.icDropletOfWater,
            color: Color.TaskemLists.blue
        )
    }
    
    static var calendar: PredefinedProject {
        return .init(
            name: "Calendar",
            icon: Images.Lists.icCalendarList,
            color: Color.TaskemLists.orange
        )
    }
    
    static var medicine: PredefinedProject {
        return .init(
            name: "Medicine",
            icon: Images.Lists.icDrugs,
            color: Color.TaskemLists.yellow
        )
    }
    
    static var sport: PredefinedProject {
        return .init(
            name: "Sport",
            icon: Images.Lists.icRunning,
            color: Color.TaskemLists.purple
        )
    }
    
    static var games: PredefinedProject {
        return .init(
            name: "Gaming",
            icon: Images.Lists.icJoystick,
            color: Color.TaskemLists.purpleLight
        )
    }
}

private extension PredefinedProject {
    init(name: String, icon: ImageAsset, color: UIColor, isDefault: Bool = false) {
        self.init(
            group: .init(
                id: .auto(),
                name: name,
                isDefault: isDefault,
                creationDate: DateProvider.current.now,
                icon: .init(icon),
                color: .init(color)
            ),
            tasks: []
        )
    }
}
