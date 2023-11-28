import requests
import pandas as pd

# Set Up
URL = "https://api.crossref.org/works?rows=1000"
response = requests.get(URL)
data = response.json()

# Extract all possible subjects that Crossref tracks
subjects_set = set()
for item in data['message']['items']:
    if 'subject' in item:
        subjects_set.update(item['subject'])

# Convert the set to a list
subjects_list = list(subjects_set)
subjects = subjects_list

# Adjust this number to adjust how many paper's to pull from each subject with each year.
# Articles Pulled = rows * amount of years * amount of subjects
# 1000 is the max rows pulled in each Crossref API call. 

rows = 1000

# Define the years you want to pull data for
years_to_pull = [2017, 2018, 2019, 2020, 2021, 2022, 2023]  

def get_articles_by_subject(subject, year, rows=rows):
    base_url = 'https://api.crossref.org/works'
    params = {
        'filter': f'from-pub-date:{year}-01-01,until-pub-date:{year}-12-31',
        'sort': 'relevance',
        'rows': rows,
        'query.bibliographic': subject
    }

    articles = []
    cursor = '*'

    while cursor:
        response = requests.get(base_url, params=params)
        if response.status_code == 200:
            data = response.json()
            items = data.get('message', {}).get('items', [])

            if not items:
                break

            articles.extend(items)
            cursor = data.get('message', {}).get('next-cursor', '')
        else:
            print(f"Request failed with status code: {response.status_code}")
            print(response.content)
            break

    return articles

# Initialize an empty list to store DataFrames for each subject
subject_dataframes = []

# Loop through each subject and fetch data
for subject in subjects_list:
    try:
        all_articles = []
        for year in years_to_pull:
            articles = get_articles_by_subject(subject, year, rows=rows)
            all_articles.extend(articles)

            # Initializing the DF for the pull

            data = {
                'DOI': [],
                'Title': [],
                'Container Title': [],
                'Publisher': [],
                'Publish Date': [],
                'Author First Name': [],
                'Author Last Name': [],
                'Author Order': [],
                'Referenced By': [],
                'Year': []  
            }

            # Assigning the location of the metadata, and then pulling it into the DF initialized

            for article in all_articles:
                doi = article.get('DOI', '')
                title = article.get('title', [''])[0]
                container_title = article.get('container-title', [''])[0]
                publisher = article.get('publisher', '')
                publish_date = article.get('published-print', {}).get('date-parts', [[]])[0]
                authors = article.get('author', [])
                referenced_by = article.get('is-referenced-by-count', 0)

                for order, author in enumerate(authors, start=1):
                    first_name = author.get('given', '')
                    last_name = author.get('family', '')

                    data['DOI'].append(doi)
                    data['Title'].append(title)
                    data['Container Title'].append(container_title)
                    data['Publisher'].append(publisher)
                    data['Publish Date'].append(publish_date)
                    data['Author First Name'].append(first_name)
                    data['Author Last Name'].append(last_name)
                    data['Author Order'].append(order)
                    data['Referenced By'].append(referenced_by)
                    data['Year'].append(year)  # Append the current year

            subject_df = pd.DataFrame(data)
            subject_df.columns = ['DOI', 'Title', 'Container Title', 'Publisher', 'Publish Date', 'Author First Name', 'Author Last Name', 'Author Order', 'Referenced By','Year']
            subject_df['Subject'] = subject  # Add a Subject column with the current subject
            subject_dataframes.append(subject_df)

    except Exception as e:
        print(f"Error processing subject '{subject}': {str(e)}")
        continue

# Concatenate all DataFrames into one big DataFrame and export it

massive_Crossreff_pull = pd.concat(subject_dataframes, ignore_index=True)
massive_Crossreff_pull.to_csv('massive_Crossreff_pull.csv', index=False)