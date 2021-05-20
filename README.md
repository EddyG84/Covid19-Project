- Downloaded and opened online data set

- Saved a copy from csv to xlsx

- Created duplicate data set for manipulation

- Cut and paste column AS to E (would have to join each line later in SQL, this mitigates the   number of joins required)

- Removed irrelavant data for separate "death table" from the spreadsheet (columns AA and   beyond)

- Saved under owid-covid-table

- Undid the deletion of columns AA, then deleted all data past E leaving (death data)

- Saved as owid-covid-death

- Removed all data that had null values before 12/2/2020, finding first vaccinations in AJ

- Saved as owid-covvid-vaccinations

- Uploaded both "deaths" and "vaccinated" tables into MS SQL Server

- Queried ALL (*) from both "deaths" and "vaccinated" tables to confirm data count

- Ordered by columns 3 and 4 to double check data (Screenshot 73)

- Selected several columns from "deaths" table, ordered by 3rd and 4th rows (Screenshot 75)

- Created %'s for deaths/cases for both the planet and the US (Screenshot 77)

- Created %'s for number of population contracting Covid by date

- Queried countries with highest infection rate compared to their population (Screenshot 78)

- Queried countries and continents MAX total deaths (Screenshot 79)

- Queried number of deaths and percentages by date per Continent, then Global total

- Looked into the Vaccinations table

- Joined both the Deaths and Vaccinations tables by location and date (Screenshot 80)

- Created a rolling number of new total vaccinations as new_total_vaccs, adding from each     date and ordered by death locations and dates (Screenshot 81)

- Upgraded the previous query using WITH function to add % of population vaccinated   (Screenshot 82)

- Upgraded previous "WITH" query with added rolling percent (Screenshot 83)

- Created a View for future use in Tableau (Screenshot 84)
