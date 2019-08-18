//
//  Match.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation

class Match {
    // MARK: - Properties

    let identifier: String
    let firstPlayer: Player
    let secondPlayer: Player
    let setsToWin: Int
    let eventDate: Date
    var serveTurn: ServeTurn
    
    var isFinished: Bool {
        return !result.isEmpty
    }
    
    private(set) var result: String
    private(set) var intermediateResult: String = ""
    private var sets: [Set]
    
    
    
    // MARK: - Init
    
    init(identifier: String, firstPlayer: Player, secondPlayer: Player, setsToWin: Int, eventDate: Date, result: String) {
        self.identifier = identifier
        self.firstPlayer = firstPlayer
        self.secondPlayer = secondPlayer
        self.setsToWin = setsToWin
        self.eventDate = eventDate
        self.result = result
        let serveTurn: ServeTurn = Bool.random() ? .firstPlayer : .secondPlayer
        self.serveTurn = serveTurn
        self.sets = [Set(identifier: 1, firstGameServeTurn: serveTurn)]
    }
    
    
    
    // MARK: - Public
    
    func calculateResult() {
        guard !isFinished else { return }
        while !isFinished {
            handleNext()
        }
        return
    }
    
    
    // MARK: - Private
    
    private func handleNext() {
        guard let currentSet = sets.first(where: { $0.status == .inProgress }),
            let currentGame = currentSet.games.first(where: { $0.status == .inProgress }) else {
            print("Error: Can't find current set or game for match \(identifier)")
            return
        }
        let nextResult = calculateNextResult()
        let currentResult = nextResult == .firstWin ? "f" : "s"
        intermediateResult = "\(intermediateResult)\(currentResult)"
        guard !currentGame.isTiebreak else {
            handleNextTiebreak(with: nextResult, currentGame: currentGame, currentSet: currentSet)
            return
        }
        let currentPoints = currentGame.points
        switch (currentPoints.0, currentPoints.1, nextResult) {
        case (.fourty, .fourty, .firstWin):
            currentGame.points = (.advantage, .disadvantage)
        case (.fourty, .fourty, .secondWin):
            currentGame.points = (.disadvantage, .advantage)
        case (.advantage, _, .secondWin),
             (_, .advantage, .firstWin):
            currentGame.points = (.fourty, .fourty)
        case (.fourty, _, .firstWin),
             (.advantage, _, .firstWin):
            currentGame.status = .firstWin
            createNewGame(withIdentifier: currentGame.identifier + 1,
                          currentSet: currentSet)
        case (_, .fourty, .secondWin),
             (_, .advantage, .secondWin):
            currentGame.status = .secondWin
            createNewGame(withIdentifier: currentGame.identifier + 1,
                          currentSet: currentSet)
        default:
            takeNext(for: nextResult, game: currentGame)
        }
    }
    
    private func createNewGame(withIdentifier identifier: Int, currentSet: Set) {
        var nextServeTurn = serveTurn.next(isTiebreak: false)
        switch (currentSet.gamesFirstWin, currentSet.gamesSecondWin) {
        case (6, 6):
            nextServeTurn = nextServeTurn.next(isTiebreak: true)
            currentSet.games.append(Game(identifier: identifier, isTiebreak: true, serveTurn: nextServeTurn))
        case (6, 5), (5, 6):
            currentSet.games.append(Game(identifier: identifier, isTiebreak: false, serveTurn: nextServeTurn))
        case (7, 5), (7, 6), (6, _):
            currentSet.status = .firstWin
            createNewSet(with: currentSet.identifier + 1)
        case (5, 7), (6, 7), (_, 6):
            currentSet.status = .secondWin
            createNewSet(with: currentSet.identifier + 1)
        default:
            currentSet.games.append(Game(identifier: identifier, isTiebreak: false, serveTurn: nextServeTurn))
        }
        serveTurn = nextServeTurn
    }
    
    private func createNewSet(with identifier: Int) {
        let firstSetsWin = sets.filter { $0.status == .firstWin }.count
        let secondSetsWin = sets.filter { $0.status == .secondWin }.count
        if firstSetsWin == setsToWin || secondSetsWin == setsToWin {
            result = intermediateResult
            return
        }
        serveTurn = serveTurn.next(isTiebreak: false)
        sets.append(Set(identifier: identifier, firstGameServeTurn: serveTurn))
    }
    
    private func handleNextTiebreak(with status: Status, currentGame: Game, currentSet: Set) {
        serveTurn = serveTurn.next(isTiebreak: true)
        let points = currentGame.tiebreakPoints
        switch status {
        case .firstWin where points.0 >= 7 && (points.0-points.1) == 2:
            currentGame.status = .firstWin
            createNewGame(withIdentifier: currentGame.identifier + 1, currentSet: currentSet)
        case .secondWin where points.1 >= 7 && (points.1-points.0) == 2:
            currentGame.status = .secondWin
            createNewGame(withIdentifier: currentGame.identifier + 1, currentSet: currentSet)
        case .firstWin:
            currentGame.tiebreakPoints.0 += 1
        case .secondWin:
            currentGame.tiebreakPoints.1 += 1
        default:
            print("Error: Unhandled tiebreak case")
            return
        }
    }
    
    private func takeNext(for status: Status, game: Game) {
        switch status {
        case .firstWin:
            guard let nextPoint = Point.next(after: game.points.0) else {
                print("Error: There aren't point after \(game.points.0)")
                return
            }
            game.points = (nextPoint, game.points.1)
        case .secondWin:
            guard let nextPoint = Point.next(after: game.points.1) else {
                print("Error: There aren't point after \(game.points.1)")
                return
            }
            game.points = (game.points.0, nextPoint)
        default:
            print("Error: There aren't point for status \(status)")
            return
        }
    }
    
    private func calculateNextResult() -> Status {
        let firstPlayerAbility = firstPlayer.ability
        let secondPlayerAbility = secondPlayer.ability
        
        let skillDiff = firstPlayerAbility.skill.doubleValue - secondPlayerAbility.skill.doubleValue
        let serveDiff: Double
        let constantServeAdvantage: Double = 0.5
        if serveTurn.isFirstPlayerServe {
            serveDiff = constantServeAdvantage + firstPlayerAbility.serve.doubleValue - secondPlayerAbility.returnOfServe.doubleValue
        }
        else {
            serveDiff = -(constantServeAdvantage + secondPlayerAbility.serve.doubleValue - firstPlayerAbility.returnOfServe.doubleValue)
        }
        let random = Int.random(from: 1, to: 100)
        let firstPlayerAdvantage = Double(random) + skillDiff * 10 + serveDiff * 10
        return firstPlayerAdvantage > 50 ? .firstWin : .secondWin
    }
}
