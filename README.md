
## Description

For this project, I wrote code in Python to access the GovTrack API to download basic data on all bills passed by Congress and signed by the President from the 93rd Congress (1973-4) to the 114th (current). I treated the titles of the bills as a corpus of text for analysis. Then, in R, I processed the titles and used structural topic modeling to sort the bills into categories. I used the stm package in R for the modeling, as well as to explore and visualize the data with regards to how the categories change in prevalence over time.

## Dependencies

1. R, version 3.3.1
2. Python 3.5.2, Anaconda3 distribution.
3. LaTeX, MiKTeX 2.9 distribution.


## Files

### Data

All data was obtained through the GovTrack API, documentation for which can be found here: https://www.govtrack.us/developers/api 

The data was downloaded in batches, identical in format, each of which contains raw data about bills from a number of Congresses. These were merged and cleaned in R. 
1. bills9394_API: bills from the 93rd and 94th Congress
2. bills9599_API: bills from the 95th through 99th Congress
3. bills0004_API: bills from the 100th through 104th Congress
4. bills0509_API: bills from the 105th through 109th Congress
5. bills1014_API: bills from the 110th through 114th Congress

### Code

1. govtrack-API-collection.ipynb: Collects and downloads the raw bill data.
2. clean-and-analyze.r: Cleans data, sorts into categories, presents graphics.

### Presentation Files
Includes figures of results and other files needed to compile the final presentation.

1. presentation.tex: Presentation code.
2. houseactivity.png: Illustrative bill list for presentation.
3. stopwords.png: Shows custom stop words code for presentation.
4. wordcloud.png: Sample word cloud showing results of structural topic modeling.
5. frequency.pdf: Shows labeled topic frequencies.
6. effect1.pdf, effect2.pdf, and effect3.pdf: Frequency change of selected topics over time.

## More Information

For questions and concerns, contact elizabeth_mitchell@berkeley.edu .
