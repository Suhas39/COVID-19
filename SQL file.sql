create database Covid19_1;
use Covid19_1;
select * from covid_19;
alter table covid_19 drop Column MyUnknownColumn;   
select * from covid_19;

select * from covid_timeseries_pro2;
alter table covid_timeseries_pro2 drop Column MyUnknownColumn;   
select * from covid_timeseries_pro2;

-- 1. Weekly evolution of number of confirmed cases, recovered cases, deaths, tests.
select week(dates) as weeks,

       sum(delta_confirmed) as total_confirmed_cases,
       sum(delta_recovered) as total_recovered_cases,
       sum(delta_deceased) as total_deaths,
       sum(delta_tested) as total_tests
from covid_timeseries_pro2
group by week(dates)
order by week(dates) asc;

-- 2. Let’s call testing ratio(tr) = (number of tests done) / (population), now categorise every district in one of the following categories:
-- - Category A: 0.05 ≤ tr ≤ 0.1
-- - Category B: 0.1 < tr ≤ 0.3
-- - Category C: 0.3 < tr ≤ 0.5
-- - Category D: 0.5 < tr ≤ 0.75
-- - Category E: 0.75 < tr ≤ 1.0
-- Now perform an analysis of number of deaths across all category.
select category,
	sum(total_deceased) as total_deaths
from covid_19
group by category
order by total_deaths;

-- Generate 2 - 3 insights that is very difficult to observe
-- Insight 1: Comparing Testing and Vaccination Efforts
select 
    ctf.state,
    monthname(ctf.dates),
    ctf.delta_tested,
    c19.delta_vaccinated1,
    c19.delta_vaccinated2
from 
    covid_timeseries_pro2 ctf
inner join
    covid_19 c19 on ctf.state = c19.state;
    
-- Insight 2 :Death Rate by State and Population
select 
    state,
    total_deceased,
    population,
    (total_deceased / population) * 100000 as death_rate_per_100k
from 
    covid_19;


-- Insight 3: Variation in Testing and Recovery Rates
select
    state,
    delta7_tested,
    delta7_recovered,
    (delta7_recovered / delta7_tested)*100 as recovery_rate
from
	covid_19;
 


-- 4. Compare delta7 confirmed cases with respect to vaccination
select
	state,
    delta7_confirmed,
    delta7_vaccinated1,
    delta7_vaccinated2
from 
    covid_19;
    
-- 5. Make at least 2 such KPI that presents the severity of case in different states 
-- KPI 1: Case Severity Ratio
select 
    state,
    (total_deceased / total_confirmed) * 100 AS case_severity_ratio
from 
    covid_19;
-- KPI 2: Death Rate per Million
select 
    state,
    (total_deceased / population) * 1000000 AS death_rate_per_million
from 
    covid_19;
    
-- 6. Categorise total number of confirmed cases in a state by Months
select 
    monthname(dates) as month,
    sum(total_confirmed) as total_cases
from 
    covid_timeseries_pro2
group by 
	monthname(dates);
drop table covid_timeseries_pro
    