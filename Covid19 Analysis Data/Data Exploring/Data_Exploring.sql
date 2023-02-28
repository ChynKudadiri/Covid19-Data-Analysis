--- All data ---
SELECT *
FROM Covid19_Project..Covid19_Dataset

--- Covid-19 data in Indonesia
SELECT *
FROM Covid19_Project..Covid19_Dataset
WHERE location = 'Indonesia'

--- Total cases, death and percentage of population in Indonesia today (20/02/2023) ---
SELECT location, date, total_cases, total_deaths,population, (total_cases/population)*100 AS PercentageCasesofPopulation
,(total_deaths/population)*100 AS PercentageDeathofPopulation
FROM Covid19_Project..Covid19_Dataset
WHERE location = 'Indonesia' AND
date IN (SELECT MAX(date) FROM Covid19_Project..Covid19_Dataset)

--- New Cases and New Deaths per Day in Indonesia
SELECT location, date, new_cases, new_deaths 
FROM Covid19_Project..Covid19_Dataset
WHERE location = 'Indonesia'
ORDER BY date DESC

--- New Cases per Day in World ---
SELECT location, date, new_cases, new_deaths 
FROM Covid19_Project..Covid19_Dataset
WHERE location = 'World'
ORDER BY date DESC

--- Data per Continent ---

--- 1. Create temp table
DROP TABLE IF exists #CasesPerContinent
CREATE TABLE #CasesPerContinent
(
continent nvarchar(255) ,
Location nvarchar(255) ,
Population numeric ,
TotalCasesCount numeric,
TotalDeathCount numeric,
NewCasesCount numeric
)
--- 2. Insert into temp table
INSERT INTO #CasesPerContinent
SELECT continent, location,population, MAX(CAST(total_cases AS int)) AS TotalCasesCount, 
MAX(CAST(total_deaths AS int)) AS TotalDeathCount, SUM(cast(new_cases AS int)) AS NewCasesCount
FROM Covid19_Project..Covid19_Dataset
WHERE continent is not NULL AND
location not in ('World', 'European Union', 'International')
GROUP BY continent, location, population
ORDER BY continent, location ASC

---3. Show all data per continent
SELECT * FROM #CasesPerContinent

--- 4. Select cases per continent
SELECT continent, SUM(Population) AS Population, SUM(TotalCasesCount) as Total_Cases, SUM(TotalDeathCount) AS Total_Death,
SUM(NewCasesCount) AS New_Cases, (SUM(TotalCasesCount)/SUM(Population))*100 AS PercentCasesperPopulation
,(SUM(TotalDeathCount)/SUM(Population))*100 AS PercentDeathperPopulation
FROM #CasesPerContinent
GROUP BY continent
ORDER BY continent

--- Total Cases and Total Death in The World Today
SELECT *, (total_cases/population)*100 as PercentCasesPerWorldPopulation,(total_deaths/population)*100 as PercentDeathPerWorldPopulation
FROM Covid19_Project..Covid19_Dataset
WHERE location = 'World' AND
date IN (SELECT MAX(date) from Covid19_Project..Covid19_Dataset)

--- Indonesia VS World Population
SELECT location, population 
FROM Covid19_Project..Covid19_Dataset
WHERE location IN ('World', 'Indonesia')
AND date IN (SELECT MAX(date) FROM Covid19_Project..Covid19_Dataset)
order by date desc

--- TOP 5 Country with Highest Cases
SELECT TOP 5 continent,location, date, total_cases
FROM Covid19_Project..Covid19_Dataset
WHERE date IN (SELECT MAX(date) from Covid19_Project..Covid19_Dataset) 
AND continent is not null 
ORDER BY total_cases DESC