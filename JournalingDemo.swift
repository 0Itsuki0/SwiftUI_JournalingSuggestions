//
//  JournalingDemo.swift
//  Beta26Demo
//
//  Created by Itsuki on 2025/07/14.
//

import SwiftUI
import HealthKit

// only available on real devices
#if canImport(JournalingSuggestions)
import JournalingSuggestions


enum SuggestionItem {
    // A suggestion for a connection a person makes with someone else.
    case contact(JournalingSuggestion.Contact)
    
    // A suggestion for a poster image of an event.
    case eventPoster(JournalingSuggestion.EventPoster)
    
    // A suggestion describing now playable media that a person listened to.
    case genericMedia(JournalingSuggestion.GenericMedia)

    // A suggestion for a Live Photo from a person’s library.
    case livePhoto(JournalingSuggestion.LivePhoto)
    
    // A suggestion that represents a location that a person visits.
    case location(JournalingSuggestion.Location)
    
    // A suggestion that contains multiple visited locations that a person chooses in the picker.
    case locationGroup(JournalingSuggestion.LocationGroup)

    // A suggestion that describes motion activity, including the number of steps a person takes.
    case motionActivity(JournalingSuggestion.MotionActivity)
    
    // A suggestion for a photo from a person’s library.
    case photo(JournalingSuggestion.Photo)

    // A suggestion that describes a podcast episode a person listened to.
    case podcast(JournalingSuggestion.Podcast)

    // A suggestion for a reflection prompt.
    case reflection(JournalingSuggestion.Reflection)
    
    // A suggestion that describes a state of mind reflection in the Health app.
    case stateOfMind(JournalingSuggestion.StateOfMind)

    // A suggestion for a song from a person’s music library.
    case song(JournalingSuggestion.Song)

    // A suggestion for a video from a person’s library.
    case video(JournalingSuggestion.Video)

    // A suggestion that describes a workout that a person completed.
    case workout(JournalingSuggestion.Workout)

    // A suggestion that contains multiple workouts that a person chooses in the picker.
    case workoutGroup(JournalingSuggestion.WorkoutGroup)
}

extension SuggestionItem {
    static let suggestionContentType: [any JournalingSuggestionAsset.Type] = [
        JournalingSuggestion.Contact.self,
        JournalingSuggestion.EventPoster.self,
        JournalingSuggestion.GenericMedia.self,
        JournalingSuggestion.LivePhoto.self,
        JournalingSuggestion.Location.self,
        JournalingSuggestion.LocationGroup.self,
        JournalingSuggestion.MotionActivity.self,
        JournalingSuggestion.Photo.self,
        JournalingSuggestion.Podcast.self,
        JournalingSuggestion.Reflection.self,
        JournalingSuggestion.Contact.self,
        JournalingSuggestion.StateOfMind.self,
        JournalingSuggestion.Song.self,
        JournalingSuggestion.Video.self,
        JournalingSuggestion.Workout.self,
        JournalingSuggestion.WorkoutGroup.self,
    ]
    
    // an item can contain one or more concrete instances of JournalingSuggestionAsset
    static func fromItem(_ item: JournalingSuggestion.ItemContent) async throws -> [SuggestionItem] {
        var correspondingItems: [SuggestionItem] = []
        for contentType in SuggestionItem.suggestionContentType {
            if item.hasContent(ofType: contentType), let loaded = try await item.content(forType: contentType) {
                if let loaded = loaded as? JournalingSuggestion.Contact {
                    correspondingItems.append(.contact(loaded))
                }
                
                if let loaded = loaded as? JournalingSuggestion.EventPoster {
                    correspondingItems.append(.eventPoster(loaded))
                }
                
                if let loaded = loaded as? JournalingSuggestion.GenericMedia {
                    correspondingItems.append(.genericMedia(loaded))
                }
                
                if let loaded = loaded as? JournalingSuggestion.LivePhoto {
                    correspondingItems.append(.livePhoto(loaded))
                }
                
                if let loaded = loaded as? JournalingSuggestion.Location {
                    correspondingItems.append(.location(loaded))
                }
                
                if let loaded = loaded as? JournalingSuggestion.LocationGroup {
                    correspondingItems.append(.locationGroup(loaded))
                }
                
                if let loaded = loaded as? JournalingSuggestion.MotionActivity {
                    correspondingItems.append(.motionActivity(loaded))
                }
                
                if let loaded = loaded as? JournalingSuggestion.Photo {
                    correspondingItems.append(.photo(loaded))
                }
                if let loaded = loaded as? JournalingSuggestion.Podcast {
                    correspondingItems.append(.podcast(loaded))
                }
                if let loaded = loaded as? JournalingSuggestion.Reflection {
                    correspondingItems.append(.reflection(loaded))
                }
                if let loaded = loaded as? JournalingSuggestion.Contact {
                    correspondingItems.append(.contact(loaded))
                }
                if let loaded = loaded as? JournalingSuggestion.StateOfMind {
                    correspondingItems.append(.stateOfMind(loaded))
                }
                if let loaded = loaded as? JournalingSuggestion.Song {
                    correspondingItems.append(.song(loaded))
                }
                if let loaded = loaded as? JournalingSuggestion.Video {
                    correspondingItems.append(.video(loaded))
                }

                if let loaded = loaded as? JournalingSuggestion.Workout {
                    correspondingItems.append(.workout(loaded))
                }
                
                if let loaded = loaded as? JournalingSuggestion.WorkoutGroup {
                    correspondingItems.append(.workoutGroup(loaded))
                }
            }
        }
        
        return correspondingItems
        
    }
    
}

// a custom struct to store processed `JournalingSuggestion`
struct Suggestion {
    var items: [SuggestionItem]
    var date: DateInterval?
    var title: String
}


struct JournalingDemo: View {
    @State private var showSuggestionPicker: Bool = false
    @State private var suggestions: [Suggestion] = []
    
    var body: some View {

        NavigationStack {
            List {
                
                if suggestions.isEmpty {
                    Text("Please pick a suggestion to start!")
                        .foregroundStyle(.gray)
                }
                ForEach(0..<suggestions.count, id: \.self) { suggestionIndex in
                    let suggestion: Suggestion = suggestions[suggestionIndex]

                    Section {
                        let items: [SuggestionItem] = suggestion.items
                        ForEach(0..<items.count, id: \.self) { itemIndex in
                            let item: SuggestionItem = items[itemIndex]
                            switch item {
                            case .contact(let contact):
                                VStack(alignment: .leading) {
                                    Text("Contact")
                                    HStack {
                                        self.image(contact.photo)
                                        Text(contact.name)
                                    }
                                }
                                
                            case .eventPoster(let poster):
                                VStack(alignment: .leading) {
                                    Text("Event Poster")
                                    HStack {
                                        self.image(poster.image)
                                        VStack(alignment: .leading) {
                                            Text(poster.title)
                                            if let place = poster.placeName {
                                                Text(place)
                                                    .font(.caption)
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                    }
                                }
                                
                            case .genericMedia(let media):
                                VStack(alignment: .leading) {
                                    Text("Event Poster")
                                    HStack {
                                        self.image(media.appIcon)
                                        VStack(alignment: .leading) {
                                            Text(media.title ?? "Untitled")
                                            if let date = media.date {
                                                Text(date, style: .date)
                                                    .font(.caption)
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                    }
                                }
                                
                            case .livePhoto(let livePhoto):
                                VStack(alignment: .leading) {
                                    Text("Live Photo")
                                    HStack {
                                        self.image(livePhoto.image)
                                        VStack(alignment: .leading) {
                                            if let date = livePhoto.date {
                                                Text(date, style: .date)
                                                    .font(.caption)
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                    }
                                }
                                
                            case .location(let location):
                                VStack(alignment: .leading) {
                                    Text("Location")
                                    locationView(location)
                                }
                                
                            case .locationGroup(let locationGroup):
                                VStack(alignment: .leading) {
                                    Text("Location Group")
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(0..<locationGroup.locations.count, id: \.self) { index in
                                            let location = locationGroup.locations[index]
                                            locationView(location)
                                        }
                                    }
                                }

                            case .motionActivity(let activity):
                                VStack(alignment: .leading) {
                                    Text("Motion Activity")
                                    HStack {
                                        self.image(activity.icon)
                                        VStack(alignment: .leading) {
                                            Text("\(activity.steps) steps.")
                                            if let date = activity.date {
                                                let start = date.start
                                                let end = date.end
                                                HStack {
                                                    Text(start, style: .date)
                                                    Text("-")
                                                    Text(end, style: .date)
                                                }
                                                .font(.caption)
                                            }
                                        }
                                    }
                                }

                            case .photo(let photo):
                                VStack(alignment: .leading) {
                                    Text("Photo")
                                    HStack {
                                        self.image(photo.photo)
                                        if let date = photo.date {
                                            Text(date, style: .date)
                                        }
                                    }
                                }

                            case .podcast(let podcast):
                                VStack(alignment: .leading) {
                                    Text("Podcast")
                                    HStack {
                                        self.image(podcast.artwork)
                                        if let show = podcast.show {
                                            Text(show)
                                        }
                                        if let episode = podcast.episode {
                                            Text(episode)
                                        }
                                    }
                                }
                                
                            case .reflection(let reflection):
                                VStack(alignment: .leading) {
                                    Text("Reflection")
                                    Text(reflection.prompt)
                                }
                                .listRowBackground(reflection.color)

                            case .song(let song):
                                VStack(alignment: .leading) {
                                    Text("Song")
                                    HStack {
                                        self.image(song.artwork)
                                        if let song = song.song {
                                            Text(song)
                                        }
                                        if let album = song.album {
                                            Text(album)
                                        }
                                        if let artist = song.artist, !artist.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            Text("By \(artist)")
                                                .font(.callout)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                }

                            case .stateOfMind(let stateOfMind):
                                VStack(alignment: .leading) {
                                    Text("State Of Mind")
                                    HStack {
                                        self.image(stateOfMind.icon)
                                        let state = stateOfMind.state
                                        VStack(alignment: .leading) {
                                            switch state.kind {
                                            case .momentaryEmotion:
                                                Text("Momentary Emotion")
                                            case .dailyMood:
                                                Text("Daily Mood")
                                            @unknown default:
                                                Text("Unknown")
                                            }

                                            Text("Valence: \(String(format: "%.2f", state.valence))")
                                        }
                                    }
                                }


                            case .video(let video):
                                VStack(alignment: .leading) {
                                    Text("Video")
                                    if let date = video.date {
                                        Text(date, style: .date)
                                    }
                                }
   
                            case .workout(let workout):
                                VStack(alignment: .leading) {
                                    Text("Workout")
                                    self.workoutView(workout)
                                }
                                
                            case .workoutGroup(let group):
                                VStack(alignment: .leading) {
                                    Text("Workout Group")
                                    HStack {
                                        self.image(group.icon)
                                        if let duration = group.duration {
                                            Text("Duration: \(String(format: "%.0f", duration)) sec.")
                                        }
                                    }

                                    ForEach(0..<group.workouts.count, id:\.self) { index in
                                        let workout = group.workouts[index]
                                        self.workoutView(workout)
                                    }
                                }
                            }
                        }
                        
                        
                    } header: {
                        VStack(alignment: .leading) {
                            Text(suggestion.title)
                            
                            if let date = suggestion.date {
                                let start = date.start
                                let end = date.end
                                HStack {
                                    Text(start, style: .date)
                                    Text("-")
                                    Text(end, style: .date)
                                }
                                .font(.caption)
                            }

                        }
                    }
                    
                }
                
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        self.showSuggestionPicker = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                })
            })
            .journalingSuggestionsPicker(
                isPresented: $showSuggestionPicker,
                journalingSuggestionToken: nil,
//                journalingSuggestionToken: .init(suggestionIdentifier: UUID(uuidString: "5C796A25-1A58-41FB-A016-3ADE12C1C3EA")),
                onCompletion: { suggestion in
                    self.processSuggestion(suggestion)
                }
            )

        }
    }
    
    
    private func image(_ url: URL?) -> some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 36, height: 36)
    }
    
    private func locationView(_ location: JournalingSuggestion.Location) -> some View {
        VStack(alignment: .leading) {
            HStack {
                if let city = location.city {
                    Text(city)
                }
                if let place = location.place {
                    Text(place)
                }
            }
            if let date = location.date {
                HStack {
                    Text("-")
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }

    }
    
    private func workoutView(_ workout: JournalingSuggestion.Workout) -> some View {
        HStack {
            self.image(workout.icon)
            if let details = workout.details {
                VStack(spacing: 0) {
                    let activityTypeString = switch workout.details?.activityType {
                    case .cycling:
                        "Cycling"
                    case .dance:
                        "Dance"
                    case .highIntensityIntervalTraining:
                        "Interval Training"
                    case .hiking:
                        "Hiking"
                    case .running:
                        "Running"
                    case .swimming:
                        "Swimming"
                    case .walking:
                        "Walking"
                    case .swimBikeRun:
                        "Triathlon"
                    default:
                        "Others"
                    }
                    Text(activityTypeString)
                    if let name = details.localizedName {
                        Text(name)
                    }
                    if let energy = details.activeEnergyBurned {
                        Text("\(energy.doubleValue(for: HKUnit.kilocalorie()))")
                    }
                    if let date = details.date {
                        let start = date.start
                        let end = date.end
                        HStack {
                            Text(start, style: .date)
                            Text("-")
                            Text(end, style: .date)
                        }
                    }
                    if let distance = details.distance {
                        Text("\(distance.doubleValue(for: HKUnit.meter()))")
                    }

                }
            }
        }

    }
    
    
    private func processSuggestion(_ suggestion: JournalingSuggestion) {
        print(suggestion)
        
        Task {
            var items: [SuggestionItem] = []
            do {
                for item in suggestion.items {
                    let loaded = try await SuggestionItem.fromItem(item)
                    items.append(contentsOf: loaded)
                }
                self.suggestions.append(Suggestion(items: items, date: suggestion.date, title: suggestion.title))
            } catch (let error) {
                print(error)
            }
        }
    }
    
}


#Preview {
    JournalingDemo()
}

#endif

