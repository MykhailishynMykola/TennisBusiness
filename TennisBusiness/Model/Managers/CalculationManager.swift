//
//  CalculationManager.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/16/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import Foundation
import Swinject

protocol CalculationManager {
    func start(with worlds: [World])
}

final class CalculationManagerImp: CalculationManager, ResolverInitializable {
    // MARK: - Inner
    
    private struct Constants {
        static let calculationTimeBeforeMatch: TimeInterval = 3 * 60 // 3 min
        static let weeksBeforeTournamentsCreation = 6 * 4 // half a year . Should be less than year
        static let weeksInYear = 53
    }
    
    
    
    // MARK: - Properties
    
    private var worlds: [World] = []
    private var timer: Timer?
    private let calendar = NSCalendar.current
    private let dataManager: DataManager
    private let tournamentsTemplateManager: TournamentsTemplateManager
    
    
    
    // MARK: - Init
    
    init(dataManager: DataManager, tournamentsTemplateManager: TournamentsTemplateManager) {
        self.dataManager = dataManager
        self.tournamentsTemplateManager = tournamentsTemplateManager
    }
    
    
    
    // MARK: - ResolverInitializable
    
    convenience init?(resolver: Resolver) {
        guard let dataManager = resolver.resolve(DataManager.self),
            let tournamentsTemplateManager = resolver.resolve(TournamentsTemplateManager.self) else {
            print("Warning: Failed to initilize all needed dependencies!")
            return nil
        }
        self.init(dataManager: dataManager, tournamentsTemplateManager: tournamentsTemplateManager)
    }
    
    
    
    // MARK: - Public
    
    func start(with worlds: [World]) {
        self.worlds = worlds
        timer?.invalidate()
        timer = Timer.every(1) { [weak self] in
            guard let `self` = self else { return }
            for world in self.worlds {
                self.checkMatches(for: world)
                self.checkTournaments(for: world)
            }
        }
    }
    
    
    
    // MARK: - Private
    
    private func checkMatches(for world: World) {
        let unfinishedMatches = world.matches.filter { !$0.isFinished }
        for match in unfinishedMatches {
            let diff = match.eventDate.timeIntervalSince(world.currentWorldDate)
            let timeBeroreCalculation = Constants.calculationTimeBeforeMatch * world.speed
            if diff < timeBeroreCalculation  {
                match.calculateResult()
                dataManager.setMatchResult(match, worldIdentifier: world.identifier)
                    .catch { _ in }
            }
        }
    }
    
    private func checkTournaments(for world: World) {
        let currentWeek = calendar.component(.weekOfYear, from: world.currentWorldDate)
        let weekDiff = Constants.weeksInYear - currentWeek
        let currentYearTemplates: [TournamentTemplate]
        let nextYearTemplates: [TournamentTemplate]
        if weekDiff > Constants.weeksBeforeTournamentsCreation {
            currentYearTemplates = tournamentsTemplateManager.tournamentsTemplate.filter { (currentWeek...currentWeek+Constants.weeksBeforeTournamentsCreation).contains($0.week) }
            nextYearTemplates = []
        }
        else {
            currentYearTemplates = tournamentsTemplateManager.tournamentsTemplate.filter { (currentWeek...Constants.weeksInYear).contains($0.week) }
            let remains = Constants.weeksBeforeTournamentsCreation - weekDiff
            if remains > 0 {
                nextYearTemplates = tournamentsTemplateManager.tournamentsTemplate.filter { (1...remains).contains($0.week) }
            }
            else {
                nextYearTemplates = []
            }
        }
        let currentYear = calendar.component(.year, from: world.currentWorldDate)
        let currentYearTournaments = createTournamentsData(by: currentYearTemplates, year: currentYear)
        let nextYearTournaments = createTournamentsData(by: nextYearTemplates, year: currentYear+1)
        let createdTournaments = (currentYearTournaments + nextYearTournaments).filter { tournament -> Bool in
            guard let lastCreatedTournamentDate = world.lastCreatedTournamentDate else { return true }
            return tournament.startDate > lastCreatedTournamentDate
        }
        guard let newLastCreatedTournamentDate = createdTournaments.sorted(by: { $0.startDate > $1.startDate }).first?.startDate else {
            return
        }
        world.lastCreatedTournamentDate = newLastCreatedTournamentDate
        
        dataManager.addTournaments(createdTournaments, worldIdentifier: world.identifier)
            .then { tournaments in
               world.tournaments.append(contentsOf: tournaments)
        }
    }
    
    private func createTournamentsData(by templates: [TournamentTemplate], year: Int) -> [TournamentData] {
        var result = [TournamentData]()
        for template in templates {
            let components = DateComponents(year: year, month: 1, day: 1, hour: 0, minute: 0, second: 0)
            guard let firstDateOfCurrentYear = calendar.date(from: components),
                let tournamentStartDate = calendar.date(byAdding: .day, value: 7 * template.week, to: firstDateOfCurrentYear) else {
                    break
            }
            let tournament = TournamentData(template: template, startDate: tournamentStartDate)
            result.append(tournament)
        }
        return result
    }
}
