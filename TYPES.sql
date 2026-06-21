USE RankForge
GO

CREATE TYPE typMatchParticipant AS TABLE
(
    intProfileID    INT,
    intPlacement    INT,
    bitIsWinner     BIT
);

GO