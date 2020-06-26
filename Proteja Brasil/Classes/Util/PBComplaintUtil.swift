//
//  PBComplaintUtil.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 17/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import OAStackView
import ObjectMapper
import AddressBookUI

enum PBComplaintType: String {
    case noAccessibility = "Accessibility"
    case internetCrime = "InternetCrime"
    case violation = "Violation"
    
    func trackName() -> String {
        switch self {
        case .noAccessibility:
            return "No accessibility"
        case .internetCrime:
            return "Internet crime"
        case .violation:
            return "Violation"
        }
    }
    
    func category() -> String {
        return self.trackName() + " report"
    }
}

protocol PBComplaintElementProtocol {
    var apiKey: String? { get }
    var isRequired: Bool! { get }
    func getData() -> (key: String, value: Any)?
    func isValid() -> Bool
}

class PBKeyValue {
    var key: String {
        didSet {
            self.apiKey = self.key
        }
    }
    var value: Any?
    var apiKey: String?
    
    init(key: String, value: Any? = nil) {
        self.key = key
        self.apiKey = key
        self.value = value
    }
    
}

extension PBKeyValue: PBComplaintElementProtocol {
    
    var isRequired: Bool! {
        return false
    }
    
    func getData() -> (key: String, value: Any)? {
        if let apiKey = self.apiKey, let value = self.value {
            return (key: apiKey, value: value)
        }
        return nil
    }
    
    func isValid() -> Bool {
        return true
    }
}

private func loadCities() {
    if cities.count == 0 {
        let path = Bundle.main.path(forResource: "cities", ofType: "json")!
        let citiesJSONString = try! String(contentsOfFile: path)
        let allCities = Mapper<PBCityModel>().mapArray(JSONString: citiesJSONString)!
        cities.append(contentsOf: allCities)
    }
}

private func citiesFromState(state: String) -> [PBCityModel] {
    return cities.filter({ $0.state == state }).sorted(by: { (city1, city2) -> Bool in
        city1.name.localizedCaseInsensitiveCompare(city2.name) == .orderedAscending
    })
}

func createComplaintViewController(forType type: PBComplaintType) -> PBComplaintStepViewController {
    let complaintSteps = configureComplant(forType: type)
    let stepViewController = PBComplaintStepViewController()
    stepViewController.steps = complaintSteps
    stepViewController.step = 0
    stepViewController.complaintType = type
    return stepViewController
}

func configureComplant(forType type: PBComplaintType) -> [PBComplaintStep] {
    var complaint = [PBComplaintStep]()
    if type == .violation {
        //complaint.append(createStep0ForViolation())
        complaint.append(createStep1ForViolation())
        complaint.append(createStep2ForViolation())
        complaint.append(createStep3ForViolation())
        complaint.append(createStep4ForViolation())
        complaint.append(createStep5ForViolation())
        complaint.append(createStep6ForViolation())
        complaint.append(createStep7ForViolation())
        complaint.append(createStep8ForViolation())
        complaint.append(createStep9ForViolation())
        complaint.append(createStep10ForViolation())
        complaint.append(createStep11ForViolation())
    } else if type == .internetCrime {
        complaint.append(createInternetCrimeStep())
    } else if type == .noAccessibility {
        complaint.append(createNoAccessibilityStep1())
        complaint.append(createNoAccessibilityStep2())
        complaint.append(createNoAccessibilityStep2_1())
        complaint.append(createNoAccessibilityStep3())
        complaint.append(createNoAccessibilityStep4())
        complaint.append(createNoAccessibilityStep5())
    }
    return complaint
}

private func createStackView(elements: [UIView], horizontal: Bool = false) -> OAStackView {
    let stackView = OAStackView(arrangedSubviews: elements)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    if horizontal {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 30
    } else {
        stackView.axis = .vertical
        stackView.spacing = 25
    }
    return stackView
}

private func createStep0ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    title1.lbTitle.text = "A violação está acontecendo agora?"
    
    let radioButton1 = PBRadioButtonComplaintElement.loadView()
    radioButton1.button.setTitle("Sim", for: .normal)
    radioButton1.button.isSelected = true
    let radioButton2 = PBRadioButtonComplaintElement.loadView()
    radioButton2.button.setTitle("Não", for: .normal)
    
    radioButton1.didSelectedClosure = {
        radioButton2.button.isSelected = false
    }
    radioButton2.didSelectedClosure = {
        radioButton1.button.isSelected = false
    }
    
    let radioStackView = createStackView(elements: [radioButton1, radioButton2], horizontal: true)
    
    let stackView = createStackView(elements: [
        title1,
        radioStackView
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        radioButton1, radioButton2
        ])
}

private func createStep1ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionTheme
    title1.setText(text: title1Text, obligatory: true)

    let themeDesc = PBKeyValue(key: "des_violacao")

    let themeSelector = PBThemeSelectorElement.loadView()
    themeSelector.apiKey = "violacao"

    var title2 = PBTitleComplaintElement.loadView()
    var title2Text = L10n.titleQuestionRacialSubtype
    title2.setText(text: title2Text, obligatory: true)
    title2.isHidden = true

    var selector2 = PBOptionSelectorComplaintElement.loadView()
    let selector2Text0: String = NSLocalizedString("select_an_option", tableName: "Report", comment: "")
    let selector2Text1: String = NSLocalizedString("racial_subtype1", tableName: "Report", comment: "")
    let selector2Text2: String = NSLocalizedString("racial_subtype2", tableName: "Report", comment: "")
    let selector2Text3: String = NSLocalizedString("racial_subtype3", tableName: "Report", comment: "")
    let selector2Text4: String = NSLocalizedString("racial_subtype4", tableName: "Report", comment: "")
    let selector2Text5: String = NSLocalizedString("racial_subtype5", tableName: "Report", comment: "")
    let selector2Text6: String = NSLocalizedString("racial_subtype6", tableName: "Report", comment: "")
    selector2.isHidden = true
    selector2.isRequired = true
    selector2.apiKey = "subtipoviolacao"
    selector2.options = [
        PBKeyValue(key: selector2Text0),
        PBKeyValue(key: selector2Text1, value: "1"),
        PBKeyValue(key: selector2Text2, value: "2"),
        PBKeyValue(key: selector2Text3, value: "3"),
        PBKeyValue(key: selector2Text4, value: "4"),
        PBKeyValue(key: selector2Text5, value: "5"),
        PBKeyValue(key: selector2Text6, value: "6")
    ]

    let subThemeDesc = PBKeyValue(key: "des_subtipoviolacao")

    themeSelector.didSelectedClosure = { theme in
        themeDesc.value = theme.title
        if theme.sondhaId == 9 || theme.sondhaId == 774 {
            if theme.sondhaId == 9 {
                selector2 = getRacialTypes(selector2)
                title2Text = L10n.titleQuestionRacialSubtype
                title2.setText(text: title2Text, obligatory: true)
            } else if theme.sondhaId == 774 {
                selector2 = getWomenViolenceTypes(selector2)
                title2Text = L10n.titleQuestionViolenceAgainstWomenSubtype
                title2.setText(text: title2Text, obligatory: true)
            }
            title2.isHidden = false
            selector2.isHidden = false
            selector2.apiKey = "subtipoviolacao"
            selector2.selectRow(row: 0)
        } else {
            title2.isHidden = true
            selector2.isHidden = true
            selector2.apiKey = nil
            subThemeDesc.value = nil
        }
    }

    selector2.didSelectedOptionClosure = { option in
        subThemeDesc.value = option.key
    }

    let stackViewStep2 = createStackView(elements: [
        title1, themeSelector,
        title2, selector2
        ])
    return PBComplaintStep(stackView: stackViewStep2, elements: [
        themeSelector, themeDesc, selector2, subThemeDesc
        ], hasObligatoryFields: true)
}

private func getRacialTypes(_ selector2: PBOptionSelectorComplaintElement) -> PBOptionSelectorComplaintElement {

    var selector2Text0: String
    var selector2Text1: String
    var selector2Text2: String
    var selector2Text3: String
    var selector2Text4: String
    var selector2Text5: String
    var selector2Text6: String

    selector2Text0 = NSLocalizedString("select_an_option", tableName: "Report", comment: "")
    selector2Text1 = NSLocalizedString("racial_subtype1", tableName: "Report", comment: "")
    selector2Text2 = NSLocalizedString("racial_subtype2", tableName: "Report", comment: "")
    selector2Text3 = NSLocalizedString("racial_subtype3", tableName: "Report", comment: "")
    selector2Text4 = NSLocalizedString("racial_subtype4", tableName: "Report", comment: "")
    selector2Text5 = NSLocalizedString("racial_subtype5", tableName: "Report", comment: "")
    selector2Text6 = NSLocalizedString("racial_subtype6", tableName: "Report", comment: "")

    selector2.options = [
        PBKeyValue(key: selector2Text0),
        PBKeyValue(key: selector2Text1, value: "1"),
        PBKeyValue(key: selector2Text2, value: "2"),
        PBKeyValue(key: selector2Text3, value: "3"),
        PBKeyValue(key: selector2Text4, value: "4"),
        PBKeyValue(key: selector2Text5, value: "5"),
        PBKeyValue(key: selector2Text6, value: "6")
    ]
    return selector2
}

private func getWomenViolenceTypes(_ selector2: PBOptionSelectorComplaintElement) -> PBOptionSelectorComplaintElement {

    let optionLabels = [
        NSLocalizedString("domestic_and_familiar_violence", tableName: "Report", comment: ""),
        NSLocalizedString("intimidation", tableName: "Report", comment: ""),
        NSLocalizedString("feminicide", tableName: "Report", comment: ""),
        NSLocalizedString("women_trade", tableName: "Report", comment: ""),
        NSLocalizedString("false_imprisonment", tableName: "Report", comment: ""),
        NSLocalizedString("violence_against_religious_diversity", tableName: "Report", comment: ""),
        NSLocalizedString("violence_on_sports", tableName: "Report", comment: ""),
        NSLocalizedString("homicide", tableName: "Report", comment: ""),
        NSLocalizedString("institutional_violence", tableName: "Report", comment: ""),
        NSLocalizedString("physical_violence", tableName: "Report", comment: ""),
        NSLocalizedString("moral_violence", tableName: "Report", comment: ""),
        NSLocalizedString("police_violence", tableName: "Report", comment: ""),
        NSLocalizedString("obstetrical_violence", tableName: "Report", comment: ""),
        NSLocalizedString("sexual_violence", tableName: "Report", comment: ""),
        NSLocalizedString("virtual_violence", tableName: "Report", comment: ""),
        NSLocalizedString("slave_work", tableName: "Report", comment: ""),
        NSLocalizedString("other_entries", tableName: "Report", comment: "")]

    var options = optionLabels.enumerated().map {
        PBKeyValue(key: $0.element, value: "\($0.offset+1)")
    }

    options.insert(PBKeyValue(key: NSLocalizedString("select_an_option", tableName: "Report", comment: "")), at: 0)

    selector2.options = options
    return selector2
}

private func createStep2ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionVictimInfo
    title1.setText(text: title1Text, obligatory: true)
    
    let textField1 = PBTextFieldComplaintElement.loadView()
    textField1.isRequired = true
    textField1.placeholder = L10n.hintVictimName
    textField1.apiKey = "nome_vitima"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionVictimLocationDescription
    title2.setText(text: title2Text, obligatory: true)
    
    let textField2 = PBTextFieldComplaintElement.loadView()
    textField2.placeholder = L10n.hintVictimLocationDescription
    textField2.isRequired = true
    textField2.apiKey = "localizacao_vitima"
    
    textField1.returnKeyType = .next
    textField1.returnClosure = {
        _ = textField2.becomeFirstResponder()
    }
    
    let stackViewStep2 = createStackView(elements: [
        title1, textField1,
        title2, textField2,
        ])
    return PBComplaintStep(stackView: stackViewStep2, elements: [
        textField1, textField2
        ], hasObligatoryFields: true)
}

private let states = [
    PBKeyValue(key: L10n.spinnerDefaultStateText),
    PBKeyValue(key: "Acre", value: "AC"),
    PBKeyValue(key: "Alagoas", value: "AL"),
    PBKeyValue(key: "Amapá", value: "AP"),
    PBKeyValue(key: "Amazonas", value: "AM"),
    PBKeyValue(key: "Bahia", value: "BA"),
    PBKeyValue(key: "Ceará", value: "CE"),
    PBKeyValue(key: "Distrito Federal", value: "DF"),
    PBKeyValue(key: "Espírito Santo", value: "ES"),
    PBKeyValue(key: "Goiás", value: "GO"),
    PBKeyValue(key: "Maranhão", value: "MA"),
    PBKeyValue(key: "Mato Grosso", value: "MT"),
    PBKeyValue(key: "Mato Grosso do Sul", value: "MS"),
    PBKeyValue(key: "Minas Gerais", value: "MG"),
    PBKeyValue(key: "Pará", value: "PA"),
    PBKeyValue(key: "Paraíba", value: "PB"),
    PBKeyValue(key: "Paraná", value: "PR"),
    PBKeyValue(key: "Pernambuco", value: "PE"),
    PBKeyValue(key: "Piauí", value: "PI"),
    PBKeyValue(key: "Rio de Janeiro", value: "RJ"),
    PBKeyValue(key: "Rio Grande do Norte", value: "RN"),
    PBKeyValue(key: "Rio Grande do Sul", value: "RS"),
    PBKeyValue(key: "Rondônia", value: "RO"),
    PBKeyValue(key: "Roraima", value: "RR"),
    PBKeyValue(key: "Santa Catarina", value: "SC"),
    PBKeyValue(key: "São Paulo", value: "SP"),
    PBKeyValue(key: "Sergipe", value: "SE"),
    PBKeyValue(key: "Tocantins", value: "TO"),
]
private var cities = [PBCityModel]()
private let queue = DispatchQueue(label: "Load cities")

private func createStep3ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionVictimLocation
    title1.setText(text: title1Text, obligatory: true)
    
    let radioButton1 = PBRadioButtonComplaintElement.loadView()
    radioButton1.selected = true
    radioButton1.title = L10n.hintMyLocation
    let radioButton3 = PBRadioButtonComplaintElement.loadView()
    radioButton3.title = L10n.hintFillAddress
    
    let radioStackView = createStackView(elements: [
        radioButton1, radioButton3
        ], horizontal: true)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    selector1.isHidden = true
    selector1.isRequired = true
    selector1.options = states
    selector1.apiKey = "uf_vitima"
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    selector2.isHidden = true
    selector2.isRequired = true
    let selector2Option0: String = L10n.spinnerDefaultCityText
    selector2.options = [
        PBKeyValue(key: selector2Option0)
    ]
    selector2.apiKey = "cidade_vitima"
    
    queue.async() {
        loadCities()
    }
    
    selector1.didSelectedOptionClosure = { keyValue in
        var options = [PBKeyValue(key: selector2Option0)]
        if let state = keyValue.value as? String {
            let filtered = cities.filter({ city in
                city.state == state
            }).sorted(by: { (city1, city2) -> Bool in
                city1.name.localizedCaseInsensitiveCompare(city2.name) == .orderedAscending
            })
            options.removeAll()
            for city in filtered {
                options.append(PBKeyValue(key: city.name, value: city.name))
            }
        }
        selector2.options = options
        selector2.retractOptions()
    }
    
    let textField1 = PBTextFieldComplaintElement.loadView()
    textField1.isHidden = true
    textField1.isRequired = true
    textField1.apiKey = "endereco_vitima"
    
    radioButton1.didSelectedClosure = {
        radioButton3.selected = false
        selector1.isHidden = true
        selector2.isHidden = true
        textField1.isHidden = true
        textField1.window?.layoutIfNeeded()
        
        if let placemark = PBLocationManager.sharedInstance().currentPlacemark,
            let state = placemark.addressDictionary?[kABPersonAddressStateKey] as? String,
            let city = placemark.addressDictionary?[kABPersonAddressCityKey] as? String,
            let addressDictionary = placemark.addressDictionary {
            selector1.selectOptionForValue(value: state)
            selector2.selectOptionForKey(key: city)
            let address = ABCreateStringWithAddressDictionary(addressDictionary, false)
            textField1.textField.text = address
        } else {
            radioButton3.btSelected()
            let messageText = L10n.alertAllowLocation
            radioButton1.disableButton(message: messageText)
        }
    }
    queue.async() {
        radioButton1.didSelectedClosure?()
    }
    radioButton3.didSelectedClosure = {
        radioButton1.selected = false
        selector1.isHidden = false
        selector2.isHidden = false
        textField1.isHidden = false
        textField1.window?.layoutIfNeeded()
    }
    
    let stackView = createStackView(elements: [
        title1, radioStackView, selector1, selector2, textField1
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        selector1, selector2, textField1
        ], hasObligatoryFields: true)
}

private func createStep4ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionAgeGroupVictim
    title1.setText(text: title1Text)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    let selector1Texts: [String] = [
        NSLocalizedString("select_an_option", tableName: "Report", comment: ""),
        NSLocalizedString("age_group1", tableName: "Report", comment: ""),
        NSLocalizedString("age_group2", tableName: "Report", comment: ""),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 0, 3),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 4, 7),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 8, 11),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 12, 14),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 15, 17),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 17, 19),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 18, 24),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 25, 30),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 31, 35),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 36, 40),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 41, 45),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 46, 50),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 51, 55),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 56, 60),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 61, 65),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 66, 70),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 71, 75),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 76, 80),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 81, 85),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 85, 90),
        String(format: NSLocalizedString("age_group_format2", tableName: "Report", comment: ""), 91)
    ]
    selector1.options = [
        PBKeyValue(key: selector1Texts[0]),
        PBKeyValue(key: selector1Texts[1], value: selector1Texts[1]),
        PBKeyValue(key: selector1Texts[2], value: selector1Texts[2]),
        PBKeyValue(key: selector1Texts[3], value: selector1Texts[3]),
        PBKeyValue(key: selector1Texts[4], value: selector1Texts[4]),
        PBKeyValue(key: selector1Texts[5], value: selector1Texts[5]),
        PBKeyValue(key: selector1Texts[6], value: selector1Texts[6]),
        PBKeyValue(key: selector1Texts[7], value: selector1Texts[7]),
        PBKeyValue(key: selector1Texts[8], value: selector1Texts[8]),
        PBKeyValue(key: selector1Texts[9], value: selector1Texts[9]),
        PBKeyValue(key: selector1Texts[10], value: selector1Texts[10]),
        PBKeyValue(key: selector1Texts[11], value: selector1Texts[11]),
        PBKeyValue(key: selector1Texts[12], value: selector1Texts[12]),
        PBKeyValue(key: selector1Texts[13], value: selector1Texts[13]),
        PBKeyValue(key: selector1Texts[14], value: selector1Texts[14]),
        PBKeyValue(key: selector1Texts[15], value: selector1Texts[15]),
        PBKeyValue(key: selector1Texts[16], value: selector1Texts[16]),
        PBKeyValue(key: selector1Texts[17], value: selector1Texts[17]),
        PBKeyValue(key: selector1Texts[18], value: selector1Texts[18]),
        PBKeyValue(key: selector1Texts[19], value: selector1Texts[19]),
        PBKeyValue(key: selector1Texts[20], value: selector1Texts[10]),
        PBKeyValue(key: selector1Texts[21], value: selector1Texts[21]),
        PBKeyValue(key: selector1Texts[22], value: selector1Texts[22]),
        PBKeyValue(key: selector1Texts[23], value: selector1Texts[23])
    ]
    selector1.apiKey = "faixa_etaria_vitima"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionEthnicityVictim
    title2.setText(text: title2Text)
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    let selector2Texts: [String] = [
        NSLocalizedString("select_an_option", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity3", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity1", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity5", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity6", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity4", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity2", tableName: "Report", comment: "")
    ]
    var options = [PBKeyValue]()
    options.append(PBKeyValue(key: selector2Texts[0]))
    for i in 1...selector2Texts.count-1 {
        options.append(PBKeyValue(key: selector2Texts[i], value: selector2Texts[i]))
    }
    selector2.options = options
    selector2.apiKey = "etnia_vitima"
    
    let stackView = createStackView(elements: [
        title1, selector1, title2, selector2
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        selector1, selector2
        ])
}

private func createStep5ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionGenderVictim
    title1.setText(text: title1Text, obligatory: true)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    let selector1Texts: [String] = [
        NSLocalizedString("select_an_option", tableName: "Report", comment: ""),
        NSLocalizedString("sex1", tableName: "Report", comment: ""),
        NSLocalizedString("sex2", tableName: "Report", comment: ""),
        NSLocalizedString("sex3", tableName: "Report", comment: ""),
        ]
    selector1.isRequired = true
    var options = [PBKeyValue]()
    options.append(PBKeyValue(key: selector1Texts[0]))
    for i in 1...selector1Texts.count-1 {
        options.append(PBKeyValue(key: selector1Texts[i], value: selector1Texts[i]))
    }
    selector1.options = options
    selector1.apiKey = "sexo_biologico_vitima"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionSexOptionVictim
    title2.setText(text: title2Text)
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    let selector2Texts: [String] = [
        NSLocalizedString("select_an_option", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option1", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option9", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option3", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option8", tableName: "Report", comment: ""),
        ]
    options = [PBKeyValue]()
    options.append(PBKeyValue(key: selector2Texts[0]))
    for i in 1...selector2Texts.count-1 {
        options.append(PBKeyValue(key: selector2Texts[i], value: selector2Texts[i]))
    }
    selector2.options = options
    selector2.apiKey = "opcao_sexual_vitima"
    
    let stackView = createStackView(elements: [
        title1, selector1, title2, selector2
        ])
    let step = PBComplaintStep(stackView: stackView, elements: [
        selector1, selector2
        ], hasObligatoryFields: true)
    step.infoAction = "infoAboutSex" // TODO: which method is this?
    return step
}

private func createStep6ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionPlaceViolation
    title1.setText(text: title1Text, obligatory: true)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    let selector1Texts: [String] = [
        NSLocalizedString("select_an_option", tableName: "Report", comment: ""),
        NSLocalizedString("place1", tableName: "Report", comment: ""),
        NSLocalizedString("place2", tableName: "Report", comment: ""),
        NSLocalizedString("place3", tableName: "Report", comment: ""),
        NSLocalizedString("place4", tableName: "Report", comment: ""),
        NSLocalizedString("place5", tableName: "Report", comment: ""),
        NSLocalizedString("place13", tableName: "Report", comment: ""),
        NSLocalizedString("place14", tableName: "Report", comment: ""),
        NSLocalizedString("place15", tableName: "Report", comment: ""),
        NSLocalizedString("place16", tableName: "Report", comment: ""),
        NSLocalizedString("place17", tableName: "Report", comment: ""),
        NSLocalizedString("place18", tableName: "Report", comment: ""),
        NSLocalizedString("place19", tableName: "Report", comment: ""),
        NSLocalizedString("place20", tableName: "Report", comment: ""),
        NSLocalizedString("place21", tableName: "Report", comment: ""),
        NSLocalizedString("place22", tableName: "Report", comment: ""),
        NSLocalizedString("place23", tableName: "Report", comment: ""),
        NSLocalizedString("place24", tableName: "Report", comment: ""),
        NSLocalizedString("place25", tableName: "Report", comment: ""),
        NSLocalizedString("place26", tableName: "Report", comment: ""),
        ]
    
    selector1.isRequired = true
    
    var options = [PBKeyValue]()
    options.append(PBKeyValue(key: selector1Texts[0]))
    for i in 1...selector1Texts.count-1 {
        options.append(PBKeyValue(key: selector1Texts[i], value: selector1Texts[i]))
    }
    
    selector1.options = options
    selector1.apiKey = "local"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionViolationTime
    title2.setText(text: title2Text, obligatory: true)
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    let selector2Texts: [String] = [
        NSLocalizedString("select_an_option", tableName: "Report", comment: ""),
        NSLocalizedString("frequency8", tableName: "Report", comment: ""),
        NSLocalizedString("frequency1", tableName: "Report", comment: ""),
        NSLocalizedString("frequency3", tableName: "Report", comment: ""),
        NSLocalizedString("frequency4", tableName: "Report", comment: ""),
        NSLocalizedString("frequency2", tableName: "Report", comment: ""),
        NSLocalizedString("frequency9", tableName: "Report", comment: ""),
        NSLocalizedString("frequency7", tableName: "Report", comment: ""),
        NSLocalizedString("frequency10", tableName: "Report", comment: ""),
        NSLocalizedString("frequency5", tableName: "Report", comment: ""),
        ]
    selector2.isRequired = true
    options = [PBKeyValue]()
    options.append(PBKeyValue(key: selector2Texts[0]))
    for i in 1...selector2Texts.count-1 {
        options.append(PBKeyValue(key: selector2Texts[i], value: selector2Texts[i]))
    }
    
    selector2.options = options
    selector2.apiKey = "frequencia"
    
    let stackView = createStackView(elements: [
        title1, selector1, title2, selector2
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        selector1, selector2
        ], hasObligatoryFields: true)
}

private func createStep7ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionViolationDescription
    title1.setText(text: title1Text, obligatory: true)
    
    let textView = PBTextViewComplaintElement.loadView()
    textView.placeholder = L10n.hintViolationDescription
    textView.isRequired = true
    textView.apiKey = "descricao"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionInstitutionActivated
    title2.setText(text: title2Text, obligatory: true)
    
    let radioButton1 = PBRadioButtonComplaintElement.loadView()
    radioButton1.selected = true
    radioButton1.title = L10n.responsePositive
    let radioButton2 = PBRadioButtonComplaintElement.loadView()
    radioButton2.title = L10n.responseNegative
    let radioStackView = createStackView(elements: [
        radioButton1, radioButton2
        ], horizontal: true)
    
    let textField1 = PBTextFieldComplaintElement.loadView()
    textField1.isRequired = true
    textField1.placeholder = L10n.hintInstitutionActivated
    textField1.apiKey = "instituicao_acionada"
    
    radioButton1.didSelectedClosure = {
        radioButton2.selected = false
        textField1.isHidden = false
        textField1.isRequired = true
        textField1.window?.layoutIfNeeded()
    }
    radioButton2.didSelectedClosure = {
        radioButton1.selected = false
        textField1.isHidden = true
        textField1.isRequired = false
        textField1.window?.layoutIfNeeded()
    }
    
    textField1.returnKeyType = .done
    textField1.returnClosure = {
        _ = textField1.resignFirstResponder()
    }
    
    let stackView = createStackView(elements: [
        title1, textView, title2, radioStackView, textField1
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        textField1, textView
        ], hasObligatoryFields: true)
}

private func createStep8ForViolation() -> PBComplaintStep {
    let title = PBTitleComplaintElement.loadView()
    let titleText = L10n.titleQuestionOffenderInfo
    title.setText(text: titleText, obligatory: true)
    
    let radioButton1 = PBRadioButtonComplaintElement.loadView()
    radioButton1.selected = true
    radioButton1.title = L10n.titlePerson
    radioButton1.apiKey = "tiposuspeito"
    radioButton1.value = NSNumber(value: 2)
    
    let radioButton2 = PBRadioButtonComplaintElement.loadView()
    radioButton2.title = L10n.titleCompany
    radioButton2.apiKey = "tiposuspeito"
    radioButton2.value = NSNumber(value: 1)
    
    let textField = PBTextFieldComplaintElement.loadView()
    textField.apiKey = "nome_suspeito"
    textField.placeholder = L10n.hintOffenderName
    textField.isRequired = true
    
    radioButton2.didSelectedClosure = {
        textField.isHidden = false
        textField.apiKey = "nome_suspeito"
        textField.isRequired = true
        textField.window?.layoutIfNeeded()
        radioButton1.selected = false
    }
    radioButton1.didSelectedClosure = {
        textField.isHidden = false
        textField.apiKey = "nome_suspeito"
        textField.isRequired = true
        textField.window?.layoutIfNeeded()
        radioButton2.selected = false
    }
    
    let stackView = createStackView(elements: [
        title, radioButton1, radioButton2, textField
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        radioButton2, radioButton1, textField
        ], hasObligatoryFields: true)
}

private func createStep9ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionOffenderLocation
    title1.setText(text: title1Text, obligatory: true)
    
    let radioButton1 = PBRadioButtonComplaintElement.loadView()
    radioButton1.selected = true
    radioButton1.title = L10n.hintMyLocation
    let radioButton3 = PBRadioButtonComplaintElement.loadView()
    radioButton3.title = L10n.hintFillAddress
    
    let radioStackView = createStackView(elements: [
        radioButton1, radioButton3
        ], horizontal: true)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    selector1.isHidden = true
    selector1.isRequired = true
    selector1.options = states
    selector1.apiKey = "uf_suspeito"
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    selector2.isHidden = true
    selector2.isRequired = true
    let selector2Option0: String = L10n.spinnerDefaultStateText
    selector2.options = [
        PBKeyValue(key: selector2Option0)
    ]
    selector2.apiKey = "cidade_suspeito"
    
    selector1.didSelectedOptionClosure = { keyValue in
        var options = [PBKeyValue(key: selector2Option0)]
        if let state = keyValue.value as? String {
            var filtered = cities.filter { city in
                return city.state == state
            }
            filtered = filtered.sorted(by: { (city1, city2) -> Bool in
                return city1.name.localizedCaseInsensitiveCompare(city2.name) == .orderedAscending
            })
            options.removeAll()
            for city in filtered {
                options.append(PBKeyValue(key: city.name, value: city.name))
            }
        }
        selector2.options = options
        selector2.retractOptions()
    }
    
    let textField1 = PBTextFieldComplaintElement.loadView()
    textField1.isHidden = true
    textField1.isRequired = true
    textField1.apiKey = "endereco_suspeito"
    
    radioButton1.didSelectedClosure = {
        radioButton3.selected = false
        selector1.isHidden = true
        selector2.isHidden = true
        textField1.isHidden = true
        textField1.window?.layoutIfNeeded()
        
        if let
            placemark = PBLocationManager.sharedInstance().currentPlacemark,
            let state = placemark.addressDictionary?[kABPersonAddressStateKey] as? String,
            let city = placemark.addressDictionary?[kABPersonAddressCityKey] as? String,
            let addressDictionary = placemark.addressDictionary {
            selector1.selectOptionForValue(value: state)
            selector2.selectOptionForKey(key: city)
            let address = ABCreateStringWithAddressDictionary(addressDictionary, false)
            textField1.textField.text = address
        } else {
            radioButton3.btSelected()
            let messageText = L10n.alertAllowLocation
            radioButton1.disableButton(message: messageText)
        }
    }
    queue.async() {
        radioButton1.didSelectedClosure?()
    }
    radioButton3.didSelectedClosure = {
        radioButton1.selected = false
        selector1.isHidden = false
        selector2.isHidden = false
        textField1.isHidden = false
        textField1.window?.layoutIfNeeded()
    }
    
    let stackView = createStackView(elements: [
        title1, radioStackView, selector1, selector2, textField1
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        selector1, selector2, textField1
        ], hasObligatoryFields: true)
}

private func createStep10ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionAgeGroupOffender
    title1.setText(text: title1Text)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    let selector1Texts: [String] = [
        NSLocalizedString("select_an_option", tableName: "Report", comment: ""),
        NSLocalizedString("age_group1", tableName: "Report", comment: ""),
        NSLocalizedString("age_group2", tableName: "Report", comment: ""),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 0, 3),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 4, 7),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 8, 11),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 12, 14),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 15, 17),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 17, 19),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 18, 24),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 25, 30),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 31, 35),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 36, 40),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 41, 45),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 46, 50),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 51, 55),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 56, 60),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 61, 65),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 66, 70),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 71, 75),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 76, 80),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 81, 85),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 85, 90),
        String(format: NSLocalizedString("age_group_format2", tableName: "Report", comment: ""), 91)
    ]
    var options = [PBKeyValue]()
    options.append(PBKeyValue(key: selector1Texts[0]))
    for i in 1...selector1Texts.count-1 {
        options.append(PBKeyValue(key: selector1Texts[i], value: selector1Texts[i]))
    }
    selector1.options = options
    selector1.apiKey = "faixa_etaria_suspeito"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionEthnicityOffender
    title2.setText(text: title2Text)
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    let selector2Texts: [String] = [
        NSLocalizedString("select_an_option", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity3", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity1", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity5", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity6", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity4", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity2", tableName: "Report", comment: ""),
        ]
    options = [PBKeyValue]()
    options.append(PBKeyValue(key: selector1Texts[0]))
    for i in 1...selector2Texts.count-1 {
        options.append(PBKeyValue(key: selector2Texts[i], value: selector2Texts[i]))
    }
    selector2.options = options
    selector2.apiKey = "etnia_suspeito"
    
    let stackView = createStackView(elements: [
        title1, selector1, title2, selector2
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        selector1, selector2
        ])
}

private func createStep11ForViolation() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionGenderOffender
    title1.setText(text: title1Text, obligatory: true)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    let selector1Texts: [String] = [
        NSLocalizedString("select_an_option", tableName: "Report", comment: ""),
        NSLocalizedString("sex1", tableName: "Report", comment: ""),
        NSLocalizedString("sex2", tableName: "Report", comment: ""),
        NSLocalizedString("sex3", tableName: "Report", comment: ""),
        ]
    selector1.isRequired = true
    var options = [PBKeyValue]()
    options.append(PBKeyValue(key: selector1Texts[0]))
    for i in 1...selector1Texts.count-1 {
        options.append(PBKeyValue(key: selector1Texts[i], value: selector1Texts[i]))
    }
    selector1.options = options
    selector1.apiKey = "sexo_biologico_suspeito"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionSexOptionOffender
    title2.setText(text: title2Text)
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    let selector2Texts: [String] = [
        NSLocalizedString("select_an_option", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option1", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option9", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option3", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option8", tableName: "Report", comment: ""),
        ]
    options = [PBKeyValue]()
    options.append(PBKeyValue(key: selector2Texts[0]))
    for i in 1...selector2Texts.count-1 {
        options.append(PBKeyValue(key: selector2Texts[i], value: selector2Texts[i]))
    }
    selector2.options = options
    selector2.apiKey = "opcao_sexual_suspeito"
    
    let stackView = createStackView(elements: [
        title1, selector1, title2, selector2
        ])
    let step = PBComplaintStep(stackView: stackView, elements: [
        selector1, selector2
        ], hasObligatoryFields: true)
    step.infoAction = "infoAboutSex"
    return step
}

private func createInternetCrimeStep() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionInternetCrime
    title1.setText(text: title1Text, obligatory: true)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    selector1.showActivityIndicator()
    selector1.isRequired = true
    selector1.apiKey = "report_kit_last_option"
    selector1.options = [
        PBKeyValue(key: "")
    ]
    var options = [
        PBKeyValue(key: NSLocalizedString("select_an_option", tableName: "Report", comment: ""))
    ]
    PBAPI.report.getInternetCrimeTypes { internetCrimeTypes, _ in
        guard let internetCrimeTypes = internetCrimeTypes else {
            let title = L10n.error
            let message = L10n.errorFromServer
            let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: L10n.ok)
            alert.show()
            selector1.hideActivityIndicator()
            selector1.options = options
            return
        }
        for type in internetCrimeTypes {
            let keyValue = PBKeyValue(key: type.title, value: type.id)
            options.append(keyValue)
        }
        selector1.hideActivityIndicator()
        selector1.options = options
    }
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionInternetLocation
    title2.setText(text: title2Text, obligatory: true)
    
    let textField1 = PBTextFieldComplaintElement.loadView()
    textField1.placeholder = L10n.hintWebsiteAddress
    textField1.keyboardType = .URL
    textField1.isRequired = true
    textField1.apiKey = "url"
    textField1.returnKeyType = .next
    
    let title3 = PBTitleComplaintElement.loadView()
    let title3Text = L10n.titleQuestionAccessibilityViolationDesc
    title3.setText(text: title3Text, obligatory: true)
    
    let textView1 = PBTextViewComplaintElement.loadView()
    textView1.placeholder = L10n.hintInternetCrimeDescription
    textView1.isRequired = true
    textView1.apiKey = "description"
    
    textField1.returnClosure = {
        _ = textView1.becomeFirstResponder()
    }
    
    let stackView = createStackView(elements: [
        title1, selector1,
        title2, textField1,
        title3, textView1
        ])
    let viewControllerTitleText = L10n.labelInternetCrime
    return PBComplaintStep(stackView: stackView, elements: [
        selector1, textField1, textView1
        ], hasObligatoryFields: true, title: viewControllerTitleText)
}

private func createNoAccessibilityStep1() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionAccessibilityLocation
    title1.setText(text: title1Text, obligatory: true)
    
    let radioButton1 = PBRadioButtonComplaintElement.loadView()
    radioButton1.title = L10n.titleAccessInstLocation
    radioButton1.selected = true
    
    let radioButton2 = PBRadioButtonComplaintElement.loadView()
    radioButton2.title = L10n.titleAccessTransLocation
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionAccessibilityLocationInfo
    title2.setText(text: title2Text, obligatory: true)
    
    let textField1 = PBTextFieldComplaintElement.loadView()
    textField1.placeholder = L10n.hintAccessInstLocationName
    textField1.isRequired = true
    textField1.apiKey = "nome_suspeito"
    textField1.returnKeyType = .done
    textField1.returnClosure = {
        textField1.textField.resignFirstResponder()
    }
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    selector1.isRequired = true
    let councilOptions = [
        PBKeyValue(key: L10n.hintAccessInstOffenderType),
        PBKeyValue(key: NSLocalizedString("institution_type1", tableName: "Report",
                                          bundle: Bundle.main, value: "", comment: ""), value: 27),
        PBKeyValue(key: NSLocalizedString("institution_type2", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: 28),
        PBKeyValue(key: NSLocalizedString("institution_type3", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: 29)
    ]
    let transportOptions = [
        PBKeyValue(key: L10n.hintAccessInstOffenderType),
        PBKeyValue(key: NSLocalizedString("transport_type1", tableName: "Report",
                                          bundle: Bundle.main, value: "", comment: ""), value: 30),
        PBKeyValue(key: NSLocalizedString("transport_type2", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: 31),
        PBKeyValue(key: NSLocalizedString("transport_type3", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: 32),
        PBKeyValue(key: NSLocalizedString("transport_type4", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: 33)
    ]
    selector1.options = councilOptions
    selector1.apiKey = "id_local"
    
    var newStates = [PBKeyValue](states)
    let selectTheStateText = L10n.spinnerDefaultStateText
    newStates.removeFirst()
    newStates.insert(PBKeyValue(key: selectTheStateText), at: 0)
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    selector2.isRequired = true
    selector2.options = newStates
    selector2.apiKey = "uf_suspeito"
    
    queue.async() {
        loadCities()
    }
    
    let selector3 = PBOptionSelectorComplaintElement.loadView()
    selector3.isRequired = true
    selector3.options = [
        PBKeyValue(key: L10n.spinnerDefaultCityText)
    ]
    selector3.apiKey = "cidade_suspeito"
    
    let textField2 = PBTextFieldComplaintElement.loadView()
    textField2.isRequired = true
    textField2.placeholder = L10n.hintAccessInstAddress
    textField2.apiKey = "endereco_suspeito"
    textField2.returnKeyType = .done
    textField2.returnClosure = {
        textField2.textField.resignFirstResponder()
    }
    
    radioButton1.didSelectedClosure = {
        radioButton2.selected = false
        textField1.placeholder = L10n.hintAccessInstLocationName
        textField1.textField.text = ""
        selector1.selectRow(row: 0)
        selector1.options = councilOptions
        textField2.placeholder = L10n.hintAccessInstAddress
        textField2.textField.text = ""
    }
    radioButton2.didSelectedClosure = {
        radioButton1.selected = false
        textField1.placeholder = L10n.hintAccessTransLocationName
        textField1.textField.text = ""
        selector1.selectRow(row: 0)
        selector1.options = transportOptions
        textField2.placeholder = L10n.hintAccessTransAddress
        textField2.textField.text = ""
    }
    
    selector2.didSelectedOptionClosure = { keyValue in
        var options = [
            PBKeyValue(key: L10n.spinnerDefaultCityText)
        ]
        guard let state = keyValue.value as? String else {
            selector3.options = options
            return
        }
        let cities = citiesFromState(state: state)
        for city in cities {
            let keyValue = PBKeyValue(key: city.name, value: city.code)
            options.append(keyValue)
        }
        selector3.options = options
    }
    
    let stackView = createStackView(elements: [
        title1, radioButton1, radioButton2,
        title2, textField1, selector1, selector2, selector3, textField2
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        textField1, selector1, selector2, selector3, textField2
        ], hasObligatoryFields: true)
}

private func createNoAccessibilityStep2() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionAccessibilityViolation
    title1.setText(text: title1Text, obligatory: true)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    selector1.isRequired = true
    selector1.options = [
        PBKeyValue(key: NSLocalizedString("select_an_option", tableName: "Report",
            bundle: Bundle.main, value: "", comment: "")),
        PBKeyValue(key: NSLocalizedString("access_violation_type1", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: 14),
        PBKeyValue(key: NSLocalizedString("access_violation_type2", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: 15),
        PBKeyValue(key: NSLocalizedString("access_violation_type3", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: 16)
    ]
    selector1.apiKey = "id_tipo_violacao"
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    selector2.isHidden = true
    selector2.isRequired = false
    selector2.options = [
        PBKeyValue(key: NSLocalizedString("select_an_option", tableName: "Report",
            bundle: Bundle.main, value: "", comment: "")),
        PBKeyValue(key: NSLocalizedString("access_violation140", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "140"),
        PBKeyValue(key: NSLocalizedString("access_violation141", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "141"),
        PBKeyValue(key: NSLocalizedString("access_violation142", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "142"),
        PBKeyValue(key: NSLocalizedString("access_violation143", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "143"),
        PBKeyValue(key: NSLocalizedString("access_violation144", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "144"),
        PBKeyValue(key: NSLocalizedString("access_violation146", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "146"),
        PBKeyValue(key: NSLocalizedString("access_violation147", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "147"),
        PBKeyValue(key: NSLocalizedString("access_violation148", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "148"),
        PBKeyValue(key: NSLocalizedString("access_violation149", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "149"),
        PBKeyValue(key: NSLocalizedString("access_violation150", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "150"),
        PBKeyValue(key: NSLocalizedString("access_violation151", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "151"),
        PBKeyValue(key: NSLocalizedString("access_violation152", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "152"),
        PBKeyValue(key: NSLocalizedString("access_violation153", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "153"),
        PBKeyValue(key: NSLocalizedString("access_violation154", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "154"),
        PBKeyValue(key: NSLocalizedString("access_violation155", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "155"),
        PBKeyValue(key: NSLocalizedString("access_violation145", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "145"),
        PBKeyValue(key: NSLocalizedString("access_violation156", tableName: "Report",
            bundle: Bundle.main, value: "", comment: ""), value: "156"),
    ]
    
    let textField1 = PBTextFieldComplaintElement.loadView()
    textField1.isHidden = true
    textField1.isRequired = false
    textField1.apiKey = "outra_violacao"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionAccessibilityViolationDesc
    title2.setText(text: title2Text, obligatory: true)
    
    let textView1 = PBTextViewComplaintElement.loadView()
    textView1.isRequired = true
    textView1.placeholder = L10n.hintAccessViolationDesc
    textView1.apiKey = "descricao_denuncia"
    
    selector1.didSelectedOptionClosure = { keyValue in
        if selector1.options.first?.key == keyValue.key {
            selector2.isHidden = true
            selector2.isRequired = false
            selector2.apiKey = nil
            textField1.isHidden = true
            textField1.isRequired = false
            textField1.apiKey = nil
        } else if selector1.options.last?.key == keyValue.key {
            selector2.isHidden = true
            selector2.isRequired = false
            selector2.apiKey = nil
            textField1.isHidden = false
            textField1.isRequired = true
            textField1.apiKey = "outra_violacao"
        } else {
            selector2.isHidden = false
            selector2.isRequired = true
            selector2.apiKey = "id_violacao"
            textField1.isHidden = true
            textField1.isRequired = false
            textField1.apiKey = nil
        }
    }
    
    let stackView = createStackView(elements: [
        title1, selector1, selector2, textField1,
        title2, textView1
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        selector1, selector2, textField1, textView1
        ], hasObligatoryFields: true)
}

private func createNoAccessibilityStep2_1() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title3Text = L10n.titleQuestionInstitutionActivatedRequired
    title1.setText(text: title3Text, obligatory: true)
    
    let radioButton1 = PBRadioButtonComplaintElement.loadView()
    radioButton1.selected = true
    radioButton1.title = NSLocalizedString("response_positive", comment: "")
    let radioButton2 = PBRadioButtonComplaintElement.loadView()
    radioButton2.title = NSLocalizedString("response_negative", comment: "")
    let radioStackView = createStackView(elements: [
        radioButton1, radioButton2
        ], horizontal: true)
    
    let textField1 = PBTextFieldComplaintElement.loadView()
    textField1.placeholder = L10n.hintInstitutionActivated
    textField1.isRequired = true
    textField1.apiKey = "orgao_acionado"
    
    radioButton1.didSelectedClosure = {
        radioButton2.selected = false
        textField1.isHidden = false
        textField1.isRequired = true
        textField1.window?.layoutIfNeeded()
    }
    radioButton2.didSelectedClosure = {
        radioButton1.selected = false
        textField1.isHidden = true
        textField1.isRequired = false
        textField1.window?.layoutIfNeeded()
    }
    
    let stackView = createStackView(elements: [
        title1, radioStackView, textField1
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        textField1
        ], hasObligatoryFields: true)
}

private func createNoAccessibilityStep3() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionAccessibilityVictimName
    title1.setText(text: title1Text)
    
    let textField1 = PBTextFieldComplaintElement.loadView()
    textField1.placeholder = L10n.hintVictimName
    textField1.apiKey = "nome_vitima"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionVictimLocation
    title2.setText(text: title2Text, obligatory: true)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    selector1.isRequired = true
    selector1.options = states
    selector1.apiKey = "uf_vitima"
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    selector2.isRequired = true
    let selector2Option0: String = L10n.spinnerDefaultCityText
    selector2.options = [
        PBKeyValue(key: selector2Option0)
    ]
    selector2.apiKey = "cidade_vitima"
    
    queue.async() {
        loadCities()
    }
    
    selector1.didSelectedOptionClosure = { keyValue in
        var options = [PBKeyValue(key: selector2Option0)]
        if let state = keyValue.value as? String {
            let cities = citiesFromState(state: state)
            for city in cities {
                options.append(PBKeyValue(key: city.name, value: city.code))
            }
        }
        selector2.options = options
        selector2.retractOptions()
    }
    
    let textField2 = PBTextFieldComplaintElement.loadView()
    textField2.isRequired = true
    textField2.placeholder = L10n.hintAccessInstAddress
    textField2.apiKey = "endereco_vitima"
    
    let stackView = createStackView(elements: [
        title1, textField1,
        title2, selector1, selector2, textField2
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        textField1, selector1, selector2, textField2
        ], hasObligatoryFields: true)
}

private func createNoAccessibilityStep4() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionAgeGroupVictim
    title1.setText(text: title1Text)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    let selector1Texts: [String] = [
        NSLocalizedString("age_group0", tableName: "Report", comment: ""),
        NSLocalizedString("age_group1", tableName: "Report", comment: ""),
        NSLocalizedString("age_group2", tableName: "Report", comment: ""),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 0, 3),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 4, 7),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 8, 11),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 12, 14),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 15, 17),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 17, 19),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 18, 24),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 25, 30),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 31, 35),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 36, 40),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 41, 45),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 46, 50),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 51, 55),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 56, 60),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 61, 65),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 66, 70),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 71, 75),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 76, 80),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 81, 85),
        String(format: NSLocalizedString("age_group_format1", tableName: "Report", comment: ""), 85, 90),
        String(format: NSLocalizedString("age_group_format2", tableName: "Report", comment: ""), 91)
    ]
    selector1.options = [
        PBKeyValue(key: selector1Texts[0], value: ""),
        PBKeyValue(key: selector1Texts[1], value: "18"),
        PBKeyValue(key: selector1Texts[2], value: "19"),
        PBKeyValue(key: selector1Texts[3], value: "20"),
        PBKeyValue(key: selector1Texts[4], value: "21"),
        PBKeyValue(key: selector1Texts[5], value: "22"),
        PBKeyValue(key: selector1Texts[6], value: "23"),
        PBKeyValue(key: selector1Texts[7], value: "24"),
        PBKeyValue(key: selector1Texts[8], value: "25"),
        PBKeyValue(key: selector1Texts[9], value: "3"),
        PBKeyValue(key: selector1Texts[10], value: "4"),
        PBKeyValue(key: selector1Texts[11], value: "5"),
        PBKeyValue(key: selector1Texts[12], value: "6"),
        PBKeyValue(key: selector1Texts[13], value: "7"),
        PBKeyValue(key: selector1Texts[14], value: "8"),
        PBKeyValue(key: selector1Texts[15], value: "9"),
        PBKeyValue(key: selector1Texts[16], value: "10"),
        PBKeyValue(key: selector1Texts[17], value: "11"),
        PBKeyValue(key: selector1Texts[18], value: "12"),
        PBKeyValue(key: selector1Texts[19], value: "13"),
        PBKeyValue(key: selector1Texts[20], value: "14"),
        PBKeyValue(key: selector1Texts[21], value: "15"),
        PBKeyValue(key: selector1Texts[22], value: "16"),
        PBKeyValue(key: selector1Texts[23], value: "17")
    ]
    selector1.apiKey = "id_faixa_etaria"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionEthnicityVictim
    title2.setText(text: title2Text)
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    let selector2Texts: [String] = [
        NSLocalizedString("ethnicity6", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity3", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity1", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity5", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity4", tableName: "Report", comment: ""),
        NSLocalizedString("ethnicity2", tableName: "Report", comment: "")
    ]
    selector2.options = [
        PBKeyValue(key: selector2Texts[0], value: 6),
        PBKeyValue(key: selector2Texts[1], value: 3),
        PBKeyValue(key: selector2Texts[2], value: 1),
        PBKeyValue(key: selector2Texts[3], value: 5),
        PBKeyValue(key: selector2Texts[4], value: 4),
        PBKeyValue(key: selector2Texts[5], value: 2)
    ]
    selector2.apiKey = "id_cor_raca"
    
    let stackView = createStackView(elements: [
        title1, selector1, title2, selector2
        ])
    return PBComplaintStep(stackView: stackView, elements: [
        selector1, selector2
        ])
}

private func createNoAccessibilityStep5() -> PBComplaintStep {
    let title1 = PBTitleComplaintElement.loadView()
    let title1Text = L10n.titleQuestionVictimGenderNoReq
    title1.setText(text: title1Text)
    
    let selector1 = PBOptionSelectorComplaintElement.loadView()
    let selector1Texts: [String] = [
        NSLocalizedString("sex3", tableName: "Report", comment: ""),
        NSLocalizedString("sex1", tableName: "Report", comment: ""),
        NSLocalizedString("sex2", tableName: "Report", comment: ""),
        ]
    selector1.options = [
        PBKeyValue(key: selector1Texts[0], value: 3),
        PBKeyValue(key: selector1Texts[1], value: 1),
        PBKeyValue(key: selector1Texts[2], value: 2),
    ]
    selector1.apiKey = "id_sexo"
    
    let title2 = PBTitleComplaintElement.loadView()
    let title2Text = L10n.titleQuestionSexOptionVictim
    title2.setText(text: title2Text)
    
    let selector2 = PBOptionSelectorComplaintElement.loadView()
    let selector2Texts: [String] = [
        NSLocalizedString("sex_option3", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option1", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option9", tableName: "Report", comment: ""),
        NSLocalizedString("sex_option8", tableName: "Report", comment: ""),
        ]
    selector2.options = [
        PBKeyValue(key: selector2Texts[0], value: 4),
        PBKeyValue(key: selector2Texts[1], value: 1),
        PBKeyValue(key: selector2Texts[2], value: 2),
        PBKeyValue(key: selector2Texts[3], value: 3)
    ]
    selector2.apiKey = "id_orientacao_sexual"
    
    let stackView = createStackView(elements: [
        title1, selector1, title2, selector2
        ])
    let step = PBComplaintStep(stackView: stackView, elements: [
        selector1, selector2
        ])
    step.infoAction = "infoAboutSex"
    return step
}
