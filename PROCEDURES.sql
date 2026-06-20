CREATE PROCEDURE uspAddPlayerToGame
(
    @intPlayerID INT,
    @intGameID   INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM tblPlayer
        WHERE intPlayerID = @intPlayerID
    )
    BEGIN
        THROW 50001, 'Player does not exist.', 1;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM tblGame
        WHERE intGameID = @intGameID
    )
    BEGIN
        THROW 50002, 'Game does not exist.', 1;
    END;

    IF EXISTS (
        SELECT 1
        FROM tblPlayerGameProfile
        WHERE intPlayerID = @intPlayerID
          AND intGameID = @intGameID
    )
    BEGIN
        THROW 50003, 'Player already has a profile for this game.', 1;
    END;

    INSERT INTO tblPlayerGameProfile
    (
        intPlayerID,
        intGameID
    )
    VALUES
    (
        @intPlayerID,
        @intGameID
    );

    SELECT
        intProfileID,
        intPlayerID,
        intGameID,
        intCurrentRank,
        intMatchesPlayed,
        intWins,
        intLosses,
        dtCreatedAt
    FROM tblPlayerGameProfile
    WHERE intProfileID = SCOPE_IDENTITY();
END;


GO

