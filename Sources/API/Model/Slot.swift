//
//  Slot.swift
//  API
//
//  Created by Matthew Gallagher on 12/02/2024.
//

import Foundation

public struct Slot: Decodable, Identifiable {
    public let id: UUID
    public let date: Date
    public let duration: Int
    public let activity: Activity?
    public let presentation: Presentation?
    
    public init(id: UUID, date: Date, duration: Int, activity: Activity?, presentation: Presentation?) {
        self.id = id
        self.date = date
        self.duration = duration
        self.activity = activity
        self.presentation = presentation
    }

    public struct Activity: Decodable, Identifiable {
        public let id: UUID
        public let title: String
        public let subtitle: String
        public let description: String
        public let image: String
        public let metadataURL: String?
        
        public init(id: UUID, title: String, subtitle: String, description: String, image: String, metadataURL: String?) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.description = description
            self.image = image
            self.metadataURL = metadataURL
        }
    }

    public struct Presentation: Decodable, Identifiable {
        public let id: UUID
        public let title: String
        public let synopsis: String
        public let speakers: [Speaker]
        public let slidoURL: String?
        public let videoURL: String?
        
        public init(id: UUID, title: String, synopsis: String, speakers: [Speaker], slidoURL: String?, videoURL: String?) {
            self.id = id
            self.title = title
            self.synopsis = synopsis
            self.speakers = speakers
            self.slidoURL = slidoURL
            self.videoURL = videoURL
        }

        public struct Speaker: Decodable, Identifiable {
            public let id: UUID
            public let name: String
            public let biography: String
            public let profileImage: String
            public let organisation: String?
            public let twitter: String?
            
            public init(id: UUID, name: String, biography: String, profileImage: String, organisation: String?, twitter: String?) {
                self.id = id
                self.name = name
                self.biography = biography
                self.profileImage = profileImage
                self.organisation = organisation
                self.twitter = twitter
            }
        }
    }
}
