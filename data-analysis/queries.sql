-- CONTAINS QUERIES FOR CREATING AND PROCESSING TABLE DATA --

-- Creating Enumerations for Winner and Type
CREATE TYPE GENDER AS ENUM('MALE', 'FEMALE');
CREATE TYPE WINNER as ENUM('Red', 'Blue');


-- Creating the main Matches table
CREATE TABLE Matches (RedFighter TEXT, BlueFighter TEXT, RedOdds REAL, BlueOdds REAL,
RedExpectedValue REAL, BlueExpectedValue REAL, Date DATE, Location TEXT, Country TEXT, Winner WINNER,
TitleBout BOOLEAN, WeightClass TEXT, Gender GENDER, NumberOfRounds SMALLINT,
BlueCurrentLoseStreak SMALLINT, BlueCurrentWinStreak SMALLINT,
BlueDraws SMALLINT, BlueAvgSigStrLanded REAL, BlueAvgSigStrPct REAL,
BlueAvgSubAtt REAL, BlueAvgTDLanded REAL, BlueAvgTDPct REAL,
BlueLongestWinStreak SMALLINT, BlueLosses SMALLINT, BlueTotalRoundsFought REAL,
BlueTotalTitleBouts SMALLINT, BlueWinsByDecisionMajority SMALLINT,
BlueWinsByDecisionSplit SMALLINT, BlueWinsByDecisionUnanimous SMALLINT,
BlueWinsByKO SMALLINT, BlueWinsBySubmission SMALLINT, BlueWinsByTKODoctorStoppage SMALLINT,
BlueWins SMALLINT, BlueStance TEXT, BlueHeightCms REAL, BlueReachCms REAL, BlueWeightLbs SMALLINT,
RedCurrentLoseStreak SMALLINT, RedCurrentWinStreak SMALLINT, RedDraws SMALLINT, RedAvgSigStrLanded REAL,
RedAvgSigStrPct REAL, RedAvgSubAtt REAL, RedAvgTDLanded REAL,RedAvgTDPct REAL,
RedLongestWinStreak SMALLINT, RedLosses SMALLINT, RedTotalRoundsFought SMALLINT,
RedTotalTitleBouts SMALLINT, RedWinsByDecisionMajority SMALLINT, RedWinsByDecisionSplit SMALLINT,
RedWinsByDecisionUnanimous SMALLINT, RedWinsByKO SMALLINT, RedWinsBySubmission SMALLINT,
RedWinsByTKODoctorStoppage SMALLINT, RedWins SMALLINT, RedStance TEXT, RedHeightCms REAL,
RedReachCms REAL, RedWeightLbs SMALLINT, RedAge SMALLINT, BlueAge SMALLINT, LoseStreakDif SMALLINT,
WinStreakDif SMALLINT, LongestWinStreakDif SMALLINT, WinDif SMALLINT, LossDif SMALLINT,
TotalRoundDif SMALLINT, TotalTitleBoutDif SMALLINT, KODif SMALLINT, SubDif SMALLINT,HeightDif REAL,
ReachDif REAL, AgeDif SMALLINT, SigStrDif REAL, AvgSubAttDif REAL,
AvgTDDif REAL,EmptyArena SMALLINT,
BMatchWCRank REAL, RMatchWCRank REAL,RWFlyweightRank REAL,RWFeatherweightRank REAL,
RWStrawweightRank REAL,RWBantamweightRank REAL,RHeavyweightRank REAL,RLightHeavyweightRank REAL,
RMiddleweightRank REAL,RWelterweightRank REAL,RLightweightRank REAL,RFeatherweightRank REAL,
RBantamweightRank REAL,RFlyweightRank REAL,RPFPRank REAL,BWFlyweightRank REAL,BWFeatherweightRank REAL,
BWStrawweightRank REAL,BWBantamweightRank REAL,BHeavyweightRank REAL,BLightHeavyweightRank REAL,
BMiddleweightRank REAL,BWelterweightRank REAL,BLightweightRank REAL,BFeatherweightRank REAL,
BBantamweightRank REAL,BFlyweightRank REAL,BPFPRank REAL,BetterRank TEXT,Finish TEXT,FinishDetails TEXT,
FinishRound REAL,FinishRoundTime TEXT,TotalFightTimeSecs REAL, RedDecOdds REAL,BlueDecOdds REAL,
RSubOdds REAL,BSubOdds REAL,RKOOdds REAL,BKOOdds REAL);


--Creating fighter database
Create TABLE Fighters(Name TEXT, id SERIAL Primary Key)


--Populate fighters table
SELECT fighter
FROM (
    SELECT RedFighter  AS fighter FROM Matches
    UNION
    SELECT BlueFighter AS fighter FROM Matches
) AS fighters
ORDER BY fighter;
Create table fighters(Name TEXT, id SERIAL Primary Key)

-- Create fighters_data table
CREATE TABLE Fighters_Data(Name INTEGER REFERENCES Fighters(id), recent_match INTEGER REFERENCES Matches(id), weight_class TEXT,
Gender GENDER, current_win_streak SMALLINT, current_lose_streak SMALLINT, Draws SMALLINT,
total_rounds_fought REAL, total_title_bouts SMALLINT, wins_by_decision_majority SMALLINT,
wins_by_decision_split SMALLINT, wins_by_decision_unanimous SMALLINT, wins_by_ko SMALLINT,
wins_by_sub SMALLINT, Loses SMALLINT, Wins SMALLINT, Stance TEXT, Height REAL, Reach REAL, Age SMALLINT);



--Populating fighters_data database
DO
$body$
DECLARE
  fighter RECORD;
  recent_match RECORD;
  corner VARCHAR(4);
BEGIN
  FOR fighter IN SELECT * FROM fighters LOOP
    SELECT * INTO recent_match
    FROM matches
    WHERE matches.RedFighter = fighter.name OR matches.BlueFighter = fighter.name
    ORDER BY matches.date DESC
    LIMIT 1;

    IF recent_match.RedFighter = fighter.name THEN
        corner := 'Red';
    ELSE
        corner := 'Blue';
    END IF;

    IF corner = 'Red' THEN
        INSERT INTO fighters_data(fighter_id, recent_match, weight_class,
        Gender, current_win_streak, current_lose_streak, Draws,
        total_rounds_fought, total_title_bouts, wins_by_decision_majority,
        wins_by_decision_split, wins_by_decision_unanimous, wins_by_ko,
        wins_by_sub, Loses, Wins, Stance, Height, Reach, Age)

        VALUES(fighter.id, recent_match.id, recent_match.WeightClass, recent_match.Gender, recent_match.RedCurrentWinStreak,
        recent_match.RedCurrentLoseStreak, recent_match.RedDraws, recent_match.RedTotalRoundsFought,
        recent_match.RedTotalTitleBouts, recent_match.RedWinsByDecisionMajority, recent_match.RedWinsByDecisionSplit,
        recent_match.RedWinsByDecisionUnanimous, recent_match.RedWinsByKO, recent_match.RedWinsBySubmission, 
        recent_match.RedLosses,
        recent_match.RedWins, recent_match.RedStance, recent_match.RedHeightCms,
        recent_match.RedReachCms, recent_match.RedAge);
    ELSE
        INSERT INTO fighters_data(fighter_id, recent_match, weight_class,
        Gender, current_win_streak, current_lose_streak, Draws,
        total_rounds_fought, total_title_bouts, wins_by_decision_majority,
        wins_by_decision_split, wins_by_decision_unanimous, wins_by_ko,
        wins_by_sub, Loses, Wins, Stance, Height, Reach, Age)

        VALUES(fighter.id, recent_match.id, recent_match.WeightClass, recent_match.Gender, recent_match.BlueCurrentWinStreak,
            recent_match.BlueCurrentLoseStreak, recent_match.BlueDraws, recent_match.BlueTotalRoundsFought,
            recent_match.BlueTotalTitleBouts, recent_match.BlueWinsByDecisionMajority, recent_match.BlueWinsByDecisionSplit,
            recent_match.BlueWinsByDecisionUnanimous, recent_match.BlueWinsByKO, recent_match.BlueWinsBySubmission,
            recent_match.BlueLosses,
            recent_match.BlueWins, recent_match.BlueStance, recent_match.BlueHeightCms,
            recent_match.BlueReachCms, recent_match.BlueAge);
    END IF;
  END LOOP;
END;
$body$
LANGUAGE plpgsql;

INSERT INTO fighters
SELECT fighter
FROM (
    SELECT RedFighter  AS fighter FROM Matches
    UNION
    SELECT BlueFighter AS fighter FROM Matches
) AS fighters


-- [TODO] START HERE FOR NEW STUFF
-- new dataset link:
--https://www.kaggle.com/datasets/m0hamedai1/the-ultimate-ufc-archive-1993-present?resource=download&select=fighters.csv
-- Creating fighters-new table
CREATE TABLE fighters_new(fighter_id TEXT, name TEXT, birthdate DATE, nickname TEXT, association TEXT,
weight_class TEXT, wins REAL, losses REAL, draws REAL,
wins_by_ko_tko REAL, wins_by_submission REAL, wins_by_decision REAL, wins_by_other REAL,
losses_by_ko_tko REAL, losses_by_submission REAL, losses_by_decision REAL, losses_by_other REAL,
country TEXT, city TEXT, weight REAL, sex VARCHAR(1), height_ft REAL, height_cm REAL);

-- Add serial id column to fighters
ALTER TABLE fighters_new
ADD COLUMN id SERIAL PRIMARY KEY;


--Adding reach to new table
ALTER TABLE fighters_new
ADD COLUMN reach_cms REAL;

UPDATE fighters_new
SET reach_cms = fighters_data.reach
FROM
fighters_data JOIN fighters
ON fighters.id = fighters_data.fighter_id
WHERE fighters.name = fighters_new.name;


--Adding age to new table
ALTER TABLE fighters_new
ADD COLUMN age SMALLINT;

UPDATE fighters_new
SET age = fighters_data.age
FROM
fighters_data JOIN fighters
ON fighters.id = fighters_data.fighter_id
WHERE fighters.name = fighters_new.name;


--Drop original height column
ALTER TABLE fighters_new
DROP COLUMN height_cm

