from flask import Flask, request, jsonify
import pandas as pd
import joblib

app = Flask(__name__)

@app.route('/api', methods = ['GET'])
def get_winner():
  p1 = str(request.args['player1'])
  p2 = str(request.args['player2'])

  matches = pd.read_csv('jun-23-2023-matches.csv')
  model = joblib.load('jun-24-2023-rf.joblib')

  df = get_modeling_df(p1, p2, matches)
  results = {}

  if model.predict_proba(df)[0][0] > 0.5:
    results["winner"] = p1
    results["probability"] = model.predict_proba(df)[0][0]
  else:
    results["winner"] = p2
    results["probability"] = model.predict_proba(df)[0][1]

  return results

def find_latest_match_stats(pname, dataframe):
  df_1 = dataframe[dataframe["player_1"] == pname]
  df_2 = dataframe[dataframe["player_2"] == pname]
  df = pd.concat([df_1, df_2])
  
  if pname == df.iloc[-1]["player_1"]:
    stats1 = df.iloc[-1][["player_1_age", "player_1_rank", "player_1_highest_rank", "player_1_current_surface_win%", "player_1_recent_play", "player_1_win%"]]
    return {"age" : stats1["player_1_age"], "rank" : stats1["player_1_rank"], "highest_rank" : stats1["player_1_highest_rank"], "current_surface_win%" : stats1["player_1_current_surface_win%"], "recent_play" : stats1["player_1_recent_play"], "win%" : stats1["player_1_win%"]}
  else:
    stats2 = df.iloc[-1][["player_2_age", "player_2_rank", "player_2_highest_rank", "player_2_current_surface_win%", "player_2_recent_play", "player_2_win%"]]
    return {"age" : stats2["player_2_age"], "rank" : stats2["player_2_rank"], "highest_rank" : stats2["player_2_highest_rank"], "current_surface_win%" : stats2["player_2_current_surface_win%"], "recent_play" : stats2["player_2_recent_play"], "win%" : stats2["player_2_win%"]}

def get_modeling_df(player1, player2, dataframe):
  stats1 = find_latest_match_stats(player1, dataframe)
  stats2 = find_latest_match_stats(player2, dataframe)

  tmp = pd.DataFrame.from_dict([stats1, stats2])

  diff_list = ["age", "rank", "highest_rank", "current_surface_win%", "recent_play", "win%"]
  diffs = {}

  for item in diff_list:

    diffs[item + "_diff"] = tmp.iloc[0][item] - tmp.iloc[1][item]

  modeling_data = pd.DataFrame.from_dict([diffs])

  return modeling_data

if __name__ == "__main__":
  app.run()