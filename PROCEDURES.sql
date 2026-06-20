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


CREATE PROCEDURE uspUpdatePlayerRanking
(
    @intMatchID INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    BEGIN TRY

        DECLARE
            @intProfileID      INT,
            @bitIsWinner       BIT,
            @intPreviousRank   INT,
            @intNewRank        INT;

        DECLARE curParticipants CURSOR LOCAL FAST_FORWARD FOR

            SELECT
                pgp.intProfileID,
                mp.bitIsWinner,
                pgp.intCurrentRank
            FROM tblMatchParticipant mp
            INNER JOIN tblPlayerGameProfile pgp
                ON mp.intProfileID = pgp.intProfileID
            WHERE mp.intMatchID = @intMatchID;

        OPEN curParticipants;

        FETCH NEXT FROM curParticipants
        INTO
            @intProfileID,
            @bitIsWinner,
            @intPreviousRank;

        WHILE @@FETCH_STATUS = 0
        BEGIN

            IF @bitIsWinner = 1
                SET @intNewRank = @intPreviousRank + 25;
            ELSE
                SET @intNewRank =
                    CASE
                        WHEN @intPreviousRank >= 25
                            THEN @intPreviousRank - 25
                        ELSE 0
                    END;

            UPDATE tblPlayerGameProfile
            SET intCurrentRank = @intNewRank
            WHERE intProfileID = @intProfileID;

            INSERT INTO tblRankHistory
            (
                intProfileID,
                intMatchID,
                intPreviousRank,
                intNewRank
            )
            VALUES
            (
                @intProfileID,
                @intMatchID,
                @intPreviousRank,
                @intNewRank
            );

            FETCH NEXT FROM curParticipants
            INTO
                @intProfileID,
                @bitIsWinner,
                @intPreviousRank;

        END

        CLOSE curParticipants;
        DEALLOCATE curParticipants;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH
END;

GO