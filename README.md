### Human Resource Dataset / People Analytics:
# Employees Involved in Workforce Optimization Program
- Source of Dataset: Kaggle (https://www.kaggle.com/datasets/anshika2301/hr-analytics-dataset)
- Data Cleaning: SQL Server Management Studio 20 & ChatGPT
- EDA & Data Visualization: Jupyter Notebook & Power BI & Microsoft Excel

# Definition of Selected Parameters in HR Dataset
- Employee Number: ID assigned to each employee (N=1467 / ID from 1 to 2068)
- Attrition: 0 = Not part of workforce optimization program; 1 = Selected to be part of workforce optimization program
- Age Group: Age of Employees
- Job Role / Department = Designation and Deparment where the Employees work at
- Monthly Income = Monthly Salary of Employees
- Environment Satisfaction = Employee Satisfaction towards Environment in Company (Rate: 1 to 4)
- Job Satisfaction = Employee Satisfaction towards their Job (Rate: 1 to 4)
- Performance Rating = Rating towards Employee's Performance (Rate: 1 to 4)
- Relationship Satisfaction = Employee Satisfaction towards Relationship with Manager (Rate: 1 to 4)
- Total Working Years = Number of Years Employee work with Company
- Years since last Promotion = Years since the Employee was promoted

# Analysis of the HR Dataset
### Data Cleaning in SQL:
- There are 10 Employee Number/ID with 2 duplicate rows of data (Potential Reason: Data collected incorrectly, or employee transferred to a new department)
- Employee 2060, 2061, and 2062 were removed due to inability to ascertain which row is correct
- Employee 2054, 2055, 2056, 2057, 2064, 2065, and 2068 - one row was removed from each employee due to duplicate data

### Understanding Dataset / Population:
- 73.0% (n=1071) are within the age group of 26 to 45 YO

| Age Group | n | % |
|----------|----------|----------|
| 18-25 YO | 123   | 8.4%    |
| 26-35 YO | 605   | 41.2%   |
| 36-45 YO | 466  | 31.8%   |
| 46-55 YO | 226   | 15.4%   |
| 55+ YO | 47   | 3.2%   |
| Total | 1467 | 100% |

- 60% (n=880) are Male employees, whereas 40% (n587) are Female employees
- Majority of the employees sit in the Research & Development Team (Research Scientist = 19.9%, n=292, and Lab Technician = 17.6%, n=258), and Sales Team (Sales Executive & Sales Representative = 27.8%, n=408)
- Out of 1467 employees, 237 (16.2%) were selected to be part of the workforce optimization program
- In the program, 150 (more than 60%) of them are Male employees and 116 (almost 50%) of them are within 26 to 35 years old

# Findings / Conclusion:
- It seems that the employees selected to be part the workforce optimization program is not based on age/gender. 
- I could deduce that the company is in the midst of downsizing or cutting cost due to factors such as economic vulnerabilities or they could have employ too many staff previously, and are now trying to optimize their workforce.
- Using describe() function in Jupyter Notebook, the employees satisfaction towards the company environment, job, relationship with manager and work life balance are slightly higher than average (about 2.7 to 2.8 in a 4-point scale). Hence, these are not factors considered when HR/Management decide on which employee should be place in the workforce optimization program.
- One datapoint that stood out was 'years since last promotion' and 'years at company' - at least 67% (n=159 out of 237) of employees that were selected for the program were those have not been promoted for the last 1 year and at least 50% (n=81) of these employees were only with the company for less than 2 years.
- Additionally, 57% (n=137) of employees are receiving less than $4000 monthly income, 80% of attrited employees are receiving less than $8000 monthly.
- This further proves that the company did over-hire in the past 2 years and are now trying to dial back to focus on existing core employees of the company. 







