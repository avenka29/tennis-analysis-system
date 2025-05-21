# from db import conn
import pandas as pd
from db import get_connection
import numpy as np

conn = get_connection()

query = 'Select * FROM "Matches"'
df = pd.read_sql(query, conn)

df.loc[df["Winner"] == "Red", "RedWins"] += 1
df.loc[df["Winner"] == "Red", "BlueLosses"] += 1

df.loc[df["Winner"] == "Blue", "BlueWins"] += 1
df.loc[df["Winner"] == "Blue", "RedLosses"] += 1


red_data = df[["RedFighter", "Date", "WeightClass","Gender", "RedCurrentWinStreak" ,"RedCurrentLoseStreak", "RedDraws", "RedTotalRoundsFought", 
                        "RedTotalTitleBouts", "RedWinsByDecisionMajority", "RedWinsByDecisionSplit", "RedWinsByDecisionUnanimous", "RedWinsByKO", "RedWinsBySubmission", "RedWins", "RedStance", "RedHeightCms", "RedReachCms", "RedAge"]].copy()

red_data.columns = [col.replace("Red", "") if "Red" in col else col for col in red_data.columns]
red_data["Corner"] = "Red"

blue_data = df[
    ["BlueFighter", "Date", "WeightClass", "Gender", "BlueCurrentWinStreak",
    "BlueCurrentLoseStreak", "BlueDraws", "BlueTotalRoundsFought",
    "BlueTotalTitleBouts", "BlueWinsByDecisionMajority", "BlueWinsByDecisionSplit",
    "BlueWinsByDecisionUnanimous", "BlueWinsByKO", "BlueWinsBySubmission",
    "BlueWins", "BlueStance", "BlueHeightCms", "BlueReachCms", "BlueAge"]
].copy()

blue_data.columns = [col.replace("Blue", "") if "Blue" in col else col for col in blue_data.columns]


blue_data["Corner"] = "Blue"

red_data.rename(columns={"Fighter": "Name"}, inplace=True)
blue_data.rename(columns={"Fighter": "Name"}, inplace=True)

all_fights = pd.concat([red_data, blue_data])



# print(blue_data.head(5))
# print(red_data.head(5))

# Unique Array of fighters
fighter_df = pd.concat([ df["RedFighter"], df["BlueFighter"] ])
unique = fighter_df.unique()


unique_set = set(unique)


fighter_latest_stats = {}
most_recent_rows = []


for fighter in unique_set:
    fighter_matches = all_fights[all_fights["Name"] == fighter]
    most_recent = fighter_matches.sort_values(by="Date", ascending=False).iloc[0]
    most_recent_rows.append(most_recent)
    fighter_latest_stats[fighter] = most_recent.to_dict()

latest_stats_df = pd.DataFrame(most_recent_rows)

latest_stats_df.to_csv("lateststats.csv", index=False)


# fighter_series = pd.Series(unique)

# # Save to CSV
# fighter_series.to_csv("unique_fighters.csv", index=False, header=["Fighter"])







# conn.close()