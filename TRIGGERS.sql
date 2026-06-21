USE RankForge
GO

CREATE TRIGGER trgPlayerGameProfile_RankHistory
ON tblPlayerGameProfile
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE(intCurrentRank)
        RETURN;

    INSERT INTO tblRankHistory
    (
        intProfileID,
        intMatchID,
        intPreviousRank,
        intNewRank
    )
    SELECT
        i.intProfileID,
        NULL,
        d.intCurrentRank,
        i.intCurrentRank

    FROM inserted i
    INNER JOIN deleted d
        ON i.intProfileID = d.intProfileID

    WHERE i.intCurrentRank <> d.intCurrentRank;
END;


GO


CREATE TRIGGER trgMatchStatistic_Validate
ON tblMatchStatistic
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE decValue > 1000000
    )
    BEGIN
        THROW 50031,
              'Statistic value exceeds allowed limit.',
              1;
    END;
END;


GO


