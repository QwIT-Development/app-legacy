import ActivityKit
import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
  var body: some Widget {
      if #available(iOS 16.2, *) {
          LiveCardWidget()
    }
  }
}

// text contrast background
extension Text {
    func getContrastText(backgroundColor: Color) -> some View {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(backgroundColor).getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  luminance < 0.6 ? self.foregroundColor(.white) : self.foregroundColor(.black)
    }
}

// Color Converter
extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hexValue = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
}

// MARK: - Helper: next lesson line

private func buildNextLessonLine(state: LiveActivitiesAppAttributes.ContentState) -> String {
    let subject = state.nextSubject.trimmingCharacters(in: .whitespacesAndNewlines)
    let room = state.nextRoom.trimmingCharacters(in: .whitespacesAndNewlines)
    if room.isEmpty { return subject }
    return "\(subject) - \(room)"
}

private func hasNextLesson(state: LiveActivitiesAppAttributes.ContentState) -> Bool {
    !state.nextSubject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}

// MARK: - Lock Screen Live Activity

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<LiveActivitiesAppAttributes>

    private var isExpired: Bool {
        context.state.endDate <= Date()
    }

    private var countdownFont: Font {
        let remaining = max(0, context.state.endDate.timeIntervalSinceNow)
        return remaining >= 3600 ? .title3 : .title2
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Ikon
            Image(systemName: context.state.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .padding(.leading, 16)

            VStack(alignment: .leading, spacing: 3) {
                // Jelenlegi óra
                if context.state.title.contains("Az első órádig") {
                    Text(context.state.title)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(2)
                } else if context.state.title == "Szünet" {
                    Text(context.state.title)
                        .font(.system(size: 15, weight: .bold))
                } else {
                    Text("\(context.state.index) \(context.state.title) - \(context.state.subtitle)")
                        .font(.system(size: 15, weight: .bold))
                        .lineLimit(2)
                }

                // Leírás (helyettesítés info stb.)
                if !context.state.description.isEmpty {
                    Text(context.state.description)
                        .font(.system(size: 13))
                        .lineLimit(2)
                        .foregroundStyle(.secondary)
                }

                // Következő óra
                if hasNextLesson(state: context.state) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundStyle(.secondary)
                        Text(buildNextLessonLine(state: context.state))
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("Ez az utolsó óra! Kitartást!")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .layoutPriority(0)

            Spacer(minLength: 4)

            // Visszaszámláló
            if isExpired {
                Text("Vége")
                    .multilineTextAlignment(.trailing)
                    .frame(minWidth: 86, maxWidth: 100, alignment: .trailing)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .layoutPriority(1)
                    .padding(.trailing, 16)
            } else {
                Text(timerInterval: context.state.date, countsDown: true)
                    .multilineTextAlignment(.trailing)
                    .frame(minWidth: 86, maxWidth: 100, alignment: .trailing)
                    .font(countdownFont)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .layoutPriority(1)
                    .padding(.trailing, 16)
            }
        }
        .activityBackgroundTint(
          Color.clear
        )
        .foregroundStyle(Color(hex: context.state.color))
    }
}

// MARK: - Widget Configuration

@available(iOSApplicationExtension 16.2, *)
struct LiveCardWidget: Widget {
    var body: some WidgetConfiguration {
        /// Live Activity Notification
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            LockScreenLiveActivityView(context: context)
            /// Dynamic Island
        } dynamicIsland: { context in

            /// Expanded
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Spacer()
                        ProgressView(
                            timerInterval: context.state.date,
                            countsDown: true,
                            label: {
                                Image(systemName: context.state.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                            },
                            currentValueLabel: {
                                Image(systemName: context.state.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                            }
                        ).progressViewStyle(.circular)
                    }
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 4) {
                        if context.state.title.contains("Az első órádig") {
                            // Első óra előtt
                            Text("Az első órád:")
                                .font(.subheadline)
                                .bold()
                            Text(context.state.nextSubject)
                                .font(.subheadline)
                                .lineLimit(2)
                            if !context.state.nextRoom.isEmpty {
                                Text("Terem: \(context.state.nextRoom)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } else if context.state.title == "Szünet" {
                            // Szünet
                            Text(context.state.title)
                                .font(.subheadline)
                                .bold()

                            if !context.state.description.isEmpty {
                                Text(context.state.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            if hasNextLesson(state: context.state) {
                                Spacer(minLength: 2)
                                Text("Következő óra és terem:")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text(buildNextLessonLine(state: context.state))
                                    .font(.caption)
                            }
                        } else {
                            // Óra közben
                            Text("\(context.state.index) \(context.state.title) - \(context.state.subtitle)")
                                .font(.subheadline)
                                .bold()
                                .lineLimit(2)

                            if !context.state.description.isEmpty {
                                Text(context.state.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer(minLength: 2)

                            if hasNextLesson(state: context.state) {
                                Text("Következő óra és terem:")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text(buildNextLessonLine(state: context.state))
                                    .font(.caption)
                            } else {
                                Text("Ez az utolsó óra! Kitartást!")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.leading, 4)
                }

                /// Compact
            } compactLeading: {
                Image(systemName: context.state.icon)
            }
            compactTrailing: {
                if context.state.endDate <= Date() {
                    Text("Vége")
                        .multilineTextAlignment(.center)
                        .frame(width: 52)
                        .font(.caption2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                } else {
                    Text(timerInterval: context.state.date, countsDown: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 52)
                        .font(.caption2)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }

                /// Collapsed
            } minimal: {
                ProgressView(
                    timerInterval: context.state.date,
                    countsDown: true,
                    label: {
                        Image(systemName: context.state.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                    },
                    currentValueLabel: {
                        Image(systemName: context.state.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                    }
                ).progressViewStyle(.circular)
            }
            .keylineTint(
                context.state.color != "#676767"
                ? Color(hex: context.state.color)
                : Color.clear
            )
        }
        .supplementalActivityFamilies([.small, .medium])
    }
}

// MARK: - Previews

struct LiveCardWidget_Previews: PreviewProvider {

    static let attributes = LiveActivitiesAppAttributes()

    static let duringLessonExample = LiveActivitiesAppAttributes.ContentState(
      color: "#FF5733",
      icon: "bell",
      index: "1.",
      title: "Math Class",
      subtitle: "Terem: 101",
      description: "Helyettesítés: Teszt Tanár",
      startDate: Date(),
      endDate: Date().addingTimeInterval(3000),
      date: Date()...Date().addingTimeInterval(3000),
      nextSubject: "Physics",
      nextRoom: "102"
    )

    static let inBreak = LiveActivitiesAppAttributes.ContentState(
      color: "#FF5733",
      icon: "house",
      index: "",
      title: "Szünet",
      subtitle: "",
      description: "Menj a(z) 122 terembe.",
      startDate: Date(),
      endDate: Date().addingTimeInterval(3000),
      date: Date()...Date().addingTimeInterval(3000),
      nextSubject: "Physics",
      nextRoom: "122"
    )

    static let lastLesson = LiveActivitiesAppAttributes.ContentState(
      color: "#00ff00",
      icon: "bell",
      index: "6.",
      title: "Math Class",
      subtitle: "Terem: 201",
      description: "",
      startDate: Date(),
      endDate: Date().addingTimeInterval(3000),
      date: Date()...Date().addingTimeInterval(3000),
      nextSubject: "",
      nextRoom: ""
    )

    static var previews: some View {
      Group {
        attributes
          .previewContext(duringLessonExample, viewKind: .dynamicIsland(.compact))
          .previewDisplayName("During Lesson")
        attributes
          .previewContext(inBreak, viewKind: .dynamicIsland(.compact))
          .previewDisplayName("In Break")
        attributes
          .previewContext(lastLesson, viewKind: .dynamicIsland(.compact))
          .previewDisplayName("During Last Lesson")
      }
    }

}
