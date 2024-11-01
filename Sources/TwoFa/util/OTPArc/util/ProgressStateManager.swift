import Foundation
/**
 * Describes the purpose and functionality of the ProgressStateManager class.
 * - Description: The ProgressStateManager class is an ObservableObject that manages 
 *                the progress state of a SwiftUI view. It uses the @Published property 
 *                wrapper to allow the progress value to be observed and automatically 
 *                update the view when the value changes.
 * - Note: In SwiftUI, you cannot directly mutate a @State property from within a 
 *         delegate callback. This is because the callback is not part of the SwiftUI 
 *         view's lifecycle, and thus, it cannot access or modify the view's state.
 * - Note: To work around this limitation, you can use an ObservableObject and 
 *         @Published property wrapper to manage the state
 * - Note: By using an ObservableObject and @Published property wrapper, you can 
 *         effectively mutate the state from within a delegate callback. The changes 
 *         to the state will be automatically propagated to the SwiftUI view, causing 
 *         it to update accordingly.
 */
internal class ProgressStateManager: ObservableObject {
    /**
     * The current progress value, represented as a CGFloat between 0 and 1.
     * - Description: This property is marked with the @Published property 
     *               wrapper, which allows SwiftUI to observe changes to 
     *               the progress value and automatically update the view 
     *               accordingly.
     */
   @Published var progress: CGFloat = 0
}
