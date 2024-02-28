//
//  UserSectionDataSource.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/25.
//

import UIKit
import DomainLayer

public class UserSectionShowableDataSource: UITableViewDiffableDataSource<String, UserDomain> {
    var usersDictionary: Dictionary<String, [UserDomain]> = [:]
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return usersDictionary.keys.count
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = usersDictionary.keys.sorted()
        return sectionTitles[section]
    }
    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return usersDictionary.keys.sorted()
    }
}
