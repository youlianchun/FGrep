#  grep -rls xxx/xxx

contains["权限"] = ["关键字", "关键字", ...]
关键字都匹配到为YES

contains["IDFV"] = ["identifierForVendor", "UIDevice"]
contains["IDFA"] = ["advertisingIdentifier", "UIDevice"]
contains["音乐库"] = ["MPMediaLibrary", "requestAuthorization"]
contains["蓝牙 Peripheral"] = ["CBPeripheralManager", "startAdvertising"]
contains["蓝牙 Central"] = ["CBCentralManager"]
contains["日历"] = ["EKEventStore", "requestAccess"]
contains["相机 or 麦克风"] = ["AVCaptureDevice", "requestAccess"]
contains["通讯录"] = ["CNContactStore", "requestAccess"]
contains["定位 Always"] = ["CLLocationManager", "requestAlwaysAuthorization"]
contains["定位 InUse"] = ["CLLocationManager", "requestWhenInUseAuthorization"]
contains["运动健康"] = ["CMMotionActivityManager", "queryActivityStarting"]
contains["听筒"] = ["AVAudioSession", "requestRecordPermission"]
contains["通知"] = ["UNUserNotificationCenter", "requestAuthorization"]
contains["相册"] = ["PHPhotoLibrary", "requestAuthorization"]
contains["Siri"] = ["INPreferences", "requestSiriAuthorization"]
contains["语音识别"] = ["SFSpeechRecognizer", "requestAuthorization"]

