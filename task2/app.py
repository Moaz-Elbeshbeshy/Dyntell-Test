import pandas as pd

# Read the JSON file into a DataFrame
df = pd.read_json('people.json')

# Keep only people aged 30 or younger
filtered_by_age = df[df['age'] <= 30]

grouped_by_city = filtered_by_age.sort_values(by=['city'])

grouped_by_city.to_csv('filtered_grouped.csv', index=False)

print('Filtered and grouped data saved to filtered_grouped.csv')