//
//  ContentView.swift
//  fetchDeviceData
//
//  Created by RUMEN GUIN on 23/04/23.
//

import SwiftUI

struct Home: View {
    @StateObject private var vm = DeviceInfo()
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Device Info")) {
                    //MARK: - Full Device Name
                    HStack {
                        Text("Device Model")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(DeviceInfo.shared.deviceName)")
                            .fontWeight(.bold)
                    }
                    
                    //MARK: - Full iOS Version
                    HStack {
                        Text("iOS Version")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(DeviceInfo.shared.systemName) \(DeviceInfo.shared.systemVersion)")
                            .fontWeight(.bold)
                    }
                    
                    //MARK: - IMEI
                    
                    HStack {
                        Text("IMEI")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(DeviceInfo.shared.IMEI ?? "")")
                            .font(.footnote)
                    }
                }
                
                Section(header: Text("Battery Specs")) {
                    //MARK: - Battery Level
                    
                    HStack {
                        Text("Battery Level")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(vm.batteryLevel)")
                            .fontWeight(.bold)
                    }
                    //MARK: - Battery State
                    
                    HStack {
                        Text("Battery State")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(vm.batteryStateDescription)")
                            .fontWeight(.bold)
                    }
                }
                
                Section(header: Text("Internal Storage")) {
                    //MARK: - Total Disk Space
                    HStack {
                        Text("Total Storage")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(DeviceInfo.shared.totalDiskSpace)")
                            .fontWeight(.bold)
                    }
                    
                    //MARK: - Used Disk Space
                    HStack {
                        Text("Used Storage")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(DeviceInfo.shared.userDiskSpace)")
                            .fontWeight(.bold)
                    }
                    
                    //MARK: - Free Disk Space
                    HStack {
                        Text("Free Storage")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(DeviceInfo.shared.freeDiskSpace)")
                            .fontWeight(.bold)
                    }
                }
                
                //MARK: - CPU
                
                Section(header: Text("CPU and GPU Specs")) {
                    //MARK: - CPU Info
                    HStack {
                        Text("CPU")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(vm.cpu)")
                            .fontWeight(.bold)
                    }
                    
                    //MARK: - CPU Cores
                    HStack {
                        Text("CPU Cores")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(vm.cpuCore)")
                            .fontWeight(.bold)
                    }
                    
                    //MARK: - GPU
                    HStack {
                        Text("GPU")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        Spacer()
                        Text("\(vm.gpu)")
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("All specs")
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
