INSERT INTO Player
(
    Nickname,
    Email,
    Country
)
VALUES
('ShadowWolf',  'shadowwolf@example.com',   'Poland'    ),
('NovaStrike',  'novastrike@example.com',   'Germany'   ),
('IronFalcon',  'ironfalcon@example.com',   'France'    ),
('PixelHunter', 'pixelhunter@example.com',  'Spain'     ),
('CyberKnight', 'cyberknight@example.com',  'Poland'    );


GO


INSERT INTO Game
(
    Name,
    Genre,
    ReleaseDate,
    Developer
)
VALUES
('Counter-Strike 2',    'FPS',          '2023-09-27',   'Valve'                     ),
('League of Legends',   'MOBA',         '2009-10-27',   'Riot Games'                ),
('Valorant',            'Tactical FPS', '2020-06-02',   'Riot Games'                ),
('Rocket League',       'Sports',       '2015-07-07',   'Psyonix'                   ),
('Overwatch 2',         'Hero Shooter', '2022-10-04',   'Blizzard Entertainment'    );