
CREATE TABLE tblPlayer (
    intPlayerID    INT             IDENTITY(1,1) PRIMARY KEY,
    nvcNickname    NVARCHAR(50)    NOT NULL,
    nvcEmail       NVARCHAR(255)   NOT NULL,
    nvcCountry     NVARCHAR(100)   NULL,

    RegistrationDate DATETIME2 NOT NULL
        CONSTRAINT DF_Player_RegistrationDate
        DEFAULT GETDATE(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Player_IsActive
        DEFAULT 1,

    CONSTRAINT UQ_Player_Nickname   UNIQUE (nvcNickname),
    CONSTRAINT UQ_Player_Email      UNIQUE (nvcEmail)
);

CREATE INDEX IX_Player_Nickname ON tblPlayer(nvcNickname);
CREATE INDEX IX_Player_Country  ON tblPlayer(nvcCountry);


GO


CREATE TABLE tblGame (
    intGameID       INT                 IDENTITY(1,1) PRIMARY KEY,
    nvcName         NVARCHAR(100)       NOT NULL,
    nvcGenre        NVARCHAR(50)        NOT NULL,
    dReleaseDate    DATE                NULL,
    nvcDeveloper    NVARCHAR(100)       NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_Game_IsActive
        DEFAULT 1,

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Game_CreatedAt
        DEFAULT GETDATE(),

    CONSTRAINT UQ_Game_Name UNIQUE (nvcName)
);

CREATE INDEX IX_Game_Name   ON tblGame(nvcName);
CREATE INDEX IX_Game_Genre  ON tblGame(nvcGenre);


GO


CREATE TABLE tblSeason (
    intSeasonID INT             IDENTITY(1,1)   CONSTRAINT PK_Season PRIMARY KEY,
    intGameID   INT             NOT NULL,
    nvcName     NVARCHAR(100)   NOT NULL,
    dStartDate  DATE            NOT NULL,
    dEndDate    DATE            NOT NULL,
    bitIsActive BIT             NOT NULL        CONSTRAINT DF_Season_IsActive   DEFAULT 1,
    dtCreatedAt DATETIME2       NOT NULL        CONSTRAINT DF_Season_CreatedAt  DEFAULT GETDATE(),

    CONSTRAINT FK_Season_Game       FOREIGN KEY (intGameID) REFERENCES tblGame(intGameID),
    CONSTRAINT CHK_Season_DateRange CHECK (dEndDate > dStartDate),
    CONSTRAINT UQ_Season_Game_Name  UNIQUE (intGameID, nvcName)
);

CREATE INDEX IX_Season_GameID   ON tblSeason(intGameID);
CREATE INDEX IX_Season_IsActive ON tblSeason(bitIsActive);


GO


CREATE TABLE tblPlayerGameProfile (
    intProfileID        INT         IDENTITY(1,1)   CONSTRAINT PK_PlayerGameProfile     PRIMARY KEY,
    intPlayerID         INT         NOT NULL,
    intGameID           INT         NOT NULL,
    intCurrentRank      INT         NOT NULL        CONSTRAINT DF_Profile_CurrentRank   DEFAULT 1000,
    intMatchesPlayed    INT         NOT NULL        CONSTRAINT DF_Profile_MatchesPlayed DEFAULT 0,
    intWins             INT         NOT NULL        CONSTRAINT DF_Profile_Wins          DEFAULT 0,
    intLosses           INT         NOT NULL        CONSTRAINT DF_Profile_Losses        DEFAULT 0,
    dtCreatedAt         DATETIME2   NOT NULL        CONSTRAINT DF_Profile_CreatedAt     DEFAULT GETDATE(),

    CONSTRAINT FK_Profile_Player            FOREIGN KEY (intPlayerID)   REFERENCES tblPlayer(intPlayerID),
    CONSTRAINT FK_Profile_Game              FOREIGN KEY (intGameID)     REFERENCES tblGame(intGameID),
    CONSTRAINT UQ_Profile_Player_Game       UNIQUE (intPlayerID, intGameID),
    CONSTRAINT CHK_Profile_CurrentRank      CHECK (intCurrentRank >= 0),
    CONSTRAINT CHK_Profile_MatchesPlayed    CHECK (intMatchesPlayed >= 0),
    CONSTRAINT CHK_Profile_Wins             CHECK (intWins >= 0),
    CONSTRAINT CHK_Profile_Losses           CHECK (intLosses >= 0)
);

CREATE INDEX IX_Profile_PlayerID    ON tblPlayerGameProfile(intPlayerID);
CREATE INDEX IX_Profile_GameID      ON tblPlayerGameProfile(intGameID);
CREATE INDEX IX_Profile_Rank        ON tblPlayerGameProfile(intCurrentRank);


GO


CREATE TABLE tblMatch (
    intMatchID  INT             IDENTITY(1,1)    CONSTRAINT PK_Match         PRIMARY KEY,
    intGameID   INT             NOT NULL,
    intSeasonID INT             NOT NULL,
    dtMatchDate DATETIME2       NOT NULL         CONSTRAINT DF_Match_Date    DEFAULT GETDATE(),
    nvcStatus   NVARCHAR(50)    NOT NULL         CONSTRAINT DF_Match_Status  DEFAULT 'Completed',

    CONSTRAINT FK_Match_Game    FOREIGN KEY (intGameID)     REFERENCES tblGame(intGameID),
    CONSTRAINT FK_Match_Season  FOREIGN KEY (intSeasonID)   REFERENCES tblSeason(intSeasonID)
);

CREATE INDEX IX_Match_GameID    ON tblMatch(intGameID);
CREATE INDEX IX_Match_SeasonID  ON tblMatch(intSeasonID);
CREATE INDEX IX_Match_Date      ON tblMatch(dtMatchDate);


GO


CREATE TABLE tblMatchParticipant (
    intParticipantID    INT  IDENTITY(1,1)  CONSTRAINT PK_MatchParticipant          PRIMARY KEY,
    intMatchID          INT  NOT NULL,
    intProfileID        INT  NOT NULL,
    intPlacement        INT  NULL,
    bitIsWinner         BIT  NOT NULL       CONSTRAINT DF_MatchParticipant_IsWinner DEFAULT 0,

    CONSTRAINT FK_MatchParticipant_Match        FOREIGN KEY (intMatchID)    REFERENCES tblMatch(intMatchID),
    CONSTRAINT FK_MatchParticipant_Profile      FOREIGN KEY (intProfileID)  REFERENCES tblPlayerGameProfile(intProfileID),
    CONSTRAINT UQ_MatchParticipant              UNIQUE (intMatchID, intProfileID),  
    CONSTRAINT CHK_MatchParticipant_Placement   CHECK (intPlacement IS NULL OR intPlacement > 0)
);

CREATE INDEX IX_MatchParticipant_MatchID    ON tblMatchParticipant(intMatchID);
CREATE INDEX IX_MatchParticipant_ProfileID  ON tblMatchParticipant(intProfileID);


GO


CREATE TABLE tblStatisticType (
    intStatisticTypeID  INT           IDENTITY(1,1)   CONSTRAINT PK_StatisticType             PRIMARY KEY,
    nvcName             NVARCHAR(100) NOT NULL,
    nvcDescription      NVARCHAR(500) NULL,
    bitIsActive         BIT           NOT NULL        CONSTRAINT DF_StatisticType_IsActive    DEFAULT 1,
    dtCreatedAt         DATETIME2     NOT NULL        CONSTRAINT DF_StatisticType_CreatedAt   DEFAULT GETDATE(),

    CONSTRAINT UQ_StatisticType_Name    UNIQUE (nvcName)
);

CREATE INDEX IX_StatisticType_Name  ON tblStatisticType(nvcName);


GO


CREATE TABLE tblGameStatisticType (
    intGameStatisticTypeID  INT         IDENTITY(1,1)   CONSTRAINT PK_GameStatisticType             PRIMARY KEY,
    intGameID               INT         NOT NULL,
    intStatisticTypeID      INT         NOT NULL,
    dtCreatedAt             DATETIME2   NOT NULL        CONSTRAINT DF_GameStatisticType_CreatedAt   DEFAULT GETDATE(),

    CONSTRAINT FK_GameStatisticType_Game            FOREIGN KEY (intGameID)             REFERENCES tblGame(intGameID),
    CONSTRAINT FK_GameStatisticType_StatisticType   FOREIGN KEY (intStatisticTypeID)    REFERENCES tblStatisticType(intStatisticTypeID),
    CONSTRAINT UQ_GameStatisticType                 UNIQUE (intGameID,intStatisticTypeID)
);

CREATE INDEX IX_GameStatisticType_GameID            ON tblGameStatisticType(intGameID);
CREATE INDEX IX_GameStatisticType_StatisticTypeID   ON tblGameStatisticType(intStatisticTypeID);


GO


CREATE TABLE tblMatchStatistic (
    intStatisticID          INT             IDENTITY(1,1)   CONSTRAINT PK_MatchStatistic PRIMARY KEY,
    intParticipantID        INT             NOT NULL,
    intGameStatisticTypeID  INT             NOT NULL,
    decValue                DECIMAL(18,2)   NOT NULL,

    CONSTRAINT FK_MatchStatistic_Participant        FOREIGN KEY (intParticipantID)          REFERENCES tblMatchParticipant(intParticipantID),
    CONSTRAINT FK_MatchStatistic_GameStatisticType  FOREIGN KEY (intGameStatisticTypeID)    REFERENCES tblGameStatisticType(intGameStatisticTypeID),
    CONSTRAINT UQ_MatchStatistic                    UNIQUE (intParticipantID,intGameStatisticTypeID),
    CONSTRAINT CHK_MatchStatistic_Value             CHECK (decValue >= 0)
);

CREATE INDEX IX_MatchStatistic_ParticipantID        ON tblMatchStatistic(intParticipantID);
CREATE INDEX IX_MatchStatistic_GameStatisticTypeID  ON tblMatchStatistic(intGameStatisticTypeID);


GO


CREATE TABLE tblRankHistory (
    intRankHistoryID    INT         IDENTITY(1,1)   CONSTRAINT PK_RankHistory               PRIMARY KEY,
    intProfileID        INT         NOT NULL,
    intMatchID          INT         NULL,
    intPreviousRank     INT         NOT NULL,
    intNewRank          INT         NOT NULL,
    dtChangeDate        DATETIME2   NOT NULL        CONSTRAINT DF_RankHistory_ChangeDate    DEFAULT GETDATE(),

    CONSTRAINT FK_RankHistory_Profile       FOREIGN KEY (intProfileID)  REFERENCES tblPlayerGameProfile(intProfileID),
    CONSTRAINT FK_RankHistory_Match         FOREIGN KEY (intMatchID)    REFERENCES tblMatch(intMatchID),
    CONSTRAINT CHK_RankHistory_PreviousRank CHECK (intPreviousRank >= 0),
    CONSTRAINT CHK_RankHistory_NewRank      CHECK (intNewRank >= 0)
);

CREATE INDEX IX_RankHistory_ProfileID   ON tblRankHistory(intProfileID);
CREATE INDEX IX_RankHistory_MatchID     ON tblRankHistory(intMatchID);
CREATE INDEX IX_RankHistory_ChangeDate  ON tblRankHistory(dtChangeDate);


GO

