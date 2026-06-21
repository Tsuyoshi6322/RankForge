USE RankForge
GO

INSERT INTO tblPlayer (nvcNickname,nvcEmail,nvcCountry) VALUES
('ShadowWolf',  'shadowwolf@example.com',   'Poland'    ),
('NovaStrike',  'novastrike@example.com',   'Germany'   ),
('IronFalcon',  'ironfalcon@example.com',   'France'    ),
('PixelHunter', 'pixelhunter@example.com',  'Spain'     ),
('CyberKnight', 'cyberknight@example.com',  'Poland'    );


GO


INSERT INTO tblGame (nvcName,nvcGenre,dReleaseDate,nvcDeveloper) VALUES
('Counter-Strike 2',    'FPS',          '2023-09-27',   'Valve'                     ),
('League of Legends',   'MOBA',         '2009-10-27',   'Riot Games'                ),
('Valorant',            'Tactical FPS', '2020-06-02',   'Riot Games'                ),
('Rocket League',       'Sports',       '2015-07-07',   'Psyonix'                   ),
('Overwatch 2',         'Hero Shooter', '2022-10-04',   'Blizzard Entertainment'    );


GO


INSERT INTO tblSeason (intGameID,nvcName,dStartDate,dEndDate) VALUES
(1,'Season 1','2025-01-01','2025-03-31'),
(1,'Season 2','2025-04-01','2025-06-30'),
(2,'Season 1','2025-01-01','2025-03-31'),
(3,'Season 1','2025-01-01','2025-03-31'),
(4,'Season 1','2025-01-01','2025-03-31'),
(5,'Season 1','2025-01-01','2025-03-31');


GO


INSERT INTO tblPlayerGameProfile (intPlayerID,intGameID,intCurrentRank,intMatchesPlayed,intWins,intLosses) VALUES
(1,1,1250,12,	8,	4),
(2,1,1180,10,	6,	4),
(3,1,1320,15,	10,	5),
(4,1,1050,7,	3,	4),
(5,1,1110,9,	5,	4),
(1,2,1450,18,	11,	7),
(2,2,1380,16,	9,	7),
(3,2,1520,20,	13,	7),
(1,3,1200,8,	5,	3),
(4,3,1175,9,	5,	4);


GO


INSERT INTO tblMatch (intGameID,intSeasonID,dtMatchDate,nvcStatus) VALUES
(1,1,'2025-01-10 18:00:00','Completed'),
(1,1,'2025-01-15 20:00:00','Completed'),
(2,3,'2025-01-12 19:00:00','Completed'),
(3,4,'2025-01-20 21:00:00','Completed');


GO


INSERT INTO tblMatchParticipant (intMatchID,intProfileID,intPlacement,bitIsWinner) VALUES
(1,1,	1,1),
(1,2,	2,0),
(1,3,	3,0),
(2,3,	1,1),
(2,4,	2,0),
(2,5,	3,0),
(3,6,	1,1),
(3,7,	2,0),
(3,8,	3,0),
(4,9,	1,1),
(4,10,	2,0);


GO


INSERT INTO tblStatisticType (nvcName,nvcDescription) VALUES
('Kills'       ,'Number of enemy eliminations'          ),
('Deaths'      ,'Number of deaths'                      ),
('Assists'     ,'Number of assists'                     ),
('Damage'      ,'Total damage dealt'                    ),
('Gold Earned' ,'Total amount of gold earned'           ),
('Goals'       ,'Number of goals scored'                ),
('Saves'       ,'Number of successful saves'            );


GO


INSERT INTO tblGameStatisticType (intGameID,intStatisticTypeID) VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(2,1),
(2,2),
(2,3),
(2,5),
(3,1),
(3,2),
(3,3),
(4,6),
(4,7);


GO


INSERT INTO tblMatchStatistic (intParticipantID,intGameStatisticTypeID,decValue) VALUES
(1,1,25		),
(1,2,8		),
(1,3,6		),
(1,4,3200	),
(2,1,18		),
(2,2,12		),
(2,3,4		),
(2,4,2500	),
(3,1,12		),
(3,2,15		),
(3,3,2		),
(3,4,1800	),
(4,1,28		),
(4,2,7		),
(4,3,9		),
(4,4,3500	);


GO


INSERT INTO tblRankHistory (intProfileID,intMatchID,intPreviousRank,intNewRank) VALUES
(1,	1,1200,1250),
(2,	1,1200,1180),
(3,	1,1300,1320),
(3,	2,1280,1320),
(4,	2,1080,1050),
(5,	2,1140,1110),
(6,	3,1400,1450),
(7,	3,1400,1380),
(8,	3,1500,1520),
(9,	4,1150,1200),
(10,4,1200,1175);


GO