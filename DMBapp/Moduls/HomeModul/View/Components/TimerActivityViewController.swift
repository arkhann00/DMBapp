//
//  TimerActivityViewController.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 31.12.2024.
//

import UIKit
import SwiftUI

struct TimerActivityViewController: UIViewControllerRepresentable {
    let image: UIImage

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
