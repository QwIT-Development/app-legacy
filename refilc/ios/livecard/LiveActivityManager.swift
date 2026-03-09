import ActivityKit
import WidgetKit
import Foundation

public struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState
    public struct ContentState: Codable, Hashable {
        var color: String
        var icon: String
        var index: String
        var title: String
        var subtitle: String
        var description: String
        var startDate: Date
        var endDate: Date
        var date: ClosedRange<Date>
        var nextSubject: String
        var nextRoom: String
    }

    public var id = UUID()
}

@available(iOS 16.2, *)
final class LiveActivityManager {
    static let shared = LiveActivityManager()
    var currentActivity: Activity<LiveActivitiesAppAttributes>?

    /// Létrehozza a Live Activity-t pushType: .token-nel.
    /// A completion azonnal meghívódik a létrehozás után (success/fail).
    /// A push token később érkezik a pushTokenUpdates-en keresztül.
    class func create(completion: @escaping (Bool) -> Void) {
        Task {
            // Előző activity-k eltakarítása, hogy ne legyen dupla
            // Flag beállítása, hogy a monitorActivityState ne küldjön dismiss notification-t
            isCleaningUpOldActivities = true
            for activity in Activity<LiveActivitiesAppAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            // Kis várakozás, hogy a state update-ek lefussanak
            try? await Task.sleep(nanoseconds: 200_000_000)
            isCleaningUpOldActivities = false

            do {
                let contentState = LiveActivitiesAppAttributes.ContentState(
                    color: globalLessonData.color,
                    icon: globalLessonData.icon,
                    index: globalLessonData.index,
                    title: globalLessonData.title,
                    subtitle: globalLessonData.subtitle,
                    description: globalLessonData.description,
                    startDate: globalLessonData.startDate,
                    endDate: globalLessonData.endDate,
                    date: globalLessonData.date,
                    nextSubject: globalLessonData.nextSubject,
                    nextRoom: globalLessonData.nextRoom
                )

                let activityContent = ActivityContent(
                    state: contentState,
                    staleDate: globalLessonData.endDate,
                    relevanceScore: 0
                )

                let activity = try Activity<LiveActivitiesAppAttributes>.request(
                    attributes: LiveActivitiesAppAttributes(),
                    content: activityContent,
                    pushType: .token
                )

                activityID = activity.id
                print("Live Activity létrehozva. Azonosító: \(activity.id)")

                // Azonnal visszatérünk — a LA látszik
                completion(true)

                // Dismiss/end figyelése háttérben
                Task { await monitorActivityState(activity: activity) }

                // Push token figyelése háttérben — az első és a rotation is
                // a LiveActivityTokenUpdated notification-ön keresztül megy Flutter felé
                Task {
                    for await tokenData in activity.pushTokenUpdates {
                        let tokenHex = tokenData.map { String(format: "%02x", $0) }.joined()
                        activityPushToken = tokenHex
                        print("Live Activity push token: \(tokenHex)")
                        NotificationCenter.default.post(
                            name: NSNotification.Name("LiveActivityTokenUpdated"),
                            object: tokenHex
                        )
                    }
                }
            } catch {
                print("Hiba történt a Live Activity létrehozásakor: \(error)")
                completion(false)
            }
        }
    }

    /// Activity state figyelése: ha a user dismiss-eli vagy véget ér, értesítjük a Flutter-t.
    private class func monitorActivityState(activity: Activity<LiveActivitiesAppAttributes>) async {
        for await state in activity.activityStateUpdates {
            if state == .dismissed || state == .ended {
                // Ha cleanup közben vagyunk (create() hívta), ne küldjünk dismiss notification-t
                if isCleaningUpOldActivities {
                    print("Live Activity ended during cleanup - ignoring dismiss")
                    break
                }
                print("Live Activity dismissed/ended by user or system")
                activityID = nil
                activityPushToken = nil
                NotificationCenter.default.post(
                    name: NSNotification.Name("LiveActivityDismissed"),
                    object: nil
                )
                // Activity formálisan is leállítjuk ha még fut
                await activity.end(nil, dismissalPolicy: .immediate)
                break
            }
        }
    }

    /// Token rotation figyelése: ha az APNs új tokent ad ki, értesítjük a Flutter oldalt.
    /// MEGJEGYZÉS: Már nem használjuk külön — a create() maga figyeli a pushTokenUpdates-t
    /// és minden tokent (elsőt is, rotation-t is) a LiveActivityTokenUpdated notification-ön küld.

    class func update() {
        Task {
            for activity in Activity<LiveActivitiesAppAttributes>.activities {
                do {
                    let contentState = LiveActivitiesAppAttributes.ContentState(
                        color: globalLessonData.color,
                        icon: globalLessonData.icon,
                        index: globalLessonData.index,
                        title: globalLessonData.title,
                        subtitle: globalLessonData.subtitle,
                        description: globalLessonData.description,
                        startDate: globalLessonData.startDate,
                        endDate: globalLessonData.endDate,
                        date: globalLessonData.date,
                        nextSubject: globalLessonData.nextSubject,
                        nextRoom: globalLessonData.nextRoom
                    )

                    let activityContent = ActivityContent(
                        state: contentState,
                        staleDate: globalLessonData.endDate,
                        relevanceScore: 0
                    )

                    await activity.update(activityContent)
                    activityID = activity.id
                    print("Live Activity frissítve. Azonosító: \(activity.id)")
                } catch {
                    print("Hiba történt a Live Activity frissítésekor: \(error)")
                }
            }
        }
    }

    class func stop() {
        if activityID != "" {
            Task {
                for activity in Activity<LiveActivitiesAppAttributes>.activities {
                    let contentState = LiveActivitiesAppAttributes.ContentState(
                        color: globalLessonData.color,
                        icon: globalLessonData.icon,
                        index: globalLessonData.index,
                        title: globalLessonData.title,
                        subtitle: globalLessonData.subtitle,
                        description: globalLessonData.description,
                        startDate: globalLessonData.startDate,
                        endDate: globalLessonData.endDate,
                        date: globalLessonData.date,
                        nextSubject: globalLessonData.nextSubject,
                        nextRoom: globalLessonData.nextRoom
                    )

                    await activity.end(
                        ActivityContent(state: contentState, staleDate: Date.distantFuture),
                        dismissalPolicy: .immediate
                    )
                }
                activityID = nil
                activityPushToken = nil
                print("Live Activity sikeresen leállítva")
            }
        }
    }

    class func isRunning(_ activityID: String) -> Bool {
        for activity in Activity<LiveActivitiesAppAttributes>.activities {
            if activity.id == activityID {
                return true
            }
        }
        return false
    }
}
