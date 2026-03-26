import SwiftUI

struct ProfilePageView: View {
    @EnvironmentObject var sessionCustomer: SessionCustomer
    @StateObject var viewModel = ProfilePageViewModel()
    @ObservedObject var networkMonitor = NetworkMonitor.shared
    @State var isDeleteAccountAlertPresented: Bool = false

    var body: some View {
        VStack {
            Divider()
            if !networkMonitor.isConnected {
                NoInternetText()
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // First Name & Middle Name
                    HStack(spacing: 14) {
                        VStack(alignment: .leading) {
                            Text("First Name")
                                .fontWeight(.medium)
                                .font(.system(size: 14))
                            TextField("First Name", text: $viewModel.firstName)
                                .padding(7)
                                .border(Color("Green"))
                        }

                        VStack(alignment: .leading) {
                            Text("Middle Name")
                                .fontWeight(.medium)
                                .font(.system(size: 14))
                            TextField("Middle Name", text: $viewModel.middleName)
                                .padding(7)
                                .border(Color("Green"))
                        }
                    }
                    .padding()

                    // Last Name
                    VStack(alignment: .leading) {
                        Text("Last Name")
                            .fontWeight(.medium)
                            .font(.system(size: 14))
                        TextField("Last Name", text: $viewModel.lastName)
                            .padding(7)
                            .border(Color("Green"))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)

                   

                    // Date of Birth
                    VStack(alignment: .leading) {
                        Text("Date of Birth")
                            .fontWeight(.medium)
                            .font(.system(size: 14))
                        DatePicker(
                            "",
                            selection: $viewModel.birthDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding(7)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color("Green"))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)

                    // Gender Picker
                    VStack(alignment: .leading) {
                        Text("Gender")
                            .fontWeight(.medium)
                            .font(.system(size: 14))
                        Menu {
                            ForEach(viewModel.genderOptions, id: \.self) { option in
                                Button(option) {
                                    viewModel.gender = option
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.gender.isEmpty ? "Select Gender" : viewModel.gender)
                                    .foregroundColor(viewModel.gender.isEmpty ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color("Green"))
                            }
                            .padding(7)
                            .frame(maxWidth: .infinity)
                            .border(Color("Green"))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)

                    // Population Group Picker
                    VStack(alignment: .leading) {
                        Text("Population Group")
                            .fontWeight(.medium)
                            .font(.system(size: 14))
                        Menu {
                            Button("None") {
                                viewModel.selectedPopulationGroupId = nil
                            }
                            ForEach(viewModel.populationGroups) { group in
                                Button(group.name) {
                                    viewModel.selectedPopulationGroupId = group.id
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedGroupName)
                                    .foregroundColor(viewModel.selectedPopulationGroupId == nil ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color("Green"))
                            }
                            .padding(7)
                            .frame(maxWidth: .infinity)
                            .border(Color("Green"))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)

                    // Prayer Cell Picker
                    VStack(alignment: .leading) {
                        Text("Prayer Cell")
                            .fontWeight(.medium)
                            .font(.system(size: 14))
                        Menu {
                            Button("None") {
                                viewModel.selectedPrayerCellId = nil
                            }
                            ForEach(viewModel.prayerCells) { cell in
                                Button(cell.name) {
                                    viewModel.selectedPrayerCellId = cell.id
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedPrayerCellName)
                                    .foregroundColor(viewModel.selectedPrayerCellId == nil ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color("Green"))
                            }
                            .padding(7)
                            .frame(maxWidth: .infinity)
                            .border(Color("Green"))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                    
                    // Email Address (Disabled)
                    VStack(alignment: .leading) {
                        Text("Email Address")
                            .fontWeight(.medium)
                            .font(.system(size: 14))

                        TextField("Email Address", text: $viewModel.email)
                            .padding(7)
                            .foregroundColor(Color.gray)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.gray)
                            .disabled(true)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)

                    // Phone Number (Disabled)
                    VStack(alignment: .leading) {
                        Text("Phone Number")
                            .fontWeight(.medium)
                            .font(.system(size: 14))
                        TextField("Phone Number", text: $viewModel.phoneNumber)
                            .padding(7)
                            .foregroundColor(Color.gray)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.gray)
                            .disabled(true)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }

                Spacer()

                HStack {
                    Button {
                        isDeleteAccountAlertPresented = true
                    } label: {
                        Text("DELETE ACCOUNT")
                            .fontWeight(.medium)
                            .font(.system(size: 14))
                            .foregroundColor(Color("Green"))
                    }
                    Spacer()
                }
                .padding()

                Button {
                    UIApplication.shared.endEditing()
                    viewModel.handleProfileUpdate()
                } label: {
                    Text("Save")
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .contentShape(Rectangle())
                }
                .background(Color("Green"))
                .cornerRadius(5)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBack(title: viewModel.titleText)
        .loadingOverlay(Binding(
            get: { viewModel.isLoading || viewModel.isLoadingDropdowns },
            set: { _ in }
        ))
        .errorAlert(error: $viewModel.error)
        .consolidatedAlertSheet()
        .alert(String(localized: "Delete Account"), isPresented: $isDeleteAccountAlertPresented) {
            Button(String(localized: "Delete"), role: .destructive) {

            }
            Button(String(localized: "Cancel"), role: .cancel) {
                isDeleteAccountAlertPresented = false
            }
        } message: {
            Text("Are you sure you want to delete your account? This cannot be undone.")
        }
        .onAppear {
            viewModel.loadData(customer: sessionCustomer.customer)
        }
    }

    private var selectedGroupName: String {
        if let id = viewModel.selectedPopulationGroupId,
           let group = viewModel.populationGroups.first(where: { $0.id == id }) {
            return group.name
        }
        return "Select Group"
    }

    private var selectedPrayerCellName: String {
        if let id = viewModel.selectedPrayerCellId,
           let cell = viewModel.prayerCells.first(where: { $0.id == id }) {
            return cell.name
        }
        return "Select Prayer Cell"
    }
}

#Preview {
    ProfilePageView()
}
