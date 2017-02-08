//
//  Beddy_ButlerAudioTests.swift
//  Beddy Butler
//
//  Created by David Garces on 18/08/2015.
//  Copyright (c) 2015 David Garces. All rights reserved.
//

import XCTest
@testable import Beddy_Butler
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class Beddy_ButlerAudioTests: XCTestCase {
    
    var player: AudioPlayer = AudioPlayer()
    var audioFile: AudioPlayer.AudioFiles?
    
    override func setUp() {
        audioFile = nil
    }
    
    override func tearDown() {
    }
    
    
    func testPlayerInitialises() {
        XCTAssertNotNil(player, "test player initialises")
    }
    
    func testInsistentAudioFileName() {
        audioFile = AudioPlayer.AudioFiles.insistent
        XCTAssertEqual(audioFile!.description(), "Insistent", "test insistent audio file name")
    }
    
    func testShyAudioFileName() {
        audioFile = AudioPlayer.AudioFiles.shy
        XCTAssertEqual(audioFile!.description(), "Shy", "test shy audio file name")
    }
    
    func testZombieAudioFileName() {
        audioFile = AudioPlayer.AudioFiles.zombie
        XCTAssertEqual(audioFile!.description(), "Zombie", "test zombie audio file name")
    }
    
    func testInsistentAudioFileExistsandPlays() {
        player.playFile(AudioPlayer.AudioFiles.insistent)
        // In Swift 2.0 you will be able to throw an error and test that error doesn't from from
    }
    
    func testShyAudioFileExistsandPlays() {
        player.playFile(AudioPlayer.AudioFiles.shy)
        // In Swift 2.0 you will be able to throw an error and test that error doesn't from from
    }
    
    func testZombieAudioFileExistsandPlays() {
        player.playFile(AudioPlayer.AudioFiles.zombie)
        // In Swift 2.0 you will be able to throw an error and test that error doesn't from from
    }
    
    func testEnumeratesAudioFiles() {
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
        XCTAssert(urls?.count >= 50)
        
    }
    
    func testEnumerateZombieFiles() {
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
        let zombieURLs = urls?.filter { $0.absoluteString.contains("Zombie") }
        XCTAssert(zombieURLs?.count >= 50)
    }
    
    func testEnumerateShyFiles() {
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
        let shyURLs = urls?.filter { $0.absoluteString.contains("Shy") }
        XCTAssert(shyURLs?.count >= 15)
    }
    
    func testEnumerateInsistentFiles() {
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
        let insistentURLs = urls?.filter { $0.absoluteString.contains("Insistent") }
        XCTAssert(insistentURLs?.count >= 15)
    }

    
}

