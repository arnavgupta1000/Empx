import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        cancellable = notificationCenter.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: notificationCenter.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { $0.userInfo }
            .map { userInfo -> CGFloat in
                if let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    if frame.origin.y == UIScreen.main.bounds.height {
                        return 0
                    } else {
                        return frame.height
                    }
                } else {
                    return 0
                }
            }
            .assign(to: \.currentHeight, on: self)
    }
}
