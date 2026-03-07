//
//  AllTripsView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/2/26.
//

import SwiftUI

struct AllTripsView: View {
    
    @StateObject var vm = AllTripsViewModel()
    @State var selectedTrip: TripEntity?
    
    
    var body: some View {
        
        if vm.trips.isEmpty {
            Text("You not going anywhere? Sucks!")
        } else {
            ScrollView {
                VStack(spacing: 50) {
                    ForEach(vm.trips) { trip in
                        
                        TripListItemView(tripEntity: trip, vm: vm)
                            .onTapGesture {
                                self.selectedTrip = trip
                            }
                        
                        //                VStack(alignment: .leading) {
                        //                    Text(trip.tripCountry ?? "")
                        //                    Text(trip.tripCity ?? "")
                        //                    Text(trip.tripImageURL ?? "")
                        //                    Text(trip.tripDesc ?? "")
                        //                    if let key = trip.tripCountry,
                        //                       let image = CacheManager.instance.get(key: key) {
                        //                        Image(uiImage: image)
                        //                            .resizable()
                        //                            .scaledToFit()
                        //                            .frame(height: 200)
                        //                    }
                        //                }
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 50)
                .sheet(item: $selectedTrip) { trip in
                    TripDetailView(tripEntity: trip, vm: vm, selectedTrip: $selectedTrip)
                }
            }
            .navigationTitle("All Trips")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        vm.clearAllTripsFromCoreData()
                        vm.clearAllTripImages()
                    }
                }
            }
            .onAppear {
                vm.loopThroughAllTripEntities()
            }
            
        }
    } // end if else

}

#Preview {
    NavigationStack {
        AllTripsView()
    }
}
