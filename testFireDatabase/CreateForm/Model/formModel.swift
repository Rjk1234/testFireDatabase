//
//  formModel.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 21/04/22.
//



import Foundation

// MARK: - FormModel
class FormModel: Codable {
    let data: FormData?

    init(data: FormData?) {
        self.data = data
    }
}

// MARK: - FormData
class FormData: Codable {
    let formID, title: String?
    let status: Bool?
    let property: [Property]?

    enum CodingKeys: String, CodingKey {
        case formID = "FormId"
        case title = "Title"
        case status = "Status"
        case property
    }

    init(formID: String?, title: String?, status: Bool?, property: [Property]?) {
        self.formID = formID
        self.title = title
        self.status = status
        self.property = property
    }
}

// MARK: - Property
class Property: Codable {
    let questionID, qTitle, qType, answer: String?
    let option: [Option]?

    enum CodingKeys: String, CodingKey {
        case questionID = "QuestionId"
        case qTitle, qType, answer, option
    }

    init(questionID: String?, qTitle: String?, qType: String?, answer: String?, option: [Option]?) {
        self.questionID = questionID
        self.qTitle = qTitle
        self.qType = qType
        self.answer = answer
        self.option = option
    }
}

// MARK: - Option
class Option: Codable {
    let opid, optitle, opdisplay: String?
    let isSelected: Bool?

    init(opid: String?, optitle: String?, opdisplay: String?, isSelected: Bool?) {
        self.opid = opid
        self.optitle = optitle
        self.opdisplay = opdisplay
        self.isSelected = isSelected
    }
}

