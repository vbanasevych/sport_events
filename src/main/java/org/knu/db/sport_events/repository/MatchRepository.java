package org.knu.db.sport_events.repository;

import org.knu.db.sport_events.entity.MatchEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface MatchRepository extends JpaRepository<MatchEntity, Long> {

    @Modifying
    @Query(value = "CALL sp_update_match_score(:matchId, :teamId, :score, :isWinner)", nativeQuery = true)
    void updateMatchScoreProcedure(
            @Param("matchId") Long matchId,
            @Param("teamId") Long teamId,
            @Param("score") Integer score,
            @Param("isWinner") Boolean isWinner
    );
}
