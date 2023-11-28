# SMU_MSDS_Capstone_Fall_2023

This was a project undertaken by Raag Patel and Roslyn Smith, with advisor Dr. Monnie Mcgee. 

The paper is titled : The Impact of the COVID-19 Pandemic on Faculty Productivity and Gender Inequalities in STEM Disciplines

Here, you will find the associated code and data. If there are issues/comments/concerns feel free to reach out to raagpatel1@gmail.com

In the data folder, you will find CSV's compiled by Dr. McGee, in her initial foray to the research. We took an alternative approach, utilizing the rise of Chat-GPT to help us webscrape hundreds of thousands of articles. Chat-GPT assisted in coding for us the web scraper, through Crossref. Simply running "MassiveCrossrefPull.py" should do the work. There you can adjust parameters to choose what information you would like to use/pull. It will also convert the DF to a csv to be saved somewhere on your machine. This operation (pulling from crossref mainly) may take upwards of 3-4 hours. 

subjects_list_crossref.txt is simply a list of subjects that Crossref currently has labelled for articles. 

analysis_raag & analysis_roslyn are each of our ways of tinkering with the data. In _raag, you will find the gender applier, which can simply be extracted and used for your own use. They maybe a mess, and might require some time to understand what is going on in there. Sorry!