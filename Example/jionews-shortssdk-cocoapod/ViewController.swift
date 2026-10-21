//
//  ViewController.swift
//  jionews-shortssdk-cocoapod
//
//  Created by Saif on 02/06/2024.
//  Copyright (c) 2024 Saif. All rights reserved.
//

import UIKit
import jionews_shortssdk_cocoapod

class ViewController: UIViewController {

    @IBOutlet weak var shortsView: ShortsView!

    // Staging Authorization (JWT) token for the JioNews GraphQL endpoint.
    
    private var hid = "ffbc92ccb4afb969c30834b41895f7ad61b3d394c0007fb4b96416b4d7d9d806"


    override func viewDidLoad() {
        super.viewDidLoad()
        shortsView
            .initData(hid: hid, redirectSource: "org.cocoapods.demo.jionews-shortssdk-cocoapod-Example", theme: ShortsView.THEME_LIGHT, debug: false, env: .stg)
        shortsView.setOnEventListener(self)
        shortsView.shortload()
        shortsView.loadShorts()
        
        NotificationCenter.default.addObserver(self,
                                                       selector: #selector(handleApplicationDidBecomeActive),
                                                       name: UIApplication.didBecomeActiveNotification,
                                                       object: nil)
    }
    
    @objc
    func handleApplicationDidBecomeActive() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self, self.shortsView.isSetupCompleted else { return }
            if self.shortsView.isPlaying {
                self.shortsView.playVideo()   // was set to play → resume
            } else {
                self.shortsView.pauseVideo()  // was paused → keep paused
            }
        }
    }
}

extension ViewController: ShortsEventListener {

    func onShareClick(_ brief: ShortsVideoBrief) {
        print("Share tapped: \(brief.id ?? "")")
    }

    func onSwipe(_ brief: ShortsVideoBrief) {
        print("Swiped to: \(brief.title ?? "")")
    }
}
