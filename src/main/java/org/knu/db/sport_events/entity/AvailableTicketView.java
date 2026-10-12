package org.knu.db.sport_events.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

@Entity
@Immutable
@Table(name = "vw_available_tickets")
@Getter
public class AvailableTicketView {
    @Id
    @Column(name = "ticket_id")
    private Long id;

    private Double price;

    @Column(name = "seat_number")
    private String seatNumber;

    @Column(name = "event_title")
    private String eventTitle;
}
