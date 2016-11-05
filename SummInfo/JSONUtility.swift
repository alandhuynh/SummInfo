//
//  JSONUtility.swift
//  SummInfo
//
//  Created by Alan Huynh on 11/5/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONUtility {
    
    // Helper method used to extract all sub JSONs of a particular type
    // from a parent JSON
    //
    // Ex. Consider the JSON array [1, "two", { "three" : "tres" }, "four", 5]
    //     1. getSubJSONs(json:jsonArr, type:.number) -> [1, 5]
    //     2. getSubJSONS(json:jsonArr, type:.string) -> ["two", "four"]
    //
    // NOTE: The returned array's elements are JSON objects, NOT standard types
    static func getSubJSONs(json:JSON, type:Type) -> [JSON] {
        var subJSONs:[JSON] = []
        
        // For both JSON arrays and JSON dictionaries, we can iterate over the
        // JSON collection's elements using the tuple (_, subJSON)
        for (_, subJSON) in json {
            if subJSON.type == type {
                subJSONs.append(subJSON)
            }
        }
        
        return subJSONs
    }
    
    // Helper method used to recursively search through a JSON dictionary and its
    // sub JSON dictionaries for a particular key
    //
    // NOTE: This function uses recursion, so be careful with searching JSONs with
    //       great sublevel depth
    static func searchJSONDicts(json:JSON, key:JSONSubscriptType) -> JSON? {
        // Ignore all other JSON types; we only want to deal with dictionaries (for now)
        if json.type == .dictionary {
            // First, we should check whether the key exists in this top level dictionary;
            // if so, we can return immediately
            if json[key].exists() {
                return json[key]
            } else {
                // Otherwise, we need to grab all the next level dictionaries and recursively
                // call search on those
                let subJSONs = JSONUtility.getSubJSONs(json: json, type: .dictionary)
                for subJSON in subJSONs {
                    if let value = JSONUtility.searchJSONDicts(json: subJSON, key: key) {
                        return value
                    }
                }
            }
        }
        return nil
    }
}
