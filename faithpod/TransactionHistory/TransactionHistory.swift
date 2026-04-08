import SwiftUI

struct TransactionHistory: View {
    @StateObject var viewModel = TransactionHistoryViewModel()
    
    @State private var showDatePicker = false
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
    @State private var endDate = Date()
    
    var filteredContributions: [ContributionHistory] {
        viewModel.transactionHistory.filter { item in
            guard let date = item.contributionDate.toDate() else { return false }
            return date >= startDate && date <= endDate
        }
        .sorted {
            ($0.contributionDate.toDate() ?? .distantPast) >
            ($1.contributionDate.toDate() ?? .distantPast)
        }
    }
    
    var totalAmount: Double {
        filteredContributions.compactMap { $0.contributionAmount }.reduce(0, +)
    }
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.easeInOut) {
                    showDatePicker.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(Color("Green"))
                    Text("Select date range")
                        .foregroundColor(Color("Green"))
                    Spacer()
                    Image(systemName: showDatePicker ? "chevron.up" : "chevron.down")
                        .rotationEffect(.degrees(showDatePicker ? 180 : 0))
                        .animation(.easeInOut, value: showDatePicker)
                        .foregroundColor(Color("Green"))
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding([.horizontal, .top])
            
            if showDatePicker {
                VStack(spacing: 8) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                .padding(.horizontal)
                .animation(.easeInOut, value: showDatePicker)

            }
            
            // Contribution List
            if filteredContributions.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("No transaction made yet!")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                Spacer()
            } else {
                List {
                    ForEach(filteredContributions) { item in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Ksh \(item.contributionAmount, specifier: "%.2f")")
                                    .font(.headline)

                                Text(item.contributionType.name ?? "Unknown Type")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()

                            Text(item.contributionDate.toFormattedDisplay())
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            // Total Summary
            HStack {
                Spacer()
                Text("Total Contributions: ")
                Text("Ksh \(totalAmount, specifier: "%.2f")")
                Spacer()
            }
            .bold()
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationBarBack(title:"Transaction History")
        .loadingOverlay($viewModel.isLoading)
    }
}
