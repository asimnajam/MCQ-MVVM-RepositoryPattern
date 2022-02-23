//
//  ViewModel.swift
//  Test
//
//  Created by Admin on 15/02/2022.
//

import Foundation

final class ViewModel {
    enum InActions {
        case optionSelected(_ indexPath: IndexPath)
        case nextButtonAction
        case previousQuestion
    }
    
    enum OutActions {
        case questionsFetched
        case optionSelected(indexPath: IndexPath, previousIndexPath: IndexPath?, isOn: Bool)
        case moveToNextQuestion
        case showResult(Bool)
    }
    
    private let questionService: QuestionFetchable
    private let networking: FetchLiveProtocol
    private let handler = Handler()
    private let userRepo: UserRepository
    
    private(set) var inActions: ((InActions) -> Void)?
    var outActions: ((OutActions) -> Void)?
    
    private var selectedQuestionIndex: Int = 0
    private(set) var selectedOption: IndexPath?
    
    private var questions: Questions? {
        didSet {
            outActions?(.questionsFetched)
        }
    }
    
    var currentModel: Question? {
        questions?.questions[selectedQuestionIndex]
    }
    
    var currentQuestion: String {
        currentModel?.query ?? ""
    }
    
    var choices: [String] {
        currentModel?.answers.compactMap { $0.title } ?? []
    }
    
    var canMoveToNextQuestion: Bool {
        selectedQuestionIndex < (questions?.questions.count ?? 0)
    }
    
    var isCorrectAnswer: Bool {
        if let question = currentModel,
            let row = selectedOption?.row {
            let answer = question.answers[row]
            return answer.correct
        }
        return false
    }
    
    init(networking: FetchLiveProtocol = FetchLive(), userRepo: UserRepository = UserRepositoryManager(), questionService: QuestionFetchable = QuestionService()) {
        self.networking = networking
        self.userRepo = userRepo
        self.questionService = questionService
        bind()
    }
    
    func isOptionPreSelected(_ path: IndexPath) -> Bool {
        selectedOption == path
    }
    
    func fetch() {
        questionService.fetch { [weak self] obj in
            guard let questions = obj, let self = self else { return }
            DispatchQueue.main.async {
                self.userRepo.save(user: questions)
                self.questions = questions
            }
        } failure: { error in
            print(error)
        }
    }
}

extension ViewModel {
    private func bind() {
        inActions = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case let .optionSelected(indexPath):
                self.selectOption(indexPath)
            case .nextButtonAction:
                if self.selectedOption != nil {
                    if self.selectedQuestionIndex != self.questions?.questions.count {
                        self.moveToNextQuestion()
                    } else {
                        self.showAnswers()
                    }
                }

            case .previousQuestion:
                if self.selectedQuestionIndex > 0 {
                    self.selectedQuestionIndex -= 1
                    self.outActions?(.questionsFetched)
                    self.isPreviouslyAnsered()
                }
            }
        }
    }
    
    private func selectOption(_ path: IndexPath) {
        if isOptionPreSelected(path) {
            unselectAnswer(path)
            
        } else {
            selectAnswer(path)
        }
    }
    
    private func selectAnswer(_ path: IndexPath) {
        let previousPath = selectedOption
        selectedOption = path
        outActions?(
            .optionSelected(
                indexPath: path,
                previousIndexPath: previousPath,
                isOn: true
            )
        )
    }
    
    private func unselectAnswer(_ path: IndexPath) {
        let previousPath = selectedOption
        selectedOption = nil
        outActions?(
            .optionSelected(
                indexPath: path,
                previousIndexPath: previousPath,
                isOn: false
            )
        )
    }
    
    private func showAnswers() {
        fetchAllAnswers { [weak self] answers in
            guard let self = self else { return }
            let allAnswers = answers.map { $0.isCorrectAnswer }
            let correctAnswers = allAnswers.filter { $0 }
            self.outActions?(.showResult(allAnswers.count == correctAnswers.count))
        }
    }
    
    private func fetchAllAnswers(_ compilation: @escaping ([SelectedAnswer]) -> Void)  {
        userRepo.getAllAnswers { answers in
            compilation(answers)
        }
    }
    
    private func moveToNextQuestion() {
        saveAnswer()
        selectedQuestionIndex += 1
        
        if canMoveToNextQuestion {
            selectedOption = nil
            outActions?(.moveToNextQuestion)
        } else {
            self.showAnswers()
        }
    }
    
    private func saveAnswer() {
        guard let model = currentModel,
                let selectedOption = selectedOption,
              let answer = Array(model.answers).get(index: selectedOption.row)
        else {
            return
        }
        let selectedAnswer = SelectedAnswer(model.id, selectedOption.row, answer.correct)
        userRepo.save(answer: selectedAnswer)
    }
    
    private func isPreviouslyAnsered() {
        fetchAllAnswers { [weak self] answers in
            if let answer = answers.first(where: { $0.questionID == self?.currentModel?.id ?? 0  }) {
                let isContains = answer.questionID == (self?.currentModel?.id ?? 0)
                if isContains {
                    let path = IndexPath(row: answer.answerIndex, section: 0)
                    self?.selectedOption = path
                    self?.outActions?(.optionSelected(indexPath: path, previousIndexPath: nil, isOn: true))
                }
            }

        }
    }
}
