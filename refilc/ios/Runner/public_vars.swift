import Foundation

var lessonDataDictionary: [String: Any] = [:]
var globalLessonData = LessonData(from: lessonDataDictionary)
var activityID: String? = ""
var activityPushToken: String? = nil
var isCleaningUpOldActivities = false
