SELECT location, [date], total_cases, new_cases, total_deaths, population
From CovidDeaths
ORDER BY 1,2

--Show death percentage 
    SELECT [location], [date], total_cases, total_deaths,
    (total_deaths/total_cases*100)  as DeathPercentage
    from CovidDeaths
     WHERE [location] LIKE '%vie%'
    ORDER by 1,2

    --Show percentage of population got Covid
    SELECT [location], [date], total_cases, population,
    (total_cases/ population) *100  as CovidContractedPercentage
    from CovidDeaths
    WHERE [location] LIKE '%vie%'
    ORDER by 1,2

    --Show the countries with Highest Infection Rate compared to population
   
    SELECT [location], population, MAX(total_cases) as HighestInfectionCount,
    MAX((total_cases/population)*100) as PopulationInfectedPercentage
    from CovidDeaths
    GROUP BY [location], population
    ORDER by 3 desc , 4 DESC

     --Show the countries with Highest Death Count per population
   SELECT [location], MAX(total_cases) as Death
   from CovidDeaths
   WHERE continent is not null
GROUP BY [location]
order by Death DESC

--Global Numbers
SELECT [date], SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as int)) as TotalDeaths,
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths
WHERE continent is not null
 GROUP by [date] 
 order by 1

 --Show Population Vs Vacinations
select dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER
 (PARTITION by dea.location order by dea.date) RollingPeopleVacinated,
 (RollingPeopleVacinated/population)*100   
from CovidDeaths as dea 
JOIN CovidVacinations as vac 
on dea.[location] = vac.[location]
AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
order BY 2, 3    


--Use CTE
With PopVsVac (continent, [location],date, population, new_vaccinations,RollingPeopleVacinated)
as (
select dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER
 (PARTITION by dea.location order by dea.date) RollingPeopleVacinated      
from CovidDeaths as dea 
JOIN CovidVacinations as vac 
on dea.[location] = vac.[location]
AND dea.[date] = vac.[date]
WHERE dea.continent is not NULL
)
select *
from PopVsVac




























