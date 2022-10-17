-- Browse the entire dataset for covid_deaths
SELECT *
FROM PortfolioProject..covid_deaths
ORDER BY 3,4

--- Browse the entire dataset for covid_vaccinations
SELECT *
FROM PortfolioProject..covid_vaccinations
ORDER BY 3,4

--- Browse the selected columns from the dataset for covid_deaths
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..covid_deaths
ORDER BY 1,2

--- Explore total_cases vs total_deaths for Canada
-- Likelihood of dying from contracting covid (not accounting vaccinations)
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM PortfolioProject..covid_deaths
WHERE location like 'Canada'
ORDER BY 1,2

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
--DROP VIEW if exists death_percentage_canada
--CREATE VIEW death_percentage_canada as
--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
--FROM PortfolioProject..covid_deaths
--WHERE location like 'Canada'

--- Explore total_cases vs population for Canada
-- Percentage of the population that contracted covid overtime
Select location, date, total_cases, population, (total_cases/population)*100 as cases_per_population_percentage
From PortfolioProject..covid_deaths
WHERE location like 'Canada'
Order By 2

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
--DROP VIEW if exists cases_per_population_percentage_canada
--CREATE VIEW cases_per_population_percentage_canada as
--Select location, date, total_cases, population, (total_cases/population)*100 as cases_per_population_percentage
--From PortfolioProject..covid_deaths
--WHERE location like 'Canada'

--- Explore max infection count vs their population
--SELECT location, population, MAX(total_cases) as max_infection_count, MAX((total_cases/population))*100 as infected_population_percentage
--FROM PortfolioProject..covid_deaths
--GROUP BY location, population
--ORDER BY infected_population_percentage desc
--- We realize that there are rows containing grouped data (world, high income, asia, etc.) and not just for an individual country 
--- Looking at the continent and location columns, null values for continent indicate that that row contains grouped data so we need to exclude it using WHERE

--- Explore max infection count vs their population
-- Percentage of the population that ended up contracting covid
SELECT location, population, MAX(total_cases) as max_infection_count, MAX((total_cases/population))*100 as infected_population_percentage
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY location, population
ORDER BY infected_population_percentage DESC

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
DROP VIEW if exists infected_population_percentage
CREATE VIEW infected_population_percentage as
SELECT location, population, MAX(total_cases) as max_infection_count, MAX((total_cases/population))*100 as infected_population_percentage
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY location, population

--- Explore max infection count vs their population (with date)
-- Percentage of the population that ended up contracting covid
SELECT location, date, population, MAX(total_cases) as max_infection_count, MAX((total_cases/population))*100 as infected_population_percentage
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY location, population, date
ORDER BY infected_population_percentage DESC

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
DROP VIEW if exists date_infected_population_percentage
CREATE VIEW date_infected_population_percentage as
SELECT location, date, population, MAX(total_cases) as max_infection_count, MAX((total_cases/population))*100 as infected_population_percentage
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY location, population, date

--- Explore countries with the highest death count
--Select location, MAX(total_deaths) as max_death_count
--From PortfolioProject..covid_deaths
--Group By location 
--Order By max_death_count desc
--- We realize the data type of total_deaths is nvarchar so we need to change it into integer using CAST

--- Explore countries with the highest death count 
-- Total death count by country
SELECT location, SUM(CAST(new_deaths as int)) as max_death_count
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY location 
ORDER BY max_death_count DESC

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
--DROP VIEW if exists max_death_count_countries
--CREATE VIEW max_death_count_countries as
--SELECT location, SUM(CAST(new_deaths as int)) as max_death_count
--FROM PortfolioProject..covid_deaths
--WHERE continent is not null
--GROUP BY location 

--- Explore the highest death count within the grouped data we previous found under the locations column
-- Total death count by predefined groups within the dataset
SELECT location, SUM(CAST(new_deaths as int)) as max_death_count
FROM PortfolioProject..covid_deaths
WHERE continent is null
GROUP BY location 
ORDER BY max_death_count DESC

--- Explore the highest death count within the grouped data involving continents we previous found under the locations column
-- Total death count by predefined continents within the dataset
SELECT location, SUM(CAST(new_deaths as int)) as max_death_count
FROM PortfolioProject..covid_deaths
WHERE continent is null AND location not in ('World', 'High income', 'Upper middle income', 'lower middle income', 'low income', 'International', 'European Union')
GROUP BY location 
ORDER BY max_death_count DESC

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
DROP VIEW if exists max_death_count_continent
CREATE VIEW max_death_count_continent as
SELECT location, SUM(CAST(new_deaths as int)) as max_death_count
FROM PortfolioProject..covid_deaths
WHERE continent is null AND location not in ('World', 'High income', 'Upper middle income', 'lower middle income', 'low income', 'International', 'European Union')
GROUP BY location 

--- Explore the number of new_cases vs new_deaths from a global perspective per day
-- Sum of new cases and deaths that occurred in the world each day
-- Percentage of new deaths from new cases that occurred each day
SELECT date, SUM(new_cases) as total_new_cases, SUM(CAST(new_deaths as int)) as total_new_deaths, (SUM(CAST(new_deaths as int))/SUM(new_cases))*100 as new_case_death_percentage
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY date 
ORDER BY 1

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
--DROP VIEW if exists new_case_death_percentage
--CREATE VIEW new_case_death_percentage as
--SELECT date, SUM(new_cases) as total_new_cases, SUM(CAST(new_deaths as int)) as total_new_deaths, (SUM(CAST(new_deaths as int))/SUM(new_cases))*100 as new_case_death_percentage
--FROM PortfolioProject..covid_deaths
--WHERE continent is not null
--GROUP BY date 

--- Explore the total number of new_cases vs new_deaths from a global perspective 
-- Total number of new cases and deaths that occurred in the world (as of most recent date in the dataset)
-- Percentage of deaths from cases that occurred (as of most recent date in the dataset)
SELECT SUM(new_cases) as total_new_cases, SUM(CAST(new_deaths as int)) as total_new_deaths, (SUM(CAST(new_deaths as int))/SUM(new_cases))*100 as new_case_death_percentage
FROM PortfolioProject..covid_deaths
WHERE continent is not null

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
DROP VIEW if exists total_case_death_percentage
CREATE VIEW total_case_death_percentage as
SELECT SUM(new_cases) as total_new_cases, SUM(CAST(new_deaths as int)) as total_new_deaths, (SUM(CAST(new_deaths as int))/SUM(new_cases))*100 as new_case_death_percentage
FROM PortfolioProject..covid_deaths
WHERE continent is not null 

--- Join the covid_deaths and covid_vaccination datasets together by location and date
SELECT *
FROM PortfolioProject..covid_deaths dea
JOIN PortfolioProject..covid_vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date

--- Browse the selected columns from the joined dataset 
-- Recall that there is predefined grouped date in the locations column which we need to exclude to only pull date for each individual country
SELECT dea.continent, dea.location, dea.date, dea.population, dea.new_cases, vac.new_vaccinations
FROM PortfolioProject..covid_deaths dea
JOIN PortfolioProject..covid_vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3

--- Create a rolling count of new vaccinations for each country
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_vaccination_count
--FROM PortfolioProject..covid_deaths dea
--JOIN PortfolioProject..covid_vaccinations vac
--on dea.location = vac.location AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2, 3
--- We realize the data type of total_vaccinations is nvarchar so we need to change it into integer using CAST
--- An error occurred when we tried to convert to int due to exceeding range so we used bigint 

--- Create a rolling count of new cases and new vaccinations for each country
SELECT dea.continent, dea.location, dea.date, dea.population, dea.new_cases, vac.new_vaccinations, SUM(CAST(dea.new_cases as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_case_count, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_vaccination_count
FROM PortfolioProject..covid_deaths dea
JOIN PortfolioProject..covid_vaccinations vac
on dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3

--- Create a new table for the above so that we can perform new calculations with our rolling_vaccination_count column
DROP TABLE if exists population_vaccination
CREATE TABLE population_vaccination
(
continent nvarchar(255),
location nvarchar(225),
date datetime,
population numeric,
new_cases numeric,
rolling_case_count numeric,
new_vaccinations numeric,
rolling_vaccination_count numeric
)
INSERT INTO population_vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, dea.new_cases, SUM(CAST(dea.new_cases as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_case_count, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_vaccination_count
FROM PortfolioProject..covid_deaths dea
JOIN PortfolioProject..covid_vaccinations vac
on dea.location = vac.location AND dea.date = vac.date

--- Explore the max number of cases and vaccinations
SELECT SUM(new_cases) as total_new_cases, SUM(new_vaccinations) as total_new_vaccinations, (SUM(new_vaccinations)/SUM(new_cases))*100 as total_vaccination_cases_percentage
FROM population_vaccination
WHERE continent is not null

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
DROP VIEW if exists total_vaccination_case_percentage
CREATE VIEW total_vaccination_case_percentage as
SELECT SUM(new_cases) as total_new_cases, SUM(new_vaccinations) as total_new_vaccinations, (SUM(new_vaccinations)/SUM(new_cases))*100 as total_vaccination_cases_percentage
FROM population_vaccination
WHERE continent is not null

--- Explore the rolling_vaccination count vs population
-- Percentage of the population vaccinated based on rolling count of vaccinations for each country
SELECT *, (rolling_vaccination_count/population)*100 as vaccinated_population_percentage
FROM population_vaccination
WHERE continent is not null
ORDER BY 2, 3

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
DROP VIEW if exists vaccinated_population_percentage
CREATE VIEW vaccinated_population_percentage as
SELECT location, date, population, rolling_vaccination_count, (rolling_vaccination_count/population)*100 as vaccinated_population_percentage
FROM population_vaccination
WHERE continent is not null

--- Explore countries with the highest vaccination count 
-- Total vaccination count by country
SELECT location, population, MAX(rolling_vaccination_count) as total_vaccination_count
FROM population_vaccination
WHERE continent is not null
GROUP BY location, population
ORDER BY  total_vaccination_count DESC

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
--DROP VIEW if exists total_vaccination_count
--CREATE VIEW total_vaccination_count as
--SELECT location, population, MAX(rolling_vaccination_count) as total_vaccination_count
--FROM population_vaccination
--WHERE continent is not null
--GROUP BY location, population
--ORDER BY total_vaccination_count DESC

--- Create a new table for the above so that we can perform new calculations with our total_vaccination_count column
DROP TABLE if exists population_vaccination_total
CREATE TABLE population_vaccination_total
(
location nvarchar(225),
population numeric,
total_vaccination_count numeric
)
INSERT INTO population_vaccination_total
SELECT location, population, MAX(rolling_vaccination_count) as total_vaccination_count
FROM population_vaccination
WHERE continent is not null
GROUP BY location, population

--- Explore countries with the highest vaccination count 
-- Total vaccination percentage by country
SELECT location, population, total_vaccination_count, (total_vaccination_count/population)*100 as population_vaccination_percentage
FROM population_vaccination_total
GROUP BY location, population, total_vaccination_count
ORDER BY population_vaccination_percentage DESC

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
DROP VIEW if exists population_vaccination_percentage
CREATE VIEW population_vaccination_percentage as
SELECT location, population, total_vaccination_count, (total_vaccination_count/population)*100 as population_vaccination_percentage
FROM population_vaccination_total
GROUP BY location, population, total_vaccination_count

--- Explore the highest vaccination count within the grouped data involving continents we previous found under the locations column
-- Total vaccination count by predefined continents within the dataset
SELECT location, SUM(CAST(new_vaccinations as bigint)) as total_vaccination_count
FROM population_vaccination
WHERE continent is null AND location not in ('World', 'High income', 'Upper middle income', 'lower middle income', 'low income', 'international', 'european union')
GROUP BY location 
ORDER BY total_vaccination_count DESC

--- Create a view to store data for visualization
-- If visualizing in Tableau, need to replace NULL with 0 or else it can get mistaken for a string
DROP VIEW if exists total_vaccination_count_continent
CREATE VIEW total_vaccination_count_continent as
SELECT location, SUM(CAST(new_vaccinations as bigint)) as total_vaccination_count
FROM population_vaccination
WHERE continent is null AND location not in ('World', 'High income', 'Upper middle income', 'lower middle income', 'low income', 'international', 'european union')
GROUP BY location

