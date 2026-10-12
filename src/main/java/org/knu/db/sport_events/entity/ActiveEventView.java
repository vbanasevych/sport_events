package org.knu.db.sport_events.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.Immutable;
import lombok.Getter;
import java.time.LocalDateTime;

@Entity
@Immutable // Сутність лише для читання
@Table(name = "vw_active_events")
@Getter
public class ActiveEventView {
    @Id
    @Column(name = "event_id")
    private Long id;

    private String title;

    @Column(name = "sport_name")
    private String sportName;

    @Column(name = "location_name")
    private String locationName;

    @Column(name = "start_date")
    private LocalDateTime startDate;

    private String status;
}
