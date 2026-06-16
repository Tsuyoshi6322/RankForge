CREATE TABLE Player (
    PlayerID    INT             IDENTITY(1,1) PRIMARY KEY,
    Nickname    NVARCHAR(50)    NOT NULL,
    Email       NVARCHAR(255)   NOT NULL,
    Country     NVARCHAR(100)   NULL,

    RegistrationDate DATETIME2 NOT NULL
        CONSTRAINT DF_Player_RegistrationDate
        DEFAULT GETDATE(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Player_IsActive
        DEFAULT 1,

    CONSTRAINT UQ_Player_Nickname   UNIQUE (Nickname),
    CONSTRAINT UQ_Player_Email      UNIQUE (Email)
);

CREATE INDEX IX_Player_Nickname ON Player(Nickname);
CREATE INDEX IX_Player_Country  ON Player(Country);

GO


