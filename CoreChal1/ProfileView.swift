import SwiftUI

struct ProfileView: View {
    @State private var name: String = "Carlo"
    @State private var age: String = "25"
    @State private var workingHoursStart = Date()
    @State private var workingHoursEnd = Date()
    @State private var restHoursStart = Date()
    @State private var restHoursEnd = Date()
    
    @State private var showingNotifications = false
    @State private var showingResearchStudies = false
    @State private var showingDevices = false
    @State private var showingApps = false
    
    @Environment(\.colorScheme) var colorScheme
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    init() {
        let calendar = Calendar.current
        let startComponents = DateComponents(hour: 9, minute: 0)
        let endComponents = DateComponents(hour: 17, minute: 0)
        _workingHoursStart = State(initialValue: calendar.date(from: startComponents) ?? Date())
        _workingHoursEnd = State(initialValue: calendar.date(from: endComponents) ?? Date())
        
        let restStartComponents = DateComponents(hour: 12, minute: 0)
        let restEndComponents = DateComponents(hour: 13, minute: 0)
        _restHoursStart = State(initialValue: calendar.date(from: restStartComponents) ?? Date())
        _restHoursEnd = State(initialValue: calendar.date(from: restEndComponents) ?? Date())
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Profile")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.leading, 15)
                
                Rectangle()
                    .frame(width: 320, height: 1.5)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.bottom, 5)
                    .padding(.top)
                
                List {
                    Section {
                        HStack {
                            Text("Name")
                                .foregroundColor(.white)
                            Spacer()
                            TextField("Name", text: $name)
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Age")
                                .foregroundColor(.white)
                            Spacer()
                            TextField("Age", text: $age)
                                .foregroundColor(.white.opacity(0.7))
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Working Hours")
                                .foregroundColor(.white)
                            Spacer()
                            HStack(spacing: 5) {
                                DatePicker("", selection: $workingHoursStart, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .accentColor(.blue)
                                    .colorInvert()
                                    .frame(width: 70)
                                Text("-")
                                    .foregroundColor(.white.opacity(0.7))
                                DatePicker("", selection: $workingHoursEnd, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .accentColor(.blue)
                                    .colorInvert()
                                    .frame(width: 70)
                            }
                        }
                        
                        HStack {
                            Text("Mandatory Rest Hours")
                                .foregroundColor(.white)
                            Spacer()
                            HStack(spacing: 5) {
                                DatePicker("", selection: $restHoursStart, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .accentColor(.blue)
                                    .colorInvert()
                                    .frame(width: 70)
                                Text("-")
                                    .foregroundColor(.white.opacity(0.7))
                                DatePicker("", selection: $restHoursEnd, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .accentColor(.blue)
                                    .colorInvert()
                                    .frame(width: 70)
                            }
                        }
                        
                        Button(action: {
                            showingNotifications = true
                        }) {
                            HStack {
                                Text("Notifications")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .listRowBackground(Color.black)
                    
                    Section(header: Text("Privacy")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .textCase(nil)
                    ) {
                        Button(action: {
                            showingApps = true
                        }) {
                            HStack {
                                Text("Apps")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Button(action: {
                            showingResearchStudies = true
                        }) {
                            HStack {
                                Text("Research Studies")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Button(action: {
                            showingDevices = true
                        }) {
                            HStack {
                                Text("Devices")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Text("Your data is encrypted on your device and can only be shared with your permission.")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 20)
                            .multilineTextAlignment(.leading)
                    }
                    .listRowBackground(Color.black)
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
                .foregroundColor(.white)
                
                // Existing sheets
                .sheet(isPresented: $showingNotifications) {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    showingNotifications = false
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .padding()
                                }
                            }
                            Text("Notifications View")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                }
                .sheet(isPresented: $showingResearchStudies) {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    showingResearchStudies = false
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .padding()
                                }
                            }
                            Text("Research Studies View")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                }
                .sheet(isPresented: $showingDevices) {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    showingDevices = false
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .padding()
                                }
                            }
                            Text("Devices View")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                }
                // Updated Apps sheet with additional text
                .sheet(isPresented: $showingApps) {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                        VStack(spacing: 20) {
                            HStack {
                                Spacer()
                                Button(action: {
                                    showingApps = false
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .padding()
                                }
                            }
                            Text("Apps Integrated")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            Text("Manage your connected applications here.")
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            Text("You can view, add, or remove apps that have access to your data.")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ProfileView()
}
