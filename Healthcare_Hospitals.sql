SELECT *
FROM healthcare_dataset;

-- Average billing amount
SELECT ROUND(AVG(Billing_Amount),2) AS Avg_Amt
FROM healthcare_dataset;

--Revenue generated
SELECT SUM(Billing_Amount) AS Revenue
FROM healthcare_dataset;

--Amount spent on Medical condition
SELECT Medical_Condition, SUM(Billing_Amount) AS Revenue
FROM healthcare_dataset
GROUP BY Medical_Condition
ORDER BY Revenue DESC;

--Number of patients admited by each medical condition
SELECT COUNT(*) AS Patient, Medical_Condition
FROM healthcare_dataset
GROUP BY Medical_Condition
ORDER BY Patient DESC;

-- Number of patient by Admission type
SELECT Admission_Type, COUNT(*) AS Patients
FROM healthcare_dataset 
GROUP BY Admission_Type;

-- Average no of days a patient stays in hospital
SELECT AVG(DATEDIFF(day, Date_of_Admission, Discharge_Date)) AS AvgStayDays
FROM healthcare_dataset;

-- Insurance provider and SUM and Average amount of insurance
SELECT Insurance_Provider,
SUM(Billing_Amount) AS SUM_amount,
AVG(Billing_Amount) AS AVG_amount
FROM healthcare_dataset
GROUP BY Insurance_Provider;

--Revenue by month of year
SELECT DATEPART(YEAR, Date_of_Admission) AS Year,
       DATEPART(MONTH, Date_of_Admission) AS Month,
       SUM(Billing_Amount) AS Revenue
FROM healthcare_dataset
GROUP BY DATEPART(YEAR, Date_of_Admission),
       DATEPART(MONTH, Date_of_Admission)
ORDER BY Revenue DESC;

-- Amount spent by Gender in Hospital
SELECT Gender, AVG(Billing_Amount) AS Avg_Amt
FROM healthcare_dataset
GROUP BY Gender
ORDER BY AVG(Billing_Amount) DESC;

--Number of rooms in hospital
SELECT COUNT(DISTINCT Room_Number) AS Unique_Rooms
FROM healthcare_dataset

--Rank od medical condition by gender anove age 80
SELECT * FROM 
(SELECT Age, Gender, Medical_Condition,
ROW_NUMBER () OVER(PARTITION BY Gender ORDER BY Age DESC) AS Row_no
FROM healthcare_dataset) AS Number
WHERE Age > 80;

--patients above age 84 with hypertension 
SELECT * FROM 
(SELECT Age, Gender, Medical_Condition,
ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY Age DESC) AS Row_no
FROM healthcare_dataset) AS Number
WHERE Medical_Condition = 'Hypertension' AND  Age > 84;

-- Finding Rank & Maximum number of medicines recommended to patients based on Medical Condition pertaining to them.    
SELECT Medical_Condition, Medication, COUNT(Medication) AS med,
RANK() OVER(PARTITION BY Medical_Condition ORDER BY COUNT(Medication) DESC) AS Rank_med
FROM healthcare_dataset
GROUP BY Medical_Condition, Medication
ORDER BY COUNT(Medication) DESC;

-- Finding Rank & Blood type  to patients based on Medical Condition pertaining to them.    
SELECT Blood_Type, Medical_Condition, COUNT(Medical_Condition) AS Conditions,
RANK() OVER(PARTITION BY Blood_Type ORDER BY COUNT(Medical_Condition)DESC) AS Rank_Med
FROM healthcare_dataset
GROUP BY Medical_Condition, Blood_Type
ORDER BY COUNT(Medical_Condition) DESC;

-- Most preffered Insurance Provide  by Patients Hospatilized
SELECT Insurance_Provider, COUNT(Insurance_Provider) AS count
FROM healthcare_dataset
GROUP BY Insurance_Provider
ORDER BY COUNT(Insurance_Provider) DESC;

--Finding Billing Amount of patients admitted and number of days spent in respective hospital.
SELECT Name,Medical_Condition, Hospital, DATEDIFF(day,Date_of_Admission, Discharge_Date) AS no_days, 
SUM(ROUND(Billing_Amount,2)) OVER(PARTITION BY Hospital) AS Total
FROM healthcare_dataset
ORDER BY Medical_Condition;

--Finding Total number of days sepnt by patient in an hospital for given medical condition
SELECT Name,Medical_Condition, Hospital, DATEDIFF(day,Date_of_Admission, Discharge_Date) AS no_days, Billing_Amount
FROM healthcare_dataset

-- Finding Hospitals which were successful in discharging patients after having test results as 'Normal' with count of days 
--taken to get results to Normal
SELECT Medical_Condition, Hospital, DATEDIFF(day,Date_of_Admission, Discharge_Date) AS no_days, Test_Results
FROM healthcare_dataset
WHERE Test_Results = 'Normal' AND Medical_Condition = 'Cancer'
ORDER BY Medical_Condition, Hospital

--Calculate number of blood types of patients which lies betwwen age 20 to 45
SELECT Age, Blood_Type, COUNT(Blood_Type) AS B_Count
FROM healthcare_dataset
WHERE Age BETWEEN 20 AND 45
GROUP BY Age, Blood_Type
ORDER BY Blood_Type DESC;

--Find how many of patient are Universal Blood Donor and Universal Blood reciever
SELECT DISTINCT (SELECT Count(Blood_Type) FROM healthcare_dataset WHERE Blood_Type IN ('O-')) AS Universal_Blood_Donor, 
(SELECT Count(Blood_Type) FROM healthcare_dataset WHERE Blood_Type  IN ('AB+')) as Universal_Blood_reciever
FROM healthcare_dataset;

--Provide a list of hospitals along with the count of patients admitted in the year 2024 AND 2025?
SELECT DISTINCT Hospital, COUNT(*) AS patients
FROM healthcare_dataset
WHERE YEAR(Date_of_Admission) IN (2024, 2025)
GROUP BY Hospital
ORDER BY patients DESC;

--Create a new column that categorizes patients as high, medium, or low risk based on their medical condition.
SELECT Name, Medical_Condition, Test_Results,
CASE 
		WHEN Test_Results = 'Inconclusive' THEN 'Need More Checks / CANNOT be Discharged'
        WHEN Test_Results = 'Normal' THEN 'Can take discharge, But need to follow Prescribed medications timely' 
        WHEN Test_Results =  'Abnormal' THEN 'Needs more attention and more tests'
        END AS 'Status', Hospital, Doctor
FROM healthcare_dataset;