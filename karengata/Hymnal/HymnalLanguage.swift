import SwiftUI

struct HymnalLanguage: Identifiable, Hashable {
    let id: Int
    let name: String
    let subtitle: String
    let hymnsCount: Int
    let color: Color

    init(id: Int, name: String, subtitle: String, hymnsCount: Int = 0) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.hymnsCount = hymnsCount
        self.color = HymnalLanguage.colorForId(id)
    }

    init(response: HymnLanguageResponse) {
        self.id = response.id
        self.name = response.name
        self.subtitle = response.description
        self.hymnsCount = response.hymnsCount ?? 0
        self.color = HymnalLanguage.colorForId(response.id)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: HymnalLanguage, rhs: HymnalLanguage) -> Bool {
        lhs.id == rhs.id
    }

    private static func colorForId(_ id: Int) -> Color {
        let colors: [Color] = [
            Color(red: 0.2, green: 0.5, blue: 0.9),   // blue
            Color(red: 0.6, green: 0.3, blue: 0.8),   // purple
            Color(red: 0.95, green: 0.5, blue: 0.2),  // orange
            Color(red: 0.2, green: 0.7, blue: 0.7),   // teal
            Color(red: 0.9, green: 0.4, blue: 0.5),   // pink
            Color(red: 0.3, green: 0.7, blue: 0.4)    // green
        ]
        return colors[id % colors.count]
    }
}

struct HymnVerse {
    let label: String
    let text: String

    var isChorus: Bool {
        let lower = label.lowercased()
        return lower == "chorus" || lower == "refrain"
    }
}

struct Hymn: Identifiable, Hashable {
    let id: Int
    let number: Int
    let title: String
    let verses: [HymnVerse]
    let languageId: Int
    var isFavorite: Bool

    var formattedNumber: String {
        String(format: "%03d", number)
    }

    var firstLine: String {
        verses.first?.text.components(separatedBy: "\n").first ?? ""
    }

    init(id: Int, number: Int, title: String, verses: [HymnVerse], languageId: Int, isFavorite: Bool = false) {
        self.id = id
        self.number = number
        self.title = title
        self.verses = verses
        self.languageId = languageId
        self.isFavorite = isFavorite
    }

    init(response: HymnResponse) {
        self.id = response.id
        self.number = response.hymnNumber
        self.title = response.title
        self.languageId = response.language.id
        self.isFavorite = response.isFavorite
        self.verses = Hymn.parseLyrics(response.lyrics)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Hymn, rhs: Hymn) -> Bool {
        lhs.id == rhs.id
    }

    private static func parseLyrics(_ lyrics: String) -> [HymnVerse] {
        let pattern = #"(?:^|\n)(\d+|Refrain|Chorus)\n"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(lyrics.startIndex..., in: lyrics)

        var verses: [HymnVerse] = []
        var lastLabel = ""
        var lastEnd = lyrics.startIndex

        regex?.enumerateMatches(in: lyrics, options: [], range: range) { match, _, _ in
            guard let match = match else { return }

            if let matchRange = Range(match.range, in: lyrics) {
                let previousText = String(lyrics[lastEnd..<matchRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
                if !previousText.isEmpty && lastEnd != lyrics.startIndex {
                    verses.append(HymnVerse(label: lastLabel, text: previousText))
                }
                if let labelRange = Range(match.range(at: 1), in: lyrics) {
                    lastLabel = String(lyrics[labelRange])
                }
                lastEnd = matchRange.upperBound
            }
        }

        let lastText = String(lyrics[lastEnd...]).trimmingCharacters(in: .whitespacesAndNewlines)
        if !lastText.isEmpty {
            verses.append(HymnVerse(label: lastLabel, text: lastText))
        }

        if verses.isEmpty {
            return [HymnVerse(label: "1", text: lyrics.trimmingCharacters(in: .whitespacesAndNewlines))]
        }

        return verses
    }
}
