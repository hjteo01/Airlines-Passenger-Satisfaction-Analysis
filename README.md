# Airlines-Passenger-Satisfaction-Analysis

## Project Overview

This project analyses 129,880 passenger journey records from Maven Airlines to understand what factors drive or hinder customer satisfaction.

The analysis focuses on three main areas:

- What is the customer profile for a first-time/repeating airline passenger?
- What service factors have the strongest correlation with passenger satisfaction?
- Does flight distance affect customer preferences?

The goal is to uncover actionable insights that help Maven Airlines prioritise investments to lift its overall satisfaction rate above 50%.

## Dataset Structure

The dataset contains satisfaction survey responses from Maven Airlines passengers.

- **airline_passenger_satisfaction.csv**
    - Contains passenger-level information including demographics, flight details, travel type, class, service ratings across 14 touch points, delay information, and overall satisfaction outcome.

## Executive Summary

To lift Maven Airlines' satisfaction rate above 50%, three focused actions are required:

**1. Fix the three digital experience gaps**
Online Boarding, In-Flight Entertainment and Wifi are the strongest predictors of satisfaction out of 14 service factors. Passengers who rate them poorly are nearly 6× less likely to be satisfied, making these the highest-impact investments available.

**2. Protect what's already working**
Returning business travellers in Business class are satisfied at 70%. This segment must be maintained while fixing the broader base — do not sacrifice the loyal core while chasing growth.

**3. Convert first-time Economy flyers**
First-time flyers make up 18% of the base — 99% travel for business but 61% choose Economy, suggesting cost sensitivity or lack of brand trust. A strong first Economy experience is the most direct path to building loyalty over time.

## Tools Used

- ***Python**: performed data cleaning, data transformation and EDA*
- ***SQL**: answered business questions through queries*
- ***Google Slides**: built an executive-ready presentation slides*

## Analysis Approach

The project was completed in several stages:

### 1. Data Cleaning & Transformation

Before analysis, the dataset was cleaned and reviewed by:

- Replacing 0 values in satisfaction rating columns with NULL to exclude "not applicable" responses from aggregations
- Converting `departure_delay` and `arrival_delay` from minutes to hours
- Creating bucketed columns for delay ranges and age groups
- Verifying row counts and checking for missing values across key fields

### 2. Exploratory Data Analysis (EDA)

Initial exploration was performed to understand the dataset:

- Overall satisfaction rate across the full passenger base
- Distribution of passengers by customer type, travel type, and class
- Average age and flight distance by segment
- Rating distributions across all 14 service touch points

### 3. Business Analysis Questions

The analysis focused on answering the following questions:

- **Which passenger segments are the most and least satisfied?**
    - Compared satisfaction rates across customer type, travel type, and class
- **Which service factors correlate most strongly with satisfaction?**
    - Used `CORR()` in BigQuery across all 14 service rating columns against the satisfaction outcome
    - Unpivoted results to rank factors in descending order of correlation
- **What is the profile of a returning passenger?**
    - Queried demographic and behavioural attributes segmented by customer type
- **How does flight distance affect satisfaction?**
    - Bucketed flight distance into bands and calculated satisfaction rate per band
- **What is the impact of low vs high ratings on individual service factors?**
    - Split passengers into low (1–2) and high (4–5) rating groups per factor and compared satisfaction rates

## Presentation Slide

The executive presentation was built using **Google Slides**, structured using the **Pyramid Principle**.

📊 View the full presentation: [`Data_Storytelling_Maven_Airlines.pdf`](./Data_Storytelling_Maven_Airlines.pdf)

## Assumptions

- Satisfaction rating columns with a value of 0 represent "not applicable" responses (passenger did not experience that service), not a genuine rating of 0 out of 5. These were replaced with `NULL` prior to all aggregations.
