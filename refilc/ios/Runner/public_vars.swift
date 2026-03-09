//
//  public_vars.swift
//  Runner
//
//  Created by Geryy on 02/05/2024.
//

import Foundation

var lessonDataDictionary: [String: Any] = [:]
var globalLessonData = LessonData(from: lessonDataDictionary)
var activityID: String? = ""
var activityPushToken: String? = nil
/// Ha true, a monitorActivityState nem küld dismiss notification-t (cleanup közben vagyunk)
var isCleaningUpOldActivities = false
