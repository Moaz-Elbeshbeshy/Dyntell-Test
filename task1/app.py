from collections import Counter
import re

with open('sample.txt', 'r', encoding='utf-8') as file:
    text = file.read()

# Find all words in the text and store them in a list
words = re.findall(r'\b\w+\b', text.lower())

number_of_words = len(words)

# Create a set to remove duplicates and count unique words
number_unique_words = len(set(words))

# Count the frequency of each word and get the top 10 most common words and will return a list of tuples ('great', 1)
top_words = Counter(words).most_common(10)

print(f'Total words: {number_of_words}')
print(f'Unique words: {number_unique_words}')
print('Top 10 words:')
for word, count in top_words:
    print(f'{word}: {count}')