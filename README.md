# RankForge

## Initialise the database
```sql
/*
=====================================================
TABLES
=====================================================
*/

tblPlayer
tblGame
tblSeason
tblPlayerGameProfile
tblMatch
tblMatchParticipant
tblStatisticType
tblGameStatisticType
tblMatchStatistic
tblRankHistory

/*
=====================================================
DATA
=====================================================
*/

INSERT Player
INSERT Game
INSERT Season
INSERT PlayerGameProfile
INSERT Match
INSERT MatchParticipant
INSERT StatisticType
INSERT GameStatisticType
INSERT MatchStatistic
INSERT RankHistory

/*
=====================================================
TYPES
=====================================================
*/

typMatchParticipant

/*
=====================================================
PROCEDURES
=====================================================
*/

uspAddPlayerToGame
uspRegisterMatch
uspUpdatePlayerRanking
uspGenerateSeasonLeaderboard
uspGetPlayerStatistics

/*
=====================================================
TRIGGERS
=====================================================
*/

trgPlayerGameProfile_RankHistory
trgMatchStatistic_Validate

/*
=====================================================
VIEWS
=====================================================
*/

vwLeaderboard
vwPlayerStatistics
vwRankingHistory
vwMatchDetails
vwGamePerformance
```