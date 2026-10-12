package org.knu.db.sport_events.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "matches")
public class MatchEntity {
    @Id
    private Long id;
    private String round;
}
