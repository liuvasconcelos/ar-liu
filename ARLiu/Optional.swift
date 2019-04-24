//
//  Optional.swift
//  ARLiu
//
//  Created by Livia Vasconcelos on 23/04/19.
//  Copyright © 2019 LiuVasconcelos. All rights reserved.
//

import Foundation

extension Optional {
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
}
