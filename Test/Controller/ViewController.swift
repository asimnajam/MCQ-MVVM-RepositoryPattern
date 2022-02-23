//
//  ViewController.swift
//  Test
//
//  Created by Asim Najam on 2/14/22.
//

import UIKit

class ViewController: UIViewController {
    let viewModel = ViewModel()
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var previousQuestionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        actionButton.addTarget(
            self,
            action: #selector(nextQuestionButtonAction(_:)),
            for: .touchUpInside
        )
        
        previousQuestionButton.addTarget(
            self,
            action: #selector(previousQuestionButtonAction(_:)),
            for: .touchUpInside
        )
        
        actionButton.setTitle("Next", for: .normal)
    }
    
    private func bindViewModel() {
        viewModel.outActions = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .questionsFetched:
                self.setQuestion()
            case let .optionSelected(path, previousPath, isOn):
                self.optionSelected(path, previousPath: previousPath, isOn: isOn)
            case .moveToNextQuestion:
                self.setQuestion()
            case let .showResult(isPassed):
                self.showResultViewController(isPassed)
            }
        }
        
        viewModel.fetch()
    }
    
    func setQuestion() {
        label.backgroundColor = .gray
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        label.textColor = .white
        label.text = viewModel.currentQuestion
        tableView.reloadData()
    }

    @objc func nextQuestionButtonAction(_ sender: UIButton) {
        viewModel.inActions?(.nextButtonAction)
    }
    
    @objc func previousQuestionButtonAction(_ sender: UIButton) {
        viewModel.inActions?(.previousQuestion)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let isSelected = viewModel.isOptionPreSelected(indexPath)
        cell.answerSelectedSwitch.isOn = isSelected
        cell.label.text = viewModel.choices[indexPath.row]
        cell.questionNumberLabel.text = "\(indexPath.row + 1)"
        if isSelected {
            cell.select()
        } else {
            cell.unselect()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inActions?(.optionSelected(indexPath))
    }
    
    func optionSelected(_ indexPath: IndexPath, previousPath: IndexPath?, isOn: Bool) {
        if let previousPath = previousPath {
            let cell = tableView.cellForRow(at: previousPath) as! TableViewCell
            cell.unselect()
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        if isOn {
            cell.select()
        } else {
            cell.unselect()
        }
    }
    
    func showResultViewController(_ isPassed: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        controller.viewModel = ResultViewModel(isPassed: isPassed)
        present(controller, animated: true, completion: nil)
    }
}

