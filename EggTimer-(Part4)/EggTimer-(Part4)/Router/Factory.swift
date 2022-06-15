//
//  ViewControllerFactory.swift
//  EggTimer-(Part4)
//
//  Created by Adem Tarhan on 16.06.2022.
//

import Foundation
class ViewControllerFactory {
    public static var shared = ViewControllerFactory()

    var home: HomeViewController {
        HomeViewController(nibName: "HomeViewController", bundle: nil)
    }
}
