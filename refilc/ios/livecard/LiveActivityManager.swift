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

    /// Létrehozza a Live Activity-t pushType: .token-nel, majd visszaadja az APNs push tokent.
    class func create(completion: @escaping (String?) -> Void) {
        Task {
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

                // Az APNs token aszinkron érkezik – megvárjuk az elsőt
                for await tokenData in activity.pushTokenUpdates {
                    let tokenHex = tokenData.map { String(format: "%02x", $0) }.joined()
                    activityPushToken = tokenHex
                    print("Live Activity push token: \(tokenHex)")
                    completion(tokenHex)
                    // Token rotation figyelése a háttérben
                    Task { await monitorTokenRotation(activity: activity) }
                    break
                }
            } catch {
                print("Hiba történt a Live Activity létrehozásakor: \(error)")
                completion(nil)
            }
        }
    }

    /// Token rotation figyelése: ha az APNs új tokent ad ki, értesítjük a Flutter oldalt.
    private class func monitorTokenRotation(activity: Activity<LiveActivitiesAppAttributes>) async {
        var isFirst = true
        for await tokenData in activity.pushTokenUpdates {
            if isFirst { isFirst = false; continue } // Az első tokent már kezeltük
            let tokenHex = tokenData.map { String(format: "%02x", $0) }.joined()
            activityPushToken = tokenHex
            print("Live Activity push token frissítve (rotation): \(tokenHex)")
            NotificationCenter.default.post(
                name: NSNotification.Name("LiveActivityTokenUpdated"),
                object: tokenHex
            )
        }
    }

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
