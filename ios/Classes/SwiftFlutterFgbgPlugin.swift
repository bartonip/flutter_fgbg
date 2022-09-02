import UIKit
import Flutter
import UserNotifications

public class SwiftFlutterFGBGPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
 private var eventSink: FlutterEventSink?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterFGBGPlugin()
    
    let lifeCycleChannel = "com.ajinasokan.flutter_fgbg/events"
    let lifecycleEventChannel = FlutterEventChannel(name: lifeCycleChannel, binaryMessenger: registrar.messenger())
    lifecycleEventChannel.setStreamHandler(instance as FlutterStreamHandler & NSObjectProtocol)

    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(instance,
                                    selector: #selector(didBecomeActive),
                                    name: UIApplication.didBecomeActiveNotification,
                                    object: nil)
        
        notificationCenter.addObserver(instance,
                                    selector: #selector(didEnterBackground),
                                    name: UIApplication.didEnterBackgroundNotification,
                                    object: nil)

        notificationCenter.addObserver(instance,
                                        selector: #selector(willEnterForeground),
                                        name: UIApplication.willEnterForegroundNotification,
                                        object: nil)
        
        notificationCenter.addObserver(instance,
                                    selector: #selector(willResignActive),
                                    name: UIApplication.willResignActiveNotification,
                                    object: nil)
        

        notificationCenter.addObserver(instance,
                                        selector: #selector(willTerminate),
                                        name: UIApplication.willTerminateNotification,
                                        object: nil)

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        NotificationCenter.default.removeObserver(instance)
        return nil
    }

    @objc func addToEventSink(event: String) {
        do {
            try self.eventSink?(event)
        } catch {
            print("Flutter Engine was probably not ready yet. Message will not be sent.")
        }
    }
    
    @objc func didBecomeActive() {
        addToEventSink(event: "didBecomeActive")
    }

    @objc func didEnterBackground() {
        addToEventSink(event: "didEnterBackground")
    }

    @objc func willEnterForeground() {
        addToEventSink(event: "willEnterForeground")
    }

    @objc func willResignActive() {
        addToEventSink(event: "willResignActive")
    }

    @objc func willTerminate() {
        addToEventSink(event: "willTerminate")
    }

}
