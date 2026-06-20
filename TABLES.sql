
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