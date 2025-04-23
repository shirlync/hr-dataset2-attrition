SELECT TOP (1000) [EmpID]
      ,[Age]
      ,[AgeGroup]
      ,[Attrition]
      ,[BusinessTravel]
      ,[DailyRate]
      ,[Department]
      ,[DistanceFromHome]
      ,[Education]
      ,[EducationField]
      ,[EmployeeCount]
      ,[EmployeeNumber]
      ,[EnvironmentSatisfaction]
      ,[Gender]
      ,[HourlyRate]
      ,[JobInvolvement]
      ,[JobLevel]
      ,[JobRole]
      ,[JobSatisfaction]
      ,[MaritalStatus]
      ,[MonthlyIncome]
      ,[SalarySlab]
      ,[MonthlyRate]
      ,[NumCompaniesWorked]
      ,[Over18]
      ,[OverTime]
      ,[PercentSalaryHike]
      ,[PerformanceRating]
      ,[RelationshipSatisfaction]
      ,[StandardHours]
      ,[StockOptionLevel]
      ,[TotalWorkingYears]
      ,[TrainingTimesLastYear]
      ,[WorkLifeBalance]
      ,[YearsAtCompany]
      ,[YearsInCurrentRole]
      ,[YearsSinceLastPromotion]
      ,[YearsWithCurrManager]
  FROM [HR2_Apr2025].[dbo].[HR_Analytics]

/* Existing database */
SELECT *
FROM [dbo].[HR_Analytics]
ORDER BY EmployeeNumber

/* Create View */
CREATE VIEW DuplicateHR2_View AS 
SELECT * FROM [dbo].[HR_Analytics]

/* Create Table to avoid touching basetable */
SELECT * INTO HR_Analytics2 
FROM [dbo].[HR_Analytics]

-- Employee Number 2054, 2055, 2056, 2057, 2060, 2061, 2062, 2064, 2065, 2068 are duplicates of 2
SELECT 
	EmployeeNumber
	,COUNT(*)
FROM [dbo].[HR_Analytics2]
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1

-- Employee Number 2060, 2061, 2062's Years with Current Manager seems to be incorrect
-- Reason: Data collected incorrectly OR employee transferred to a new department
-- Decision: To remove 2060, 2061 and 2062 data & Duplicates of 2054, 2055, 2056, 2057, 2064, 2065, 2068 were removed
SELECT * 
FROM [dbo].[HR_Analytics2]
WHERE EmployeeNumber IN (2054, 2055, 2056, 2057, 2060, 2061, 2062, 2064, 2065, 2068)
ORDER BY EmployeeNumber

DELETE FROM [dbo].[HR_Analytics2]
WHERE EmployeeNumber IN (2060, 2061, 2062)

DELETE FROM [dbo].[HR_Analytics2]
WHERE EmployeeNumber IN (2054, 2055, 2056, 2057, 2064, 2065, 2068)
LIMIT 1;

/* Understanding the Data/Population */
SELECT
	EmployeeNumber
	,EmployeeCount
	,AgeGroup
	,Gender
	,MaritalStatus
	,JobRole
	,EducationField
	,Department
	,Attrition
FROM [dbo].[HR_Analytics2]
ORDER BY EmployeeNumber

-- 18-25 YO: 8.38% (n=123 out of 1467)
-- 26-35 YO: 41.2% (n=605 out of 1467)
-- 36-45 YO: 31.8% (n=466 out of 1467)
-- 46-55 YO: 15.4% (n=226 out of 1467)
-- 55+ YO: 3.2% (n=47 out of 1467)
WITH TotalEmployees AS (
    SELECT SUM(EmployeeCount) AS Total
    FROM [dbo].[HR_Analytics2]
)

SELECT
    COALESCE(AgeGroup, 'Grand Total') AS AgeGroup,
    SUM(EmployeeCount) AS [Num of Employee],

    -- % of Total
    CAST(
        100.0 * SUM(EmployeeCount)
        / (SELECT Total FROM TotalEmployees)
        AS DECIMAL(5,2)
    ) AS [% of Total]

FROM [dbo].[HR_Analytics2]

-- Grouping to include grand total
GROUP BY GROUPING SETS (
    (AgeGroup),  -- Individual AgeGroup rows
    ()           -- Grand Total row
)

ORDER BY 
    CASE WHEN AgeGroup = 'Grand Total' THEN 1 ELSE 0 END, 
    AgeGroup;


-- About 60% (n=880) are Male employees and 40% (n=587) are Female employees
WITH TotalEmployees AS (
    SELECT SUM(EmployeeCount) AS Total
    FROM [dbo].[HR_Analytics2]
)

SELECT
    COALESCE(Gender, 'Grand Total') AS Gender,
    SUM(EmployeeCount) AS [Num of Employee],

    -- % of Total
    CAST(
        100.0 * SUM(EmployeeCount)
        / (SELECT Total FROM TotalEmployees)
        AS DECIMAL(5,2)
    ) AS [% of Total]

FROM [dbo].[HR_Analytics2]

-- Grouping to include grand total
GROUP BY GROUPING SETS (
    (Gender),   -- Individual Gender rows
    ()          -- Grand Total row
)

ORDER BY 
    CASE WHEN Gender = 'Grand Total' THEN 1 ELSE 0 END,  -- Moves Grand Total to the bottom
    Gender;  -- Sorts genders alphabetically or in your preferred order

-- 27.81% (n=326+82=408) are from the Sales Team (Sales Executive & Sales Representative)
-- Followed by Research Scientist (19.9%, n=292) and Lab Technician at n=258 (17.59%) under R&D Team
-- The remaining HR and Manager sits under HR Team
WITH TotalEmployees AS (
    SELECT SUM(EmployeeCount) AS Total
    FROM [dbo].[HR_Analytics2]
)

SELECT
    COALESCE(JobRole, 'Grand Total') AS JobRole,
    SUM(EmployeeCount) AS [Num of Employee],

    -- % of Total
    CAST(
        100.0 * SUM(EmployeeCount)
        / (SELECT Total FROM TotalEmployees)
        AS DECIMAL(5,2)
    ) AS [% of Total]

FROM [dbo].[HR_Analytics2]

-- Grouping to include grand total
GROUP BY GROUPING SETS (
    (JobRole),  -- Individual JobRole rows
    ()          -- Grand Total row
)

ORDER BY 
    CASE WHEN JobRole = 'Grand Total' THEN 1 ELSE 0 END, 
    [Num of Employee] DESC;

SELECT
	SUM (EmployeeCount) [Num of Employee]
	,Department 
	,JobRole
FROM [dbo].[HR_Analytics2]
GROUP BY Department, JobRole
ORDER BY Department

/* Understanding the Attrition Program */
-- 16.2% (n=237 out of 1467) to be on company's attrition program
SELECT
	SUM (EmployeeCount) [Num of Employee]
	,Attrition
FROM [dbo].[HR_Analytics2]
GROUP BY Attrition

-- For those that were being placed on Attrition program, almost half (48.9%, n=116) was from 26-35 YO
WITH TotalAttrition AS (
    SELECT SUM(EmployeeCount) AS TotalYes
    FROM [dbo].[HR_Analytics2]
    WHERE Attrition = 1
)

SELECT
    COALESCE(AgeGroup, 'Total') AS AgeGroup,
    SUM(EmployeeCount) AS Yes_Count,
    CAST(SUM(EmployeeCount) * 100.0 / MAX(ta.TotalYes) AS DECIMAL(5,2)) AS Yes_Percentage_Of_Total_Attrition
FROM [dbo].[HR_Analytics2] h
JOIN TotalAttrition ta ON 1=1
WHERE Attrition = 1
GROUP BY GROUPING SETS ((AgeGroup), ())

-- And 63.3% (n=150) are Male employees
WITH TotalAttrition AS (
    SELECT SUM(EmployeeCount) AS TotalYes
    FROM [dbo].[HR_Analytics2]
    WHERE Attrition = 1
)

SELECT
    COALESCE(Gender, 'Total') AS Gender,
    SUM(EmployeeCount) AS Yes_Count,
    CAST(SUM(EmployeeCount) * 100.0 / MAX(ta.TotalYes) AS DECIMAL(5,2)) AS Yes_Percentage_Of_Total_Attrition
FROM [dbo].[HR_Analytics2] h
JOIN TotalAttrition ta ON 1=1
WHERE Attrition = 1
GROUP BY GROUPING SETS ((Gender), ())

-- More than half (56%) in the attrition program are from R&D Team e.g. Lab Technician (n=62) and Research Scientist (n=47)
-- About 40% (n=92) are from the Sales Team 
WITH TotalAttrition AS (
    SELECT SUM(EmployeeCount) AS TotalYes
    FROM [dbo].[HR_Analytics2]
    WHERE Attrition = 1
)

SELECT
    COALESCE(JobRole, 'Total') AS JobRole,
    SUM(EmployeeCount) AS Yes_Count,
    CAST(SUM(EmployeeCount) * 100.0 / MAX(ta.TotalYes) AS DECIMAL(5,2)) AS Yes_Percentage_Of_Total_Attrition
FROM [dbo].[HR_Analytics2] h
JOIN TotalAttrition ta ON 1=1
WHERE Attrition = 1
GROUP BY GROUPING SETS ((JobRole), ())
ORDER BY Yes_Percentage_Of_Total_Attrition

WITH TotalAttrition AS (
    SELECT SUM(EmployeeCount) AS TotalYes
    FROM [dbo].[HR_Analytics2]
    WHERE Attrition = 1
)

SELECT
    COALESCE(Department, 'Total') AS Department,
    SUM(EmployeeCount) AS Yes_Count,
    CAST(SUM(EmployeeCount) * 100.0 / MAX(ta.TotalYes) AS DECIMAL(5,2)) AS Yes_Percentage_Of_Total_Attrition
FROM [dbo].[HR_Analytics2] h
JOIN TotalAttrition ta ON 1=1
WHERE Attrition = 1
GROUP BY GROUPING SETS ((Department), ())
ORDER BY Yes_Percentage_Of_Total_Attrition

/* Conclusion */
-- Looking at the Population/Data, it seems that the Attrition is not based on Age/ Gender 
-- As almost half of them are witin 26-35 YO
-- It seems that the company is in the midst of downsizing / workforce optimization due to various factors such as economic 
-- vulnerabilities or trying to cut cost or they could have employ too many staff previously. 
-- More than half of the employees being attrited were from R&D Team and subsequently underperforming Salespeople
-- We could look  further at the heatmap to identify which factors are determining which employees is being attrited

SELECT
      EmployeeNumber 
	  ,[Attrition]
      ,[AgeGroup]
	  ,[JobRole]
      ,[DailyRate]
	  ,[HourlyRate]
      ,[MonthlyIncome]
      ,[Department]
	  ,[BusinessTravel]
	  ,[EnvironmentSatisfaction]
      ,[JobSatisfaction]
      ,[OverTime]
      ,[PerformanceRating]
      ,[RelationshipSatisfaction]
      ,[TotalWorkingYears]
      ,[TrainingTimesLastYear]
      ,[WorkLifeBalance]
      ,[YearsAtCompany]
      ,[YearsInCurrentRole]
      ,[YearsSinceLastPromotion]
      ,[YearsWithCurrManager]
  FROM [HR2_Apr2025].[dbo].[HR_Analytics]
  ORDER BY EmployeeNumber
