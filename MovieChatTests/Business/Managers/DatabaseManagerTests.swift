//
//  DatabaseManagerTests.swift
//  MovieChatTests
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import FirebaseFirestore
import Firebase
@testable import MovieChat

private class FirestoreMock : Firestore {
    
    init(dummy: Any?) {}
    
    var collectionStub: CollectionReference!
    override func collection(_ collectionPath: String) -> CollectionReference {
        return collectionStub
    }
    
}

private class QueryMock : Query {
    
    init(dummy: Any?) {}
    
    var handler: FIRQuerySnapshotBlock!
    override func addSnapshotListener(_ listener: @escaping FIRQuerySnapshotBlock) -> ListenerRegistration {
        handler = listener
        return ListenerMock()
    }
    
}

private class DocumentReferenceMock : DocumentReference {
    
    init(dummy: Any?) {}
    
    var collectionStub: CollectionReference!
    override func collection(_ collectionPath: String) -> CollectionReference {
        return collectionStub
    }
    
    var setDataCompletion: ((Error?) -> Void)!
    override func setData(_ documentData: [String : Any], merge: Bool, completion: ((Error?) -> Void)? = nil) {
        setDataCompletion = completion
    }
    
}

private class CollectionReferenceMock : CollectionReference {
    
    init(dummy: Any?) {}
    
    var documentStub: DocumentReference!
    override func document(_ documentPath: String) -> DocumentReference {
        return documentStub
    }
    
    var addDocumentLastValue: [ String: Any ]!
    override func addDocument(data: [String : Any]) -> DocumentReference {
        addDocumentLastValue = data
        return documentStub
    }
    
    var queryStub: Query!
    override func order(by field: String) -> Query {
        return queryStub
    }
    
}

private class ListenerMock : NSObject, ListenerRegistration {
    
    func remove() {}
    
}

private class SnapshotMock : QuerySnapshot {
    
    init(dummy: Any?) {}
    
    var documentChangesStub: [ DocumentChange ]!
    override var documentChanges: [DocumentChange] { return documentChangesStub }
    
}

private class DocumentChangeMock : DocumentChange {
    
    init(dummy: Any?) {}
    
    var documentStub: QueryDocumentSnapshot!
    override var document: QueryDocumentSnapshot { return documentStub }
    
}

private class QueryDocumentSnapshotMock : QueryDocumentSnapshot {
    
    init(dummy: Any?) {}
    
    var dataStub: [ String: Any ]!
    override func data() -> [String : Any] { return dataStub }
    
}

class DatabaseManagerTests: XCTestCase {
    
    var manager: DatabaseManager!
    private var firestoreMock: FirestoreMock!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        firestoreMock = FirestoreMock(dummy: nil)
        manager = DatabaseManager(firestore: firestoreMock)
    }

    override func tearDown() {
        firestoreMock = nil
        manager = nil
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testErrorShouldReturnUnsuccessfulResult() {
        // Given
        let movieDocument = DocumentReferenceMock(dummy: nil)
        let moviesCollection = CollectionReferenceMock(dummy: nil)
        let commentsCollection = CollectionReferenceMock(dummy: nil)
        let queryMock = QueryMock(dummy: nil)
        
        moviesCollection.documentStub = movieDocument
        movieDocument.collectionStub = commentsCollection
        commentsCollection.queryStub = queryMock
        firestoreMock.collectionStub = moviesCollection
        
        let movie = Movie(json: [ "title": "Some_title" ])
        manager.addListenerForComments(on: movie) { success, comments in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(comments)
        }
        
        // When
        queryMock.handler(nil, NSError(domain: "", code: 0, userInfo: nil))
    }
    
    func testReturnedDataShouldBeMappedToComments() {
        // Given
        let movieDocument = DocumentReferenceMock(dummy: nil)
        let moviesCollection = CollectionReferenceMock(dummy: nil)
        let commentsCollection = CollectionReferenceMock(dummy: nil)
        let queryMock = QueryMock(dummy: nil)

        moviesCollection.documentStub = movieDocument
        movieDocument.collectionStub = commentsCollection
        commentsCollection.queryStub = queryMock
        firestoreMock.collectionStub = moviesCollection
        
        let querySnapshot1 = QueryDocumentSnapshotMock(dummy: nil)
        querySnapshot1.dataStub = [:]
        let querySnapshot2 = QueryDocumentSnapshotMock(dummy: nil)
        querySnapshot2.dataStub = [:]
        
        let documentMock1 = DocumentChangeMock(dummy: nil)
        documentMock1.documentStub = querySnapshot1
        let documentMock2 = DocumentChangeMock(dummy: nil)
        documentMock2.documentStub = querySnapshot2
        
        let snapshot = SnapshotMock(dummy: nil)
        snapshot.documentChangesStub = [ documentMock1, documentMock2 ]
        
        let movie = Movie(json: [ "title": "Some_title" ])
        manager.addListenerForComments(on: movie) { success, comments in
            // Then
            XCTAssertTrue(success)
            XCTAssertEqual(comments!.count, 2)
        }
        
        // When
        queryMock.handler(snapshot, nil)
    }
    
    func testSaveComment() {
        // Given
        let movieDocument = DocumentReferenceMock(dummy: nil)
        let moviesCollection = CollectionReferenceMock(dummy: nil)
        let commentsCollection = CollectionReferenceMock(dummy: nil)

        moviesCollection.documentStub = movieDocument
        movieDocument.collectionStub = commentsCollection
        commentsCollection.documentStub = DocumentReferenceMock(dummy: nil)
        firestoreMock.collectionStub = moviesCollection
        
        let movie = Movie(json: [ "title": "Some_title" ])
        let comment = Comment(content: "some_comment")
        
        manager.saveComment(comment, on: movie)
        
        // When
        movieDocument.setDataCompletion(nil)
        
        // When
        let savedDocument = commentsCollection.addDocumentLastValue!
        XCTAssertEqual(savedDocument["content"] as! String, "some_comment")
    }

}
