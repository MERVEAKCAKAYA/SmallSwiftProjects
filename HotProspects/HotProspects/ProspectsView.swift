//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Merve Akçakaya on 16.06.2026.
//

import SwiftUI
import SwiftData
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType{
        case none, contacted, uncontacted
    }
    
    @Environment(\.modelContext) var modelContext
    @Query(sort:\Prospect.name) var prospects : [Prospect]
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted"
        case .uncontacted:
            return "Uncontacted"
        }
    }
    var body: some View {
        NavigationStack{
            List(prospects, selection: $selectedProspects){prospect in
                VStack(alignment:.leading){
                    Text(prospect.name).font(.headline)
                    Text(prospect.emailAddress).foregroundStyle(.secondary)
                }.swipeActions{
                    Button("Delete", systemImage: "trash", role:.destructive){
                        modelContext.delete(prospect)
                    }
                    if prospect.isContacted{
                        Button("Mark UnContancted",systemImage: "person.crop.circle.badge.xmark"){
                            prospect.isContacted.toggle()
                        }.tint(.blue)
                    }
                    else{
                        Button("Mark Contancted",systemImage: "person.crop.circle.badge.checkmark"){
                            prospect.isContacted.toggle()
                        }.tint(.green)
                        
                        Button("Remind me", systemImage: "bell"){
                            addNotification(for: prospect)
                        }.tint(.orange)
                    }
                }
                .tag(prospect)
            
            }
                .navigationTitle(title)
                
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Scan", systemImage: "qrcode.viewfinder"){
                            isShowingScanner = true
                            
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading){
                        EditButton()
                    }
                    //list öğesinden birine tıkladığım anda delete butonu ekranın altında görünüyor.
                    if selectedProspects.isEmpty == false{
                        ToolbarItem(placement: .bottomBar){
                            Button("Delete Selected", action: delete)
                        }
                    }
                }
                .sheet(isPresented: $isShowingScanner){
                    CodeScannerView(codeTypes: [.qr], simulatedData: "merveakcakaya\nswiftui", completion: handleScan)
                }
        }
    }
    func delete(){
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
       
    func addNotification(for prospect: Prospect){
        let center = UNUserNotificationCenter.current()
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = "\(prospect.emailAddress)"
            content.sound = UNNotificationSound.default
//            
//            var dateComponents = DateComponents()
//            dateComponents.hour = 9
//            
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
                    if success{
                        addRequest()
                    }else if let error{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    
    //bu func Result tipinde değer döndürüyor. başarı ise ScanResult, başarısız ise ScanError döner
    func handleScan(result: Result<ScanResult, ScanError>){
        isShowingScanner = false
        switch result{
            //tarama başarılı ise
        case .success(let result):
            //qr kod içerisindeki değer isim\n email olduğu için bunu ayırıp modelContext'e ekliyoruz.
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else {return}
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
            
            //tarama başarısız ise
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
    
    init(filter: FilterType){
        self.filter = filter
        //filter = .none ise zaten bir şey yapma normal sorted kullan.
        if filter != .none {
            //bool döner. filter .contacted ise true, değil ise false döner
            let showContactedOnly = filter == .contacted
            
            _prospects = Query(filter: #Predicate{
                $0.isContacted == showContactedOnly //listenin ilk nesnesinin isContacted değeri istediğimiz gibiyse devam et
            }, sort: [SortDescriptor(\Prospect.name)])
        }
    }
}

#Preview {
    ProspectsView(filter: .none).modelContainer(for:Prospect.self)
}
