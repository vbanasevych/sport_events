package org.knu.db.sport_events.repository;

import org.knu.db.sport_events.entity.AvailableTicketView;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface TicketRepository extends JpaRepository<AvailableTicketView, Long> {

    // Читання йде через View vw_available_tickets
    Iterable<AvailableTicketView> findByEventTitle(String eventTitle);

    @Modifying
    @Query(value = "CALL sp_buy_ticket(:ticketId, :userId)", nativeQuery = true)
    void buyTicket(@Param("ticketId") Long ticketId, @Param("userId") Long userId);
}
