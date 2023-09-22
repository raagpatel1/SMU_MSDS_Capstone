import requests
import pandas as pd

rows = 1000

def get_articles_by_year(year, rows=rows):
    base_url = 'https://api.crossref.org/works'
    params = {
        'filter': f'from-pub-date:{year}-01-01,until-pub-date:{year}-12-31',
        'sort': 'relevance',
        'rows': rows  # Adjust this number to change the number of articles per year
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

years_to_pull = [2020, 2021, 2022, 2023]
all_articles = []

for year in years_to_pull:
    articles = get_articles_by_year(year, rows = rows)  # Adjust this number for the desired articles per year
    all_articles.extend(articles)

data = {
    'DOI': [],
    'Title': [],
    'Container Title': [],
    'Publisher': [],
    'Publish Date': [],
    'Author First Name': [],
    'Author Last Name': [],
    'Author Order': [],
    'Referenced By': []
}

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

crossrefData = pd.DataFrame(data)
crossrefData.columns = ['DOI', 'Title', 'Container Title', 'Publisher', 'Publish Date', 'Author First Name', 'Author Last Name', 'Author Order', 'Referenced By']