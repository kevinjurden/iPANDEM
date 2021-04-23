//
//  PreTestInformationView.swift
//  Personal Information collection and encryption for SalivaMAX testing
//
//  Created by Kevin Jurden on 3/15/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)

struct PreTestInformationView: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var emailAddress = ""
    @ObservedObject var phoneNumber = NumbersOnly()
    @State var birthdate = Date()
    @State var gender = ""
    @State var ethnicity = "Select A Ethnicity"
    @State var race = "Select A Race"
    @State var country = "Select A Country"
    @State var state = "Select A State"
    @State var streetAddress = ""
    @State var city = ""
    @State var zipcode = NumbersOnly()
    @Binding var showPreTest: Bool
    @Binding var showResults: Bool
    @State var showPreTestContinued = false
    
    @State var cantContinue = false
    @State var isExpanded = false
    @State var selectedNum = 0
    
    let db = Firestore.firestore()
    
    var body: some View {
        ZStack {
            ScrollView {
                if !self.showPreTestContinued {
                    Group {
                        HelloText()
                        FirstNameText(firstName: $firstName)
                        LastNameText(lastName: $lastName)
                        EmailAddressText(emailAddress: $emailAddress)
                        PhonenumberText(phoneNumber: $phoneNumber.value)
                    }
                    Group {
                        DatePicker("Birthdate:", selection: $birthdate, in: ...Date(), displayedComponents: .date)
                            .padding(.bottom, 20)
                            .font(.headline)
                        EthnicityDropDown(selectedEthnicity: $ethnicity)
                        RaceDropDown(selectedRace: $race)
                        GenderButtons(gender: $gender)
                    }
                
                    if cantContinue {
                        Text("Oh snap! Looks like you forgot something...")
                            .foregroundColor(Color(.systemRed))
                    }
                    Button(action: {
                        if self.firstName == "" || self.lastName == "" || gender == "" || race == "Select A Race" || ethnicity == "Select A Ethnicity" || phoneNumber.value == "" ||   !textFieldValidatorEmail(self.emailAddress) {
                            cantContinue = true
                        } else {
                            cantContinue = false
                            self.showPreTestContinued = true
                        }
                    }) {
                        ContinueButtonContent()
                    }.padding(.bottom, 10)
                    Spacer()
                } else {
                    Group {
                        HelloText()
                        //Add multiple countries
                        CountryDropDown(selectedCountry: $country)
                        //State can't be selected until Country is
                        StateDropDown(selectedState: $state)
                        CityText(city: $city)
                        StreetAddressText(streetAddress: $streetAddress)
                        ZipcodeText(zipcode: $zipcode.value)
                    }
                    
                    if cantContinue {
                        Text("Oh snap! Looks like you forgot something...")
                            .foregroundColor(Color(.systemRed))
                    }
                    Text("By clicking continue you are electronically consenting & agreeing to our terms and conditions. You are also stating that prior to taking your test you have been given a copy of the Emergency Use Authorization (EUA) and reviewed it along with being given ample time to ask questions. You also understand the benefits and risks of taking the test and using our software. I also certify that I am the one using this software and taking the provided test.")
                        .font(.system(size: 8))
                        .foregroundColor(Color.black)
                    Button(action: {
                        if country == "Select A Country" || state == "Select A State" || city == "" || streetAddress == "" || zipcode.value == "" {
                            cantContinue = true
                        } else {
                            db.collection("consent").addDocument(data: ["name":(firstName + " " + lastName), "email":emailAddress,"phone":phoneNumber.value,"gender":gender,"race":race,"ethnicity":ethnicity,"birthdate":birthdate,"country":country,"state":state,"city":city,"address":streetAddress,"zip":zipcode.value])
                            self.showResults = true
                            self.showPreTest = false
                            self.showPreTestContinued = false
                        }
                    }) {
                        ResultsButtonContent()
                    }
                    Spacer()

                }
            }
            .padding()
        }
    }
}


func textFieldValidatorEmail(_ string: String) -> Bool {
    if string.count > 100 {
        return false
    }
    let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: string)
}

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter {$0.isNumber}
            
            if value != filtered {
                value = filtered
            }
        }
    }
}

struct HelloText: View {
    var body: some View {
        Text("Tell us about yourself!")
            .font(.system(size: 500))
            .fontWeight(.semibold)
            .padding(20)
            .lineLimit(1)
            .minimumScaleFactor(0.01)
    }
}

struct ContinueButtonContent: View {
    var body: some View {
        Text("CONTINUE")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.black)
            .cornerRadius(35.0)
    }
}


struct FirstNameText: View {
    @Binding var firstName: String
    
    var body: some View {
        TextField("First Name", text: $firstName)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .disableAutocorrection(true)
    }
}

struct LastNameText: View {
    @Binding var lastName: String
    
    var body: some View {
        TextField("Last Name", text: $lastName)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .disableAutocorrection(true)    }
}

struct EmailAddressText: View {
    @Binding var emailAddress: String
    
    var body: some View {
        TextField("Email Address", text: $emailAddress)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .disableAutocorrection(true)
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
    }
}

struct PhonenumberText: View {
    @Binding var phoneNumber: String
    
    var body: some View {
        TextField("Phone Number", text: $phoneNumber)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .disableAutocorrection(true)
            .keyboardType(.decimalPad)
    }
}

struct PreTestInformationView_Previews: PreviewProvider {
    @State static var showPreTest = true
    @State static var showResults = false
    
    static var previews: some View {
        PreTestInformationView(showPreTest: $showPreTest, showResults: $showResults)
    }
}

struct GenderButtons: View {
    @Binding var gender: String
    
    var body: some View {
        HStack {
            Text("Sex:")
                .font(.headline)
            Spacer()
            RadioButtonGroups {
                selected in self.gender = selected
            }
        }
        .padding(.bottom, 20)
    }
}

struct EthnicityDropDown: View {
    let ethnicities = ["None", "Mexican", "Puerto Rican", "Cuban", "Another Hispanic"]
    @State var isExpanded = false
    @Binding var selectedEthnicity: String
    
    
    var body: some View {
        HStack {
            Text("Ethnicity: ")
                .font(.headline)
            DisclosureGroup(isExpanded: $isExpanded) {
                ScrollView {
                    VStack {
                        ForEach(ethnicities, id: \.self) { ethnicity in
                            Text("\(ethnicity)")
                                .frame(maxWidth: .infinity)
                                .font(.title3)
                                .onTapGesture {
                                    self.selectedEthnicity = ethnicity
                                    withAnimation {
                                        self.isExpanded.toggle()
                                    }
                                }
                        }
                    }
                }.frame(height: 100)
            } label: {
                Label("\(selectedEthnicity)", systemImage: "")
                    .onTapGesture {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                    }
            }
            .font(.title2)
            .foregroundColor(.black)
            .padding(.all)
            .background(lightGreyColor)
            .cornerRadius(8.0)
        }.padding(.bottom, 20)
    }
}

struct RaceDropDown: View {
    let races = ["White", "Black or African American", "American Indian or Alaska Native", "Asian Indian", "Chinese", "Filipino", "Japanese", "Korean", "Vietnamese", "Other Asian", "Native Hawaiian", "Guamanian or Chamorro", "Samoan", "Other Pacific Islander"]
    @State var isExpanded = false
    @Binding var selectedRace: String
    
    
    var body: some View {
        HStack {
            Text("Race: ")
                .font(.headline)
            DisclosureGroup(isExpanded: $isExpanded) {
                ScrollView {
                    VStack {
                        ForEach(races, id: \.self) { race in
                            Text("\(race)")
                                .frame(maxWidth: .infinity)
                                .font(.title3)
                                .onTapGesture {
                                    self.selectedRace = race
                                    withAnimation {
                                        self.isExpanded.toggle()
                                    }
                                }
                        }
                    }
                }.frame(height: 100)
            } label: {
                Label("\(selectedRace)", systemImage: "")
                    .onTapGesture {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                    }
            }
            .font(.title2)
            .foregroundColor(.black)
            .padding(.all)
            .background(lightGreyColor)
            .cornerRadius(8.0)
        }.padding(.bottom, 20)
    }
}

struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (String)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        textSize: CGFloat = 14,
        isMarked: Bool = false,
        callback: @escaping (String)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label)
                    .font(Font.system(size: textSize))
            }.foregroundColor(self.color).padding(.horizontal, 10)
        }
        .foregroundColor(Color.white)
    }
}

enum Gender: String {
    case male = "Male"
    case female = "Female"
}

struct RadioButtonGroups: View {
    let callback: (String) -> ()
    
    @State var selectedId: String = ""
    
    var body: some View {
        HStack {
            radioMaleMajority
            radioFemaleMajority
        }
    }
    
    var radioMaleMajority: some View {
        RadioButtonField(
            id: Gender.male.rawValue,
            label: Gender.male.rawValue,
            isMarked: selectedId == Gender.male.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioFemaleMajority: some View {
        RadioButtonField(
            id: Gender.female.rawValue,
            label: Gender.female.rawValue,
            isMarked: selectedId == Gender.female.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}

struct CountryDropDown: View {
    let countries = ["United States"]
    @State var isExpanded = false
    @Binding var selectedCountry: String
    
    
    var body: some View {
        HStack {
            Text("Country: ")
                .font(.headline)
            DisclosureGroup(isExpanded: $isExpanded) {
                ScrollView {
                    VStack {
                        ForEach(countries, id: \.self) { country in
                            Text("\(country)")
                                .frame(maxWidth: .infinity)
                                .font(.title3)
                                .onTapGesture {
                                    self.selectedCountry = country
                                    withAnimation {
                                        self.isExpanded.toggle()
                                    }
                                }
                        }
                    }
                }.frame(height: 100)
            } label: {
                Label("\(selectedCountry)", systemImage: "")
                    .onTapGesture {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                    }
            }
            .font(.title2)
            .foregroundColor(.black)
            .padding(.all)
            .background(lightGreyColor)
            .cornerRadius(8.0)
        }.padding(.bottom, 20)
    }
}

struct StateDropDown: View {
    let states = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachussetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virgina", "Washington", "West Vigina", "Wisconsin", "Wyoming"]
    @State var isExpanded = false
    @Binding var selectedState: String
    
    
    var body: some View {
        HStack {
            Text("State: ")
                .font(.headline)
            DisclosureGroup(isExpanded: $isExpanded) {
                ScrollView {
                    VStack {
                        ForEach(states, id: \.self) { state in
                            Text("\(state)")
                                .frame(maxWidth: .infinity)
                                .font(.title3)
                                .onTapGesture {
                                    self.selectedState = state
                                    withAnimation {
                                        self.isExpanded.toggle()
                                    }
                                }
                        }
                    }
                }.frame(height: 100)
            } label: {
                Label("\(selectedState)", systemImage: "")
                    .onTapGesture {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                    }
            }
            .font(.title2)
            .foregroundColor(.black)
            .padding(.all)
            .background(lightGreyColor)
            .cornerRadius(8.0)
        }.padding(.bottom, 20)
    }
}

struct CityText: View {
    @Binding var city: String
    
    var body: some View {
        TextField("City", text: $city)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .disableAutocorrection(true)
    }
}

struct StreetAddressText: View {
    @Binding var streetAddress: String
    
    var body: some View {
        TextField("Street Address", text: $streetAddress)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .disableAutocorrection(true)
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
    }
}

struct ZipcodeText: View {
    @Binding var zipcode: String
    
    var body: some View {
        TextField("Zip Code", text: $zipcode)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .keyboardType(.decimalPad)
    }
}

struct ResultsButtonContent: View {
    var body: some View {
        Text("CONTINUE")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 180, height: 60)
            .background(Color.black)
            .cornerRadius(35.0)
    }
}

