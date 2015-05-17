//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Oliver Körber on 14/05/15.
//  Copyright (c) 2015 Oliver Körber. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String
    
    init(url: NSURL, title: String) {
        self.filePathUrl = url
        self.title = title
    }
}