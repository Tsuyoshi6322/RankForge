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


CREATE PROCEDURE uspRegisterMatch
(
    @intGameID     INT,
    @intSeasonID   INT,
    @dtMatchDate   DATETIME2,

    @Participants typMatchParticipant READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    BEGIN TRY

        DECLARE @intMatchID INT;

        INSERT INTO tblMatch
        (
            intGameID,
            intSeasonID,
            dtMatchDate,
            nvcStatus
        )
        VALUES
        (
            @intGameID,
            @intSeasonID,
            @dtMatchDate,
            'Completed'
        );

        SET @intMatchID = SCOPE_IDENTITY();

        INSERT INTO tblMatchParticipant
        (
            intMatchID,
            intProfileID,
            intPlacement,
            bitIsWinner
        )
        SELECT
            @intMatchID,
            intProfileID,
            intPlacement,
            bitIsWinner
        FROM @Participants;

        UPDATE p
        SET
            intMatchesPlayed = intMatchesPlayed + 1
        FROM tblPlayerGameProfile p
        INNER JOIN @Participants pr
            ON p.intProfileID = pr.intProfileID;

        UPDATE p
        SET
            intWins = intWins + 1
        FROM tblPlayerGameProfile p
        INNER JOIN @Participants pr
            ON p.intProfileID = pr.intProfileID
        WHERE pr.bitIsWinner = 1;

        UPDATE p
        SET
            intLosses = intLosses + 1
        FROM tblPlayerGameProfile p
        INNER JOIN @Participants pr
            ON p.intProfileID = pr.intProfileID
        WHERE pr.bitIsWinner = 0;

        COMMIT TRANSACTION;

        SELECT
            @intMatchID AS intMatchID;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH
END;

GO
