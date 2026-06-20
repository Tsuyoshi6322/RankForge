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

    CONSTRAINT FK_Season_Game
        FOREIGN KEY (intGameID)
        REFERENCES tblGame(intGameID),

    CONSTRAINT CHK_Season_DateRange
        CHECK (dEndDate > dStartDate),

    CONSTRAINT UQ_Season_Game_Name
        UNIQUE (intGameID, nvcName)
);

CREATE INDEX IX_Season_GameID
    ON tblSeason(intGameID);

CREATE INDEX IX_Season_IsActive
    ON tblSeason(bitIsActive);

GO