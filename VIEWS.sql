

CREATE VIEW vwLeaderboard
AS
SELECT
    RANK() OVER (
        PARTITION BY g.intGameID
        ORDER BY pgp.intCurrentRank DESC
    ) AS intPosition,

    g.intGameID,
    g.nvcName AS nvcGameName,

    p.intPlayerID,
    p.nvcNickname,

    pgp.intProfileID,
    pgp.intCurrentRank,
    pgp.intMatchesPlayed,
    pgp.intWins,
    pgp.intLosses,

    CAST(
        CASE
            WHEN pgp.intMatchesPlayed = 0 THEN 0
            ELSE (pgp.intWins * 100.0) / pgp.intMatchesPlayed
        END
        AS DECIMAL(5,2)
    ) AS decWinRate

FROM tblPlayerGameProfile pgp
INNER JOIN tblPlayer p
    ON pgp.intPlayerID = p.intPlayerID
INNER JOIN tblGame g
    ON pgp.intGameID = g.intGameID;

GO


CREATE VIEW vwPlayerStatistics
AS
SELECT
    p.intPlayerID,
    p.nvcNickname,

    g.intGameID,
    g.nvcName AS nvcGameName,

    pgp.intProfileID,

    pgp.intCurrentRank,
    pgp.intMatchesPlayed,
    pgp.intWins,
    pgp.intLosses,

    CAST(
        CASE
            WHEN pgp.intMatchesPlayed = 0 THEN 0
            ELSE (pgp.intWins * 100.0) / pgp.intMatchesPlayed
        END
        AS DECIMAL(5,2)
    ) AS decWinRate,

    st.nvcName AS nvcStatisticName,

    CAST(
        AVG(ms.decValue)
        AS DECIMAL(18,2)
    ) AS decAverageValue,

    MIN(ms.decValue) AS decMinimumValue,

    MAX(ms.decValue) AS decMaximumValue,

    COUNT(ms.intStatisticID) AS intRecordedValues

FROM tblPlayerGameProfile pgp

INNER JOIN tblPlayer p
    ON pgp.intPlayerID = p.intPlayerID

INNER JOIN tblGame g
    ON pgp.intGameID = g.intGameID

INNER JOIN tblMatchParticipant mp
    ON pgp.intProfileID = mp.intProfileID

INNER JOIN tblMatchStatistic ms
    ON mp.intParticipantID = ms.intParticipantID

INNER JOIN tblGameStatisticType gst
    ON ms.intGameStatisticTypeID = gst.intGameStatisticTypeID

INNER JOIN tblStatisticType st
    ON gst.intStatisticTypeID = st.intStatisticTypeID

GROUP BY
    p.intPlayerID,
    p.nvcNickname,

    g.intGameID,
    g.nvcName,

    pgp.intProfileID,
    pgp.intCurrentRank,
    pgp.intMatchesPlayed,
    pgp.intWins,
    pgp.intLosses,

    st.nvcName;


GO


CREATE VIEW vwRankingHistory
AS
SELECT
    rh.intRankHistoryID,

    p.intPlayerID,
    p.nvcNickname,

    g.intGameID,
    g.nvcName AS nvcGameName,

    pgp.intProfileID,

    rh.intMatchID,

    rh.intPreviousRank,
    rh.intNewRank,

    (rh.intNewRank - rh.intPreviousRank)
        AS intRankChange,

    rh.dtChangeDate

FROM tblRankHistory rh

INNER JOIN tblPlayerGameProfile pgp
    ON rh.intProfileID = pgp.intProfileID

INNER JOIN tblPlayer p
    ON pgp.intPlayerID = p.intPlayerID

INNER JOIN tblGame g
    ON pgp.intGameID = g.intGameID;


GO


CREATE VIEW vwMatchDetails
AS
SELECT
    m.intMatchID,

    g.intGameID,
    g.nvcName AS nvcGameName,

    s.intSeasonID,
    s.nvcName AS nvcSeasonName,

    m.dtMatchDate,
    m.nvcStatus,

    p.intPlayerID,
    p.nvcNickname,

    pgp.intProfileID,
    pgp.intCurrentRank,

    mp.intPlacement,
    mp.bitIsWinner

FROM tblMatch m

INNER JOIN tblGame g
    ON m.intGameID = g.intGameID

INNER JOIN tblSeason s
    ON m.intSeasonID = s.intSeasonID

INNER JOIN tblMatchParticipant mp
    ON m.intMatchID = mp.intMatchID

INNER JOIN tblPlayerGameProfile pgp
    ON mp.intProfileID = pgp.intProfileID

INNER JOIN tblPlayer p
    ON pgp.intPlayerID = p.intPlayerID;


GO


CREATE VIEW vwGamePerformance
AS
SELECT
    p.intPlayerID,
    p.nvcNickname,

    g.intGameID,
    g.nvcName AS nvcGameName,
    g.nvcGenre,

    pgp.intProfileID,

    pgp.intCurrentRank,
    pgp.intMatchesPlayed,
    pgp.intWins,
    pgp.intLosses,

    CAST(
        CASE
            WHEN pgp.intMatchesPlayed = 0 THEN 0
            ELSE (pgp.intWins * 100.0) / pgp.intMatchesPlayed
        END
        AS DECIMAL(5,2)
    ) AS decWinRate,

    RANK() OVER (
        PARTITION BY g.intGameID
        ORDER BY pgp.intCurrentRank DESC
    ) AS intGameRankPosition

FROM tblPlayerGameProfile pgp

INNER JOIN tblPlayer p
    ON pgp.intPlayerID = p.intPlayerID

INNER JOIN tblGame g
    ON pgp.intGameID = g.intGameID;


GO