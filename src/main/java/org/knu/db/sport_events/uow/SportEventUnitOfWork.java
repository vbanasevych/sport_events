package org.knu.db.sport_events.uow;

import org.knu.db.sport_events.repository.EventRepository;
import org.knu.db.sport_events.repository.MatchRepository;
import org.knu.db.sport_events.repository.TicketRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
public class SportEventUnitOfWork {

    private final EventRepository eventRepository;
    private final TicketRepository ticketRepository;
    private final MatchRepository matchRepository;

    public EventRepository events() {
        return eventRepository;
    }

    public TicketRepository tickets() {
        return ticketRepository;
    }

    public MatchRepository matches() {
        return matchRepository;
    }

    /**
     * Управління складною транзакцією.
     * Якщо будь-яка процедура викине помилку, всі зміни відкотяться (Rollback).
     */
    @Transactional
    public void processEventCancellationAndRefund(Long eventId, Long adminId) {
        // Викликаємо процедуру скасування події (Soft Delete)
        eventRepository.softDeleteEvent(eventId, adminId);
    }

    @Transactional
    public void processTicketPurchase(Long ticketId, Long userId) {
        ticketRepository.buyTicket(ticketId, userId);
    }

    @Transactional
    public void registerFinalMatchResultAndCloseEvent(Long matchId, Long teamId, Integer score, Long eventId, Long adminId) {
        // Одночасно оновлюємо рахунок матчу і видаляємо/закриваємо подію в одній транзакції
        matchRepository.updateMatchScoreProcedure(matchId, teamId, score, true);
        eventRepository.softDeleteEvent(eventId, adminId);
    }
}
