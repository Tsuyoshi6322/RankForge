

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