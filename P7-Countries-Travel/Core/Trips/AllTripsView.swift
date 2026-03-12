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
    @Binding var path: [Route]
    @State var animate: Bool = false
    
    var body: some View {
        
        if vm.isLoading {
            ProgressView()
        } else if vm.trips.isEmpty {
            VStack {
                Spacer()
                ZStack {
                    Text("You not going anywhere? Sucks!")
                    ZStack {
                        Button {
                            path.append(.selectCountry)
                        } label: {
                            Text("New Trip")
                                .foregroundStyle(Color.white)
                                .frame(width: 130, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 120, height: 40)
                                        .shadow(color: .black.opacity(0.3), radius: 5, y: 10)
                                        .foregroundStyle(
                                            Gradient(colors: [.red, .orange])
                                        )
                                )
                                .scaleEffect(animate ? 1.3 : 1.5)
                                .animation(
                                    Animation.easeInOut(duration: 1.2)
                                        .repeatForever(autoreverses: true),
                                    value: animate
                                )
                        }
                        .offset(x: 0, y: 60)
                    }
                    
                } // End ZStack
                .onAppear {
                    animate.toggle()
                }
                Spacer()
                Spacer()
            } // End VStack

        } else {
            ScrollView {
                VStack(spacing: 50) {
                    ForEach(vm.trips) { trip in
                        TripListItemView(tripEntity: trip, vm: vm)
                            .onTapGesture {
                                self.selectedTrip = trip
                            }
                    }
                } // End VStack
                .frame(maxWidth: .infinity)
                .padding(.top, 50)
                .sheet(item: $selectedTrip) { trip in
                    TripDetailView(tripEntity: trip, vm: vm, selectedTrip: $selectedTrip)
                }
            } // End ScrollView
            .safeAreaPadding(.bottom, 120)
            .navigationTitle("All Trips")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Add") {
                        path.append(.selectCountry)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)

                }
                
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
        AllTripsView(path: .constant([]))
    }
}
