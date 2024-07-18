import streamlit as st
import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from tensorflow.keras.models import load_model
import joblib
import matplotlib.pyplot as plt

# Load your data (merged2 DataFrame), model, and encoders here
# merged2_path = "/Users/mac/football Project python/version1/merged2.csv"
# merged2_path = "Machine-learning-prediction-for-Soccer-Team-performance/merged2.csv"
merged2_path = "merged2.csv"
merged2 = pd.read_csv(merged2_path)

# Load your trained keras LSTM model
# model_path = "/Users/mac/Downloads/match_outcome_model14.h5"
model_path = "match_outcome_model14.h5"
modelmatch = load_model(model_path)

# Load your ball possession model
# possession_model_path = "/Users/mac/Downloads/possession_model (2).h5"
possession_model_path = "possession_model (2).h5"
modelpossession = load_model(possession_model_path)

# Load encoders (if needed)
# squad_encoder = joblib.load("/Users/mac/football Project python/version1/Squad_encoder1.pkl")
# player_encoder = joblib.load("/Users/mac/football Project python/version1/Player_encoder1.pkl")

squad_encoder = joblib.load("Squad_encoder1.pkl")
player_encoder = joblib.load("Player_encoder1.pkl")

# Load scaler from file
# scaler_path = "/Users/mac/football Project python/version1/scaler.pkl"
scaler_path = "scaler.pkl"
scaler = joblib.load(scaler_path)

# Mapping for outcome classes
outcome_mapping = {0: "Draw", 1: "Home Win", 2: "Away Win"}

# Define your rolling features
rollingfeatures = [
    'PrgP_Passes_per_90_rolling_avg', 'PrgC_Carries_per_90_rolling_avg', 'PrgDist_Total_per_90_rolling_avg',
    'Cmp_Long_per_90_rolling_avg', 'Final_Third_per_90_rolling_avg', 'TB_Pass_Types_per_90_rolling_avg',
    'TI_Pass_Types_per_90_rolling_avg', 'Att_Take_Ons_per_90_rolling_avg', 'Succ_Take_Ons_per_90_rolling_avg',
    'KP_per_90_rolling_avg', 'PPA_per_90_rolling_avg', 'CrsPA_per_90_rolling_avg', 'Att 3rd_Tackles_per_90_rolling_avg',
    'SoT_Performance_per_90_rolling_avg', 'PKwon_Performance_per_90_rolling_avg', 'Cmp_Passes_per_90_rolling_avg',
    'Cmp_Short_per_90_rolling_avg', 'Cmp_Medium_per_90_rolling_avg', 'Carries_Carries_per_90_rolling_avg',
    'Touches_Performance_per_90_rolling_avg', 'Cmp_Total_per_90_rolling_avg', 'Tkl+Int_per_90_rolling_avg',
    'TklW_Tackles_per_90_rolling_avg', 'Def 3rd_Tackles_per_90_rolling_avg', 'Mid 3rd_Tackles_per_90_rolling_avg',
    'PKcon_Performance_per_90_rolling_avg', 'Recov_Performance_per_90_rolling_avg', 'Won_Aerial_Duels_per_90_rolling_avg',
    'Lost_Aerial_Duels_per_90_rolling_avg', 'Clr_per_90_rolling_avg', 'Err_per_90_rolling_avg', 'Blocks_Blocks_per_90_rolling_avg',
    'xG_Expected_per_90_rolling_avg', 'npxG_Expected_per_90_rolling_avg', 'xAG_Expected_per_90_rolling_avg',
    'SCA_SCA_per_90_rolling_avg', 'GCA_SCA_per_90_rolling_avg', 'Ast_per_90_rolling_avg', 'xA_per_90_rolling_avg',
    'xAG_per_90_rolling_avg', 'Cmp_percent_Long_rolling_avg', 'Gls_Performance_per_90_rolling_avg',
    'Crs_Performance_per_90_rolling_avg', 'attacking_score_rolling_avg', 'possession_score_rolling_avg',
    'defensive_score_rolling_avg'
]

rolling_features = rollingfeatures + ['Player_ID']  # Include Player_ID as a rolling feature

# Function to extract unique player names grouped by squad
def get_unique_players_by_squad(df):
    squads = df['Squad'].unique()
    squad_player_map = {squad: df[df['Squad'] == squad]['Player'].unique() for squad in squads}
    return squad_player_map


# Function to extract player features for a given team and match
def extract_latest_player_features(df, squad_name, selected_player_names, features):
    # Encode the squad name
    encoded_squad_name = squad_encoder.transform([squad_name])[0]
    
    # Map selected player names to their encoded forms
    encoded_player_ids = player_encoder.transform(selected_player_names)
    
    # Filter the dataframe for the given squad and selected players
    selected_players_data = df[(df['Squad_ID'] == encoded_squad_name) & (df['Player_ID'].isin(encoded_player_ids))]
    
    # Sort by Date in descending order and get the latest record for each player
    latest_records = selected_players_data.sort_values(by='Date', ascending=False).groupby('Player_ID').head(1)
    
    # Extract the specified features
    feature_array = latest_records[features].values.flatten()
    
    # Ensure the feature array has the expected length
    expected_length = len(encoded_player_ids) * len(features)
    if len(feature_array) < expected_length:
        feature_array = np.pad(feature_array, (0, expected_length - len(feature_array)), 'constant')
    
    return feature_array

# Function to prepare features for prediction
def prepare_match_features(df, team1_name, team2_name, team1_selected_player_names, team2_selected_player_names, features, scaler):
    team1_features = extract_latest_player_features(df, team1_name, team1_selected_player_names, features)
    team2_features = extract_latest_player_features(df, team2_name, team2_selected_player_names, features)
    
    # Ensure team1_features always represents the home team and team2_features the away team
    if team1_name == "Team1":
        match_features = np.concatenate([team1_features, team2_features])
    else:
        match_features = np.concatenate([team2_features, team1_features])
        
    match_features_scaled = scaler.transform(match_features.reshape(1, -1))
    match_features_scaled = match_features_scaled.reshape(1, 1, -1)  # Reshape for LSTM input
    return match_features_scaled

# Function to calculate mean scores for possession, defensive, and attacking styles of play
def calculate_mean_scores(df, squad_name, selected_player_names, features):
    # Filter the dataframe for the given squad and selected players
    squad_data = df[df['Squad'] == squad_name]
    selected_players_data = squad_data[squad_data['Player'].isin(selected_player_names)]
    
    # Sort by Date in descending order to get the latest record for each player
    latest_records = selected_players_data.sort_values(by='Date', ascending=False).groupby('Player_ID').head(1)
    
    # Calculate mean scores for each feature
    mean_scores = latest_records[features].mean(axis=0)
    
    return mean_scores

# Function to calculate percentile ranks
def calculate_percentile_ranks(all_teams_mean_scores, team_name, team_mean_scores):
    percentiles = {}
    
    for feature in team_mean_scores.index:
        team_score = team_mean_scores[feature]
        other_teams_scores = [scores[feature] for scores in all_teams_mean_scores.values() if scores.name != team_name]
        
        # Sort all team scores for the current feature
        sorted_scores = sorted(other_teams_scores + [team_score])
        
        # Calculate percentile rank for the team's score
        team_percentile_rank = (np.searchsorted(sorted_scores, team_score, side='right') / len(sorted_scores)) * 100
        
        percentiles[feature] = team_percentile_rank
    
    return percentiles

# Function to plot radar chart
def plot_radar_chart(team1_name, team1_percentiles, team2_name, team2_percentiles):
    # Modify team names to capitalize the first word
    team1_name = team1_name.capitalize()
    team2_name = team2_name.capitalize()
    labels = list(team1_percentiles.keys())
    labels = [feature.split('_')[0].capitalize() for feature in team1_percentiles.keys()]
    stats_team1 = list(team1_percentiles.values())
    stats_team2 = list(team2_percentiles.values())
    
    angles = np.linspace(0, 2 * np.pi, len(labels), endpoint=False).tolist()
    
    stats_team1 += stats_team1[:1]  # Closing the loop
    stats_team2 += stats_team2[:1]  # Closing the loop
    angles += angles[:1]  # Closing the loop
    
    fig, ax = plt.subplots(figsize=(8, 8), subplot_kw=dict(polar=True))
    fig.patch.set_facecolor('darkslategray')  # Background color for the entire plot
    ax.set_facecolor('darkslategray')  # Background color for the polar axis
    
    # Plot team1
    ax.fill(angles, stats_team1, color='blue', alpha=0.6, label=team1_name, linewidth=3)
    ax.plot(angles, stats_team1, color='blue', linewidth=3)
    
    # Plot team2
    ax.fill(angles, stats_team2, color='red', alpha=0.6, label=team2_name, linewidth=3)
    ax.plot(angles, stats_team2, color='red', linewidth=3)
    
    # Beautify the plot
    ax.set_xticks(angles[:-1])
    ax.set_xticklabels(labels, fontsize=13, color='white')
    
    # Calculate maximum value for setting radial ticks dynamically
    max_value = max(max(stats_team1), max(stats_team2))
    
    if max_value <= 50:
        step = 10
    elif max_value <= 100:
        step = 20
    else:
        step = 20 if max_value % 20 == 0 else 10
    
    # Setting radial ticks and labels
    radial_ticks = np.arange(0, max_value + step, step)
    ax.set_yticks(radial_ticks)
    ax.set_yticklabels([int(tick) for tick in radial_ticks], fontsize=12, color='white')  # Convert ticks to integers
    
    # Add gridlines
    ax.yaxis.grid(True, color='#EEEEEE', linestyle='-', linewidth=0.75)
    ax.xaxis.grid(True, color='#EEEEEE', linestyle='-', linewidth=0.75)
    
    # Customize the circle
    ax.spines['polar'].set_visible(True)
    ax.spines['polar'].set_color('gray')
    
    # Add legend
    ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.1), fontsize=12, frameon=False, ncol=2, labelcolor='white')
    
    # Set title
    ax.set_title(f"Style of Play Radar plot {team1_name} and {team2_name}", fontsize=16, color='white', pad=20)
    
    st.pyplot(fig)

# Streamlit app code
def main():
    
    st.set_page_config(layout="wide", 
                       page_title="Football Team Performance App",
                       page_icon="https://cdn-icons-png.flaticon.com/128/1099/1099672.png",
                        )  
    
    # Hide Streamlit menu and footer
    hide_default_format = """
           <style>
           #MainMenu {visibility: hidden;}
           footer {visibility: hidden;}
           header {visibility: hidden;}
           </style>
           """
    st.markdown(hide_default_format, unsafe_allow_html=True)
    
    # Embed CSS for background image and styling
    st.markdown(
        """
        <style>
        .stApp {
            #background-image: url("https://theanalyst.com/wp-content/uploads/2023/07/premier-league-star-players.jpg");
            #background-image: url("https://static.vecteezy.com/system/resources/previews/040/478/797/non_2x/soccer-template-design-football-banner-sport-layout-design-red-theme-abstract-background-vector.jpg");
            #background-image: url("https://static.vecteezy.com/system/resources/previews/036/133/901/non_2x/football-soccer-background-design-soccer-ball-illustration-geometric-lines-and-stripes-style-vector.jpg");
            #background-image: url("https://static.vecteezy.com/system/resources/previews/014/720/363/non_2x/soccer-ball-of-white-and-red-color-bouncing-on-a-soccer-field-on-a-background-with-the-flag-of-qatar-image-vector.jpg");
            #background-image: url("https://static.vecteezy.com/system/resources/previews/008/676/796/large_2x/abstract-world-football-2022-tournament-background-illustration-football-pattern-for-banner-card-website-burgundy-color-national-flag-vector.jpg");
            #background-image: url("https://static.vecteezy.com/system/resources/thumbnails/024/093/567/small_2x/football-theme-colorful-background-vector.jpg");
            background-image: url("https://media.istockphoto.com/id/504572944/photo/ball.jpg?s=612x612&w=0&k=20&c=lLUDoXf-DcRYFZcKHzRMs9jszipOiBRAHx0nCu1zG70=");
            background-size: cover;
            # background-position: center;
            padding-top: 0 !important;
            margin-top: 0 !important;
            display: flex;
            flex-direction: column;
            align-items: center;  /* Center align content vertically */
        }
        .streamlit-container {
            padding-top: 0 !important;
            margin-top: 0 !important;
        }
        
        # .stApp h1 {
        #     color: white;
        #     text-shadow: 2px 2px 4px #000000;
        # }
        # .stApp .stButton>button {
        #     background-color: #4CAF50; /* Green */
        #     border: none;
        #     color: white;
        #     # padding: 15px 32px;
        #     text-align: center;
        #     text-decoration: none;
        #     display: inline-block;
        #     font-size: 10px;
        #     # margin: 2px 0px;
        #     transition-duration: 0.4s;
        #     cursor: pointer;
        # }
        .stApp .stButton>button:hover {
            background-color: white;
            color: black;
            border: 2px solid #4CAF50;
        }
        .centered-title {
            text-align: center;
            padding: 1rem;
        }
        .css-18e3th9 {
            padding-top: 0rem;
            padding-bottom: 10rem;
            padding-left: 5rem;
            padding-right: 5rem;
        }
         .css-1d391kg {
            padding-top: 3.5rem;
            padding-right: 1rem;
            padding-bottom: 3.5rem;
            padding-left: 1rem;
        }
        .block-container {
            padding-top: 1rem;
            padding-bottom: 0rem;
            padding-left: 5rem;
            padding-right: 5rem;
        }
        .centered-header {
            text-align: center;
            font-size: 1.5rem; /* Adjust the font size as needed */
        }
        footer {visibility: hidden;}
        .css-18e3th9 {padding-top: 0rem;}
        .css-1d391kg {padding-top: 0rem;}
        </style>
        """, unsafe_allow_html=True
    )
    # Your Streamlit app content here
    st.markdown("<h1 class='centered-title'>Football Match Team Performance Predictor</h1>", unsafe_allow_html=True)
    # st.title("Football Match Team Performance Predictor")

    
    # Split the layout into two columns
    col1, col2 = st.columns(2)

    with col1:
        # st.header("Simulate your match line up here")
        st.markdown("<h2 class='centered-header'>Simulate your match line up here</h2>", unsafe_allow_html=True)

        # Get unique players grouped by squad
        squad_player_map = get_unique_players_by_squad(merged2)
        
        # Select two teams for prediction
        team1_name = st.selectbox("Select Home Team", merged2['Squad'].unique(), index=0)  # Index 0 represents the default selection
        team2_name = st.selectbox("Select Away Team", merged2['Squad'].unique(), index=1)  # Index 1 represents the default selection

        # Select players for home team
        st.subheader(f"Select 15 players for {team1_name}:")
        selected_team1_players = st.multiselect("Select Players", squad_player_map[team1_name], default=squad_player_map[team1_name][:15])

        # Select players for away team
        st.subheader(f"Select 15 players for {team2_name}:")
        selected_team2_players = st.multiselect("Select Players", squad_player_map[team2_name], default=squad_player_map[team2_name][:15])


        # Ensure exactly 15 players are selected for each team
        if len(selected_team1_players) != 15 or len(selected_team2_players) != 15:
            st.write("Please select exactly 15 players for each team.")
            return
        
        # Initialize session state to keep track of button clicks
        if 'state' not in st.session_state:
            st.session_state.state = {
                'show_style_of_play': False,
                'show_match_outcome': False,
                'show_ball_possession': False
            }
        
        # Button for showing style of play
        if st.button("Show Style of Play"):
            st.session_state.state['show_style_of_play'] = True

        # Button for showing match outcome
        if st.button("Predict Match Outcome"):
            st.session_state.state['show_match_outcome'] = True

        # Button for showing ball possession
        if st.button("Predict Ball Possession"):
            st.session_state.state['show_ball_possession'] = True

    with col2:
        # st.header("Performances are Display here ")
        st.markdown("<h2 class='centered-header'></h2>", unsafe_allow_html=True)
        # Divide col2 into two sub-columns (60-40 ratio)
        col2_1, col2_2 = col2.columns([3, 2])

        with col2_1:

            # Show style of play radar chart if button is clicked
            if st.session_state.state['show_style_of_play']:
                team1_mean_scores = calculate_mean_scores(merged2, team1_name, selected_team1_players, ['possession_score_rolling_avg', 'defensive_score_rolling_avg', 'attacking_score_rolling_avg'])
                team2_mean_scores = calculate_mean_scores(merged2, team2_name, selected_team2_players, ['possession_score_rolling_avg', 'defensive_score_rolling_avg', 'attacking_score_rolling_avg'])
                
                all_teams = merged2['Squad'].unique()
                all_teams_mean_scores = {team: calculate_mean_scores(merged2, team, squad_player_map[team][:15], ['possession_score_rolling_avg', 'defensive_score_rolling_avg', 'attacking_score_rolling_avg']) for team in all_teams if team != team1_name and team != team2_name}
                
                team1_percentiles = calculate_percentile_ranks(all_teams_mean_scores, team1_name, team1_mean_scores)
                team2_percentiles = calculate_percentile_ranks(all_teams_mean_scores, team2_name, team2_mean_scores)
                
                plot_radar_chart(team1_name, team1_percentiles, team2_name, team2_percentiles)
        
        # with col2_2:

        #     # Predict match outcome if button is clicked
        #     if st.session_state.state['show_match_outcome']:
        #         match_features_scaled = prepare_match_features(
        #             merged2, team1_name, team2_name, selected_team1_players, selected_team2_players, rolling_features, scaler
        #         )
        #         prediction = modelmatch.predict(match_features_scaled)
        #         predicted_class = np.argmax(prediction, axis=-1)
        #         predicted_outcome = outcome_mapping[predicted_class[0]]
        #         st.subheader("Predicted Match Outcome:")
        #         st.write(predicted_outcome)

        #     # Predict ball possession if button is clicked
        #     if st.session_state.state['show_ball_possession']:
        #         match_features_scaled = prepare_match_features(
        #             merged2, team1_name, team2_name, selected_team1_players, selected_team2_players, rolling_features, scaler
        #         )
        #         possession_prediction = modelpossession.predict(match_features_scaled)
        #         possession_probability = possession_prediction.flatten()[0]
        #         if possession_probability > 0.5:
        #             possession_result = f"{team1_name} will have the highest ball possession."
        #         else:
        #             possession_result = f"{team2_name} will have the highest ball possession."
        #         st.subheader("Predicted Ball Possession:")
        #         st.write(possession_result)

        with col2_2:
            # Predict match outcome if button is clicked
            if st.session_state.state['show_match_outcome']:
                match_features_scaled = prepare_match_features(
                    merged2, team1_name, team2_name, selected_team1_players, selected_team2_players, rolling_features, scaler
                )
                prediction = modelmatch.predict(match_features_scaled)
                predicted_class = np.argmax(prediction, axis=-1)
                predicted_outcome = outcome_mapping[predicted_class[0]]
                
                # Box styling for Predicted Match Outcome
                st.markdown("""
                <div style="padding: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #f0f0f0;">
                    <h4 style="margin-bottom: 10px; color: green;">Predicted Match Outcome:</h4>
                    <p style="color:green;">{}</p>
                </div>
                """.format(predicted_outcome), unsafe_allow_html=True)

            # Predict ball possession if button is clicked
            if st.session_state.state['show_ball_possession']:
                match_features_scaled = prepare_match_features(
                    merged2, team1_name, team2_name, selected_team1_players, selected_team2_players, rolling_features, scaler
                )
                possession_prediction = modelpossession.predict(match_features_scaled)
                possession_probability = possession_prediction.flatten()[0]
                if possession_probability > 0.5:
                    possession_result = f"{team1_name.capitalize()} will have the highest ball possession."
                else:
                    possession_result = f"{team2_name.capitalize()} will have the highest ball possession."
                
                # Box styling for Predicted Ball Possession
                st.markdown("""
                <div style="padding: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #f0f0f0;">
                    <h4 style="margin-bottom: 10px; color: green;">Predicted Ball Possession:</h4>
                    <p style="color:green;">{}</p>
                </div>
                """.format(possession_result), unsafe_allow_html=True)


                        
if __name__ == "__main__":
    main()

