package org.knu.db.sport_events.controller;

import org.knu.db.sport_events.uow.SportEventUnitOfWork;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/db-lab")
@RequiredArgsConstructor
public class DatabaseLabController {

    private final SportEventUnitOfWork uow;

    // Читання даних з БД (через View vw_active_events)
    @GetMapping("/events/{sport}")
    public Iterable<?> getEventsBySport(@PathVariable String sport) {
        return uow.events().findBySportName(sport);
    }

    // Читання доступних квитків (через View vw_available_tickets)
    @GetMapping("/tickets/{eventTitle}")
    public Iterable<?> getAvailableTickets(@PathVariable String eventTitle) {
        return uow.tickets().findByEventTitle(eventTitle);
    }

    // Зміна даних (через Збережену процедуру sp_buy_ticket)
    @PostMapping("/buy-ticket")
    public String buyTicket(@RequestParam Long ticketId, @RequestParam Long userId) {
        uow.tickets().buyTicket(ticketId, userId);
        return "Квиток #" + ticketId + " успішно придбано користувачем #" + userId + " через процедуру!";
    }

    // Комплексна транзакція: запис результату і закриття події
    @PostMapping("/finish-match")
    public String finishMatch(@RequestParam Long matchId, @RequestParam Long teamId, @RequestParam Long eventId) {
        uow.registerFinalMatchResultAndCloseEvent(matchId, teamId, 3, eventId, 1L);
        return "Транзакція (Unit of Work) виконана: рахунок оновлено, турнір закрито!";
    }
}
