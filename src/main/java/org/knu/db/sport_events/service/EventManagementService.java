package org.knu.db.sport_events.service;

import org.knu.db.sport_events.entity.ActiveEventView;
import org.knu.db.sport_events.entity.AvailableTicketView;
import org.knu.db.sport_events.uow.SportEventUnitOfWork;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EventManagementService {

    private final SportEventUnitOfWork uow;

    public void buyTicket(Long ticketId, Long userId) {
        uow.processTicketPurchase(ticketId, userId);
    }

    public void cancelEvent(Long eventId, Long adminId) {
        uow.processEventCancellationAndRefund(eventId, adminId);
    }

    public Iterable<ActiveEventView> getAvailableEventsForSport(String sport) {
        // Читання йде через View
        return uow.events().findBySportName(sport);
    }

    public Iterable<AvailableTicketView> getTicketsForEvent(String eventTitle) {
        // Читання йде через View
        return uow.tickets().findByEventTitle(eventTitle);
    }
}
