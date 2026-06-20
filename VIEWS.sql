

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

