SELECT *
FROM PortfolioProject..['owid-covid-deaths]
ORDER BY 3,4

SELECT *
FROM PortfolioProject..['owid-covid-vaccinations]
ORDER BY 3,4

-- Select data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..['owid-covid-deaths]
ORDER BY 1,2

-- Looking at Total Cases v. Total Deaths (planetary) 
-- % Likelihood of dying if infected

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject..['owid-covid-deaths]
ORDER BY 1,2

-- Looking at Total Cases v. Total Deaths (USA)
-- % Likelihood of dying if infected

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject..['owid-covid-deaths]
WHERE location LIKE '%states%'
ORDER BY 1,2

-- Looking at Total Cases v. Population
-- % Population infected with Covid (USA)

SELECT location, date, population, total_cases, (total_cases/population)*100 AS percentage_pop_infect
FROM PortfolioProject..['owid-covid-deaths]
WHERE location LIKE '%states%'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percentage_pop_infect
FROM PortfolioProject..['owid-covid-deaths]
GROUP BY location, population
ORDER BY 4 DESC

-- Showing Countries with Highest Death Count per Population
-- Excluding Continent and World Death Counts

SELECT location, MAX(cast(total_deaths as int)) AS total_death_count
FROM PortfolioProject..['owid-covid-deaths]
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC

-- Showing Continents with Highest Death Count per Population

SELECT location, MAX(cast(total_deaths as int)) AS total_death_count
FROM PortfolioProject..['owid-covid-deaths]
WHERE continent IS NULL
GROUP BY location
ORDER BY 2 DESC

-- Global numbers by Date

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS death_percetange
FROM PortfolioProject..['owid-covid-deaths]
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

-- Global total

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS death_percetange
FROM PortfolioProject..['owid-covid-deaths]
WHERE continent IS NOT NULL
ORDER BY 1, 2

--Peaking at the Vaccinations table

SELECT *
FROM PortfolioProject..['owid-covid-vaccinations]

-- Joining Deaths with Vaccinations

SELECT *
FROM PortfolioProject..['owid-covid-deaths] dea
JOIN PortfolioProject..['owid-covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date

-- Looking at Total Population v. New Vaccinations

SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations
FROM PortfolioProject..['owid-covid-deaths] dea
JOIN PortfolioProject..['owid-covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

-- Looking at Total Population v. New Vaccinations 

SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) AS new_total_vaccs
FROM PortfolioProject..['owid-covid-deaths] dea
JOIN PortfolioProject..['owid-covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

-- Using CTE to perform Calculations on Partition By from previous query

WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, new_total_vaccs)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) AS new_total_vaccs
FROM PortfolioProject..['owid-covid-deaths] dea
JOIN PortfolioProject..['owid-covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null 
)
SELECT *, (new_total_vaccs/population)*100 AS pop_percent_vacc
From PopVsVac

-- Temp TABLE adding rolling percent from the previous query

DROP TABLE IF exists #percent_pop_vacc
CREATE TABLE #percent_pop_vacc
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_Pop_Vacc numeric
)

INSERT INTO #percent_pop_vacc
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) AS new_total_vaccs
FROM PortfolioProject..['owid-covid-deaths] dea
JOIN PortfolioProject..['owid-covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (Rolling_Pop_Vacc/population)*100 AS Pop_Percent_Vacc
From #percent_pop_vacc

-- Creating View to store data for later visualizations
-- Comment out all other SQL commands to run properly

CREATE VIEW percent_pop_vacc AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) AS new_total_vaccs
FROM PortfolioProject..['owid-covid-deaths] dea
JOIN PortfolioProject..['owid-covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
;