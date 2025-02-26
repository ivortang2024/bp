import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {

  var backgroundTask: UIBackgroundTaskIdentifier = .invalid

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 配置音频会话
    configureAudioSession()

    // 监听应用生命周期
    NotificationCenter.default.addObserver(self, selector: #selector(handleAudioInterruption), name: AVAudioSession.interruptionNotification, object: nil)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func configureAudioSession() {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playback, mode: .default, options: .mixWithOthers)
      try session.setActive(true, options: .notifyOthersOnDeactivation)
      print("音频会话已激活")
    } catch {
      print("设置音频会话失败: \(error.localizedDescription)")
    }
  }

  @objc func handleAudioInterruption(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
          let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

    switch type {
    case .began:
      print("音频被中断")
    case .ended:
      print("音频中断结束，尝试恢复")
      do {
        try AVAudioSession.sharedInstance().setActive(true)
      } catch {
        print("恢复音频会话失败: \(error.localizedDescription)")
      }
    @unknown default:
      break
    }
  }

  func registerBackgroundTask() {
    backgroundTask = UIApplication.shared.beginBackgroundTask {
      UIApplication.shared.endBackgroundTask(self.backgroundTask)
      self.backgroundTask = .invalid
    }
    print("后台任务已注册: \(backgroundTask)")
  }

  override func applicationDidEnterBackground(_ application: UIApplication) {
    print("应用进入后台，启动后台任务")
    registerBackgroundTask()
    configureAudioSession()
  }

  override func applicationWillEnterForeground(_ application: UIApplication) {
    print("应用进入前台，结束后台任务")
    if backgroundTask != .invalid {
      UIApplication.shared.endBackgroundTask(backgroundTask)
      backgroundTask = .invalid
    }
    configureAudioSession()
  }
}
