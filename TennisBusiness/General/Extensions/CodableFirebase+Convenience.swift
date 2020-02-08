//
//  CodableFirebase+Convenience.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 2/8/20.
//  Copyright © 2020 nikolay.mihailishin. All rights reserved.
//

import CodableFirebase
import FirebaseFirestore

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

extension Encodable {
    func encode() -> [String: Any]? {
        do {
            var document = try FirestoreEncoder().encode(self)
            document["documentID"] = nil
            return document
        }
        catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension Decodable {
    static func decode(from snapshot: DocumentSnapshot?) -> Self? {
        if let snapshot = snapshot, let data = snapshot.data() {
            do {
                var document = data
                document["documentID"] = snapshot.documentID
                return try FirestoreDecoder().decode(Self.self, from: document)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
