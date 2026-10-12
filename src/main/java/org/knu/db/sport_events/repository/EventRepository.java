package org.knu.db.sport_events.repository;

import org.knu.db.sport_events.entity.ActiveEventView;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface EventRepository extends JpaRepository<ActiveEventView, Long> {

    // Читання йде через View vw_active_events
    Iterable<ActiveEventView> findBySportName(String sportName);

    // Запис — строго через виклик збереженої процедури
    @Modifying
    @Query(value = "CALL sp_soft_delete_event(:eventId, :userId)", nativeQuery = true)
    void softDeleteEvent(@Param("eventId") Long eventId, @Param("userId") Long userId);
}
