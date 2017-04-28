//
//  MarkersTableView.swift
//  GPS
//
//  Created by Maxim Mazhuga on 11.04.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit

class MarkersTableViewCell: UITableViewCell {
    @IBOutlet weak var titleTableView: UILabel!
    @IBOutlet weak var subtitleTableView: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var batteryStatus: UIImageView!
    @IBOutlet weak var gpsStatus: UIImageView!
}
