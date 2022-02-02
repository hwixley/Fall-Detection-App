//
//  PolarSdk.swift
//  fall-detector
//
//  Created by Harry Wixley on 27/01/2022.
//

import Foundation
import PolarBleSdk
import RxSwift
import CoreBluetooth

class PolarBleSdkManager : ObservableObject {
    
    // NOTICE this example utilizes all available features
    private var api = PolarBleApiDefaultImpl.polarImplementation(DispatchQueue.main, features: Features.allFeatures.rawValue)
    private var broadcastDisposable: Disposable?
    private var autoConnectDisposable: Disposable?
    private var searchDisposable: Disposable?
    private var ecgDisposable: Disposable?
    private var accDisposable: Disposable?
    public var deviceId = MyData.polarDeviceID
    private var maxEcgCount = 100
    private var maxAccCount = 100
    public var ecgStreamFail: Bool?
    public var accStreamFail: Bool?
    
    @Published private(set) var bluetoothPowerOn: Bool
    @Published private(set) var broadcastEnabled: Bool = false
    @Published private(set) var searchEnabled: Bool = false
    @Published private(set) var ecgEnabled: Bool = false
    @Published private(set) var accEnabled: Bool = false
    @Published private(set) var sdkModeEnabled: Bool = false
    @Published private(set) var deviceConnectionState: ConnectionState = ConnectionState.disconnected
    
    //MARK: Data variables
    @Published var ecg: [Double] = []
    @Published var acc_x: [Double] = []
    @Published var acc_y: [Double] = []
    @Published var acc_z: [Double] = []
    @Published var hr: [Double] = []
    @Published var contact : [Bool] = []
    
    @Published var battery : UInt = 0
    
    
    //MARK: Status variables
    @Published var isRecording: Bool = false {
        didSet {
            if isRecording {
                self.ecg = []
                self.acc_x = []
                self.acc_y = []
                self.acc_z = []
                self.contact = []
            }
        }
    }
    
    
    init() {
        self.bluetoothPowerOn = api.isBlePowered
        
        api.polarFilter(true)
        api.observer = self
        api.deviceFeaturesObserver = self
        api.powerStateObserver = self
        api.deviceInfoObserver = self
        api.sdkModeFeatureObserver = self
        api.deviceHrObserver = self
        api.logger = self
    }
    
    func broadcastToggle() {
        if broadcastEnabled == false {
            broadcastDisposable = api.startListenForPolarHrBroadcasts(nil)
                .observe(on: MainScheduler.instance)
                .subscribe{ e in
                    switch e {
                    case .completed:
                        self.broadcastEnabled = false
                        NSLog("Broadcast listener completed")
                    case .error(let err):
                        self.broadcastEnabled = false
                        NSLog("Broadcast listener failed. Reason: \(err)")
                    case .next(let broadcast):
                        self.broadcastEnabled = true
                        NSLog("HR BROADCAST \(broadcast.deviceInfo.name) HR:\(broadcast.hr) Batt: \(broadcast.batteryStatus)")
                    }
                }
        } else {
            broadcastEnabled = false
            broadcastDisposable?.dispose()
        }
    }
    
    func connectToDevice(id: String) {
        do {
            try api.connectToDevice(id)
            self.deviceId = id
        } catch let err {
            NSLog("Failed to connect to \(id). Reason \(err)")
        }
    }
    
    func disconnectFromDevice() {
        if case .connected(let deviceId) = deviceConnectionState {
            do {
                try api.disconnectFromDevice(deviceId)
            } catch let err {
                NSLog("Failed to disconnect from \(deviceId). Reason \(err)")
            }
        }
    }
    
    func autoConnect() {
        autoConnectDisposable?.dispose()
        autoConnectDisposable = api.startAutoConnectToDevice(-55, service: nil, polarDeviceType: nil)
            .subscribe{ e in
                switch e {
                case .completed:
                    NSLog("auto connect search complete")
                case .error(let err):
                    NSLog("auto connect failed: \(err)")
                }
            }
    }
    
    func searchToggle() {
        if searchDisposable == nil {
            searchEnabled = true
            searchDisposable = api.searchForDevice()
                .observe(on: MainScheduler.instance)
                .subscribe{ e in
                    switch e {
                    case .completed:
                        NSLog("search complete")
                        self.searchEnabled = false
                    case .error(let err):
                        NSLog("search error: \(err)")
                        self.searchEnabled = false
                    case .next(let item):
                        NSLog("polar device found: \(item.name) connectable: \(item.connectable) address: \(item.address.uuidString)")
                    }
                }
        } else {
            searchEnabled = false
            searchDisposable?.dispose()
            searchDisposable = nil
        }
    }
    
    func ecgToggle() {
        if ecgDisposable == nil, case .connected(let deviceId) = deviceConnectionState {
            ecgEnabled = true
            ecgDisposable = api.requestStreamSettings(deviceId, feature: DeviceStreamingFeature.ecg)
                .asObservable()
                .flatMap({ (settings) -> Observable<PolarEcgData> in
                    return self.api.startEcgStreaming(self.deviceId, settings: settings.maxSettings())
                })
                .observe(on: MainScheduler.instance)
                .subscribe{ e in
                    switch e {
                    case .next(let data):
                        if self.isRecording {
                            if self.ecg.count >= self.maxEcgCount {
                                self.ecg.replaceSubrange(0...self.ecg.count-self.maxEcgCount, with: [])
                            }
                            self.ecg.append(contentsOf: data.samples.map { Double($0) })
                        }
                    case .error(let err):
                        NSLog("ECG stream failed: \(err)")
                        self.ecgEnabled = false
                        self.ecgStreamFail = true
                    case .completed:
                        NSLog("ECG stream completed")
                        self.ecgEnabled = false
                    }
                }
        } else {
            ecgEnabled = false
            ecgDisposable?.dispose()
            ecgDisposable = nil
        }
    }
    
    func accToggle() {
        if accDisposable == nil, case .connected(let deviceId) = deviceConnectionState {
            accEnabled = true
            accDisposable = api.requestStreamSettings(deviceId, feature: DeviceStreamingFeature.acc)
                .asObservable()
                .flatMap({ (settings) -> Observable<PolarAccData> in
                    NSLog("settings: \(settings.settings)")
                    return self.api.startAccStreaming(self.deviceId, settings: settings.maxSettings())
                })
                .observe(on: MainScheduler.instance).subscribe{ e in
                    switch e {
                    case .next(let data):
                        /*if self.isRecording {
                            if self.acc_x.count >= self.maxAccCount {
                                self.acc_x.replaceSubrange(0...self.acc_x.count-self.maxAccCount, with: [])
                                self.acc_y.replaceSubrange(0...self.acc_y.count-self.maxAccCount, with: [])
                                self.acc_z.replaceSubrange(0...self.acc_z.count-self.maxAccCount, with: [])
                            }
                            self.acc_x.append(contentsOf: data.samples.map { Double($0.x) })
                            self.acc_y.append(contentsOf: data.samples.map { Double($0.y) })
                            self.acc_z.append(contentsOf: data.samples.map { Double($0.z) })
                        }*/
                        let _ = "nice"
                    case .error(let err):
                        NSLog("ACC stream failed: \(err)")
                        self.accEnabled = false
                        self.accStreamFail = true
                    case .completed:
                        NSLog("ACC stream completed")
                        self.accEnabled = false
                        break
                    }
                }
        } else {
            accEnabled = false
            accDisposable?.dispose()
            accDisposable = nil
        }
    }
    
    func sdkModeEnable() {
        if case .connected(let deviceId) = deviceConnectionState {
            _ = api.enableSDKMode(deviceId)
                .observe(on: MainScheduler.instance)
                .subscribe{ e in
                    switch e {
                    case .completed:
                        NSLog("SDK mode enabled")
                        self.sdkModeEnabled = true
                    case .error(let err):
                        NSLog("SDK mode enable failed: \(err)")
                    }
                }
        }
    }
    
    func sdkModeDisable() {
        if case .connected(let deviceId) = deviceConnectionState {
            _ = api.disableSDKMode(deviceId)
                .observe(on: MainScheduler.instance)
                .subscribe{ e in
                    switch e {
                    case .completed:
                        NSLog("SDK mode disabled")
                        self.sdkModeEnabled = false
                    case .error(let err):
                        NSLog("SDK mode disable failed: \(err)")
                    }
                }
        }
    }
}

// MARK: - PolarBleApiPowerStateObserver
extension PolarBleSdkManager: PolarBleApiPowerStateObserver {
    func blePowerOn() {
        bluetoothPowerOn = true
    }
    
    func blePowerOff() {
        bluetoothPowerOn = false
    }
}

// MARK: - PolarBleApiObserver
extension PolarBleSdkManager : PolarBleApiObserver {
    func deviceConnecting(_ polarDeviceInfo: PolarDeviceInfo) {
        NSLog("DEVICE CONNECTING: \(polarDeviceInfo)")
        deviceConnectionState = ConnectionState.connecting(polarDeviceInfo.deviceId)
    }
    
    func deviceConnected(_ polarDeviceInfo: PolarDeviceInfo) {
        NSLog("DEVICE CONNECTED: \(polarDeviceInfo)")
        deviceConnectionState = ConnectionState.connected(polarDeviceInfo.deviceId)
    }
    
    func deviceDisconnected(_ polarDeviceInfo: PolarDeviceInfo) {
        NSLog("DISCONNECTED: \(polarDeviceInfo)")
        deviceConnectionState = ConnectionState.disconnected
        self.sdkModeEnabled = false
    }
}

// MARK: - PolarBleApiDeviceInfoObserver
extension PolarBleSdkManager : PolarBleApiDeviceInfoObserver {
    func batteryLevelReceived(_ identifier: String, batteryLevel: UInt) {
        NSLog("battery level updated: \(batteryLevel)")
        self.battery = batteryLevel
    }
    
    func disInformationReceived(_ identifier: String, uuid: CBUUID, value: String) {
        NSLog("dis info: \(uuid.uuidString) value: \(value)")
    }
}

// MARK: - PolarBleApiSdkModeFeatureObserver
extension PolarBleSdkManager : PolarBleApiDeviceFeaturesObserver {
    func hrFeatureReady(_ identifier: String) {
        NSLog("HR ready")
    }
    
    func ftpFeatureReady(_ identifier: String) {
        NSLog("FTP ready")
    }
    
    func streamingFeaturesReady(_ identifier: String, streamingFeatures: Set<DeviceStreamingFeature>) {
        for feature in streamingFeatures {
            NSLog("Feature \(feature) is ready.")
        }
    }
}

// MARK: - PolarBleApiSdkModeFeatureObserver
extension PolarBleSdkManager : PolarBleApiSdkModeFeatureObserver {
    func sdkModeFeatureAvailable(_ identifier: String) {
        NSLog("SDK mode feature available. Device \(identifier)")
    }
}

// MARK: - PolarBleApiDeviceHrObserver
extension PolarBleSdkManager : PolarBleApiDeviceHrObserver {
    func hrValueReceived(_ identifier: String, data: PolarHrData) {
        if self.isRecording {
            self.hr.append(Double(data.hr))
            self.contact.append(data.contact)
        }
        //NSLog("(\(identifier)) HR value: \(data.hr) rrsMs: \(data.rrsMs) rrs: \(data.rrs) contact: \(data.contact) contact supported: \(data.contactSupported)")
    }
}

// MARK: - PolarBleApiLogger
extension PolarBleSdkManager : PolarBleApiLogger {
    func message(_ str: String) {
        //NSLog("Polar SDK log:  \(str)")
    }
}

extension PolarBleSdkManager {
    enum ConnectionState: Equatable {
        case disconnected
        case connecting(String)
        case connected(String)
    }
}
