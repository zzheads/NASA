//
//  NASATests.swift
//  NASATests
//
//  Created by Alexey Papin on 26.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import XCTest
import CoreLocation

@testable import NASA
class NASATests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRoversDataSource() {
        let roverController = RoverPhotosCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        let dataSource = RoversDataSource(collectionView: roverController.collectionView!, delegate: nil)
        
        let endpoint = NASAEndpoints.Mars(NASAEndpoints.QueryPhoto.Sol(.Curiosity, sol: 1000, camera: nil))
        let exp = expectation(description: "Fetching \(endpoint.request)")
        
        // pass case
        dataSource.fetchPics(for: NASAEndpoints.Rover.Curiosity, sol: 1000, camera: nil) { photos, error in
            XCTAssertTrue(photos != nil)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error, "Got error: \(error)")
        }
    }
    
    func testApodAPI() {
        let apiClient = NASAAPIClient(delegate: nil, delegateQueue: nil)
        
        // correct case (date is ok)
        let date = "2015-01-01".toDate
        var exp = expectation(description: "Fetching APOD of \(date) - correct date")
        var apod: APOD? = nil
        var error: Error? = nil
        
        apiClient.fetch(endpoint: NASAEndpoints.APOD(date: date, hd: true)) { (result: APIResult<APOD>) in
            switch result {
            case .Success(let a):
                apod = a
                error = nil
            case .Failure(let e):
                error = e
                apod = nil
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0) { err in
            XCTAssertNil(error, "Got an error: \(error)")
            XCTAssertNotNil(apod, "Didnt get apod")
        }
        
        // error case (date is later than today)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        exp = expectation(description: "Fetching APOD of \(tomorrow) - incorrect date")
        
        apiClient.fetch(endpoint: NASAEndpoints.APOD(date: tomorrow, hd: true)) { (result: APIResult<APOD>) in
            switch result {
            case .Success(let a):
                apod = a
                error = nil
            case .Failure(let e):
                error = e
                apod = nil
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0) { err in
            XCTAssertNotNil(error, "Didnt get error")
            XCTAssertNil(apod, "Got APOD of tomorrow: \(apod)")
        }
    }
    
    func testLandsatAPI() {
        let apiClient = NASAAPIClient(delegate: nil, delegateQueue: nil)
        var asset: LandsatImageAsset? = nil
        var error: Error? = nil
        
        // correct coordinate
        var coordinate = CLLocationCoordinate2D(latitude: 37, longitude: -122)
        var exp = expectation(description: "Fetching Landsat8ImagesAsset of \(coordinate)")
        apiClient.fetch(endpoint: NASAEndpoints.Earth(NASAEndpoints.EarthEndpoint.Asset(coordinate, nil, nil))) { (result: APIResult<LandsatImageAsset>) in
            switch result {
            case .Success(let a):
                asset = a
                error = nil
            case .Failure(let e):
                asset = nil
                error = e
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0) { err in
            XCTAssertNil(error, "Got an error: \(error)")
            if let asset = asset {
                XCTAssertTrue(!asset.results.isEmpty, "Didnt get any images for CA, USA coordinate")
            }
        }
        
        // incorrect coordinate
        coordinate = CLLocationCoordinate2D(latitude: 9000, longitude: 9000)
        exp = expectation(description: "Fetching Landsat8ImagesAsset of \(coordinate)")
        apiClient.fetch(endpoint: NASAEndpoints.Earth(NASAEndpoints.EarthEndpoint.Asset(coordinate, nil, nil))) { (result: APIResult<LandsatImageAsset>) in
            switch result {
            case .Success(let a):
                asset = a
                error = nil
            case .Failure(let e):
                asset = nil
                error = e
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0) { err in
            if let asset = asset {
                XCTAssertTrue(asset.results.isEmpty, "Found images for incorrect coordinate(\(coordinate)): \(asset.results)")
            }
        }
    }
    
}




















