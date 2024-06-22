# Machine-learning-prediction-for-Impact-of-Player-Attributes-Soccer-Team-performance and style of play  --- My  Msc project

## Identifying Style of Play in Soccer and Predicting Team Performance( match-outcome and ball-possesion). 

This repository contains the code and documentation for my MSc project thesis, titled **"Developing Machine Learning Model to Predict the Impact of Player Attributes on Soccer Team Performance (Match Outcome and Ball Possession) and Style of Play"**. The project involves scraping data from Football Reference (fbref) website, cleaning and merging the data, and then developing machine learning models to make the identifications and predictions. The project is organized in several stages, each documented in the respective files.

## Repository Structure

- `myscraping.R`: Initial script for web-scraping data from Football Reference.
- `pmatchlogs.R`: Script for scraping player's raw attributes for each match.
- `secondscrape.R`: Additional script for web-scraping data from Football Reference.
- `Cleaning logs1.ipynb`: First stage of cleaning the scraped data.
- `Cleaning_Version1.ipynb`: Second stage of cleaning the scraped data.
- `Copy_of_finalcodes.ipynb`: Final notebook containing the rest of the minor cleaning, Exploratory Analysis, Style of play  and machine learning model development.
- `README.md`: This README file.

## Process Overview

### 1. Web Scraping

The data required for this project is scraped from the [Football Reference (fbref)](https://fbref.com/en/) website using R scripts. The scripts used for this purpose are:

- `myscraping.R`: This script forms the foundation of the web-scraping process, collecting initial data from the website.
- `secondscrape.R`: This script performs additional scraping to gather more comprehensive soccer team and player data.
- `pmatchlogs.R`: This script focuses on scraping raw attributes for each player per match.

### 2. Data Cleaning

Once the data is scraped, it needs to be cleaned and prepared for analysis. This involves handling missing values, correcting data types, and merging different datasets. The cleaning process is divided into two stages, documented in the following Jupyter notebooks:

- `Cleaning logs1.ipynb`: First stage of cleaning the scraped data, including initial handling of missing values and basic data type corrections.
- `Cleaning_Version1.ipynb`: Second stage of cleaning, involving more detailed preprocessing and merging of datasets.

### 3. EDA and Machine Learning Model Development

After cleaning the data, the next step is to conduct Exploratory Data Analysis (EDA) and develop machine learning models to predict match outcomes, ball possession, and style of play. This is done in the following Jupyter notebook:

- `Copy_of_finalcodes.ipynb`: This notebook contains the final steps of minor data cleaning, feature engineering, EDA, and development of machine learning models. The models are trained and evaluated to ensure their effectiveness in making predictions.

## Instructions

To reproduce the results of this project, follow these steps:

1. **Clone the repository:**

   ```sh
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name
