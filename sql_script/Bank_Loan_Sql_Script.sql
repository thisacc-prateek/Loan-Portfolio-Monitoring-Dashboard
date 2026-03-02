

SELECT*FROM bank_loan

--total loan applications
SELECT 
	COUNT(id) [Total Loan Applications] 
FROM bank_loan;

--Month To Date(MTD) Data

SELECT 
	YEAR(issue_date) [Year],
	DATENAME(MONTH,issue_date) [Name Of Month], 
	COUNT(id) [Total Loan Applications]
FROM bank_loan
GROUP BY
		YEAR(issue_date),
		DATENAME(MONTH,issue_date),
		MONTH(issue_date)
ORDER BY 
		MONTH(issue_date);

--Previous MTD
SELECT
	[Year Of Month],
	Month,
	[Total Applications],
	LAG([Total Applications],1,NULL) OVER(ORDER BY issdate) [Previous Month] 
FROM
(
SELECT
	YEAR(issue_date) [Year Of Month],
	MONTH(issue_date) [issdate],
	DATENAME(MONTH,issue_date) [Month],
	COUNT(*) [Total Applications]
FROM bank_loan
	GROUP BY YEAR(issue_date), DATENAME(MONTH,issue_date), MONTH(issue_date)
) AS t


--totalfundedamount
SELECT 
	YEAR(issue_date) Year_,
	SUM(loan_amount) [Total Funded Amount] 
FROM bank_loan
	GROUP BY YEAR(issue_date)

--MTD OF FUNDED AMOUNT
SELECT
	YEAR(issue_date) [Year Of Month],
	DATENAME(MONTH,issue_date) [Month Name],
	SUM(loan_amount) [Total Funded Amount]
FROM bank_loan
	GROUP BY 
		YEAR(issue_date),
		DATENAME(MONTH,issue_date),
		MONTH(issue_date)
	ORDER BY 
		MONTH(issue_date);

--Previous MTD OF FUNDED AMOUNT

SELECT 
	[Year Of Month],
	[Month Name],
	[Total Funded Amount],
	LAG([Total Funded Amount],1,NULL) OVER(ORDER BY Mnth) [Previous MTD]
FROM 
(
SELECT 
	YEAR(issue_date) [Year Of Month],
	MONTH(issue_date) [Mnth],
	DATENAME(MONTH,issue_date) [Month Name],
	SUM(loan_amount) [Total Funded Amount]
FROM bank_loan
GROUP BY
	YEAR(issue_date),
	DATENAME(MONTH,issue_date),
	MONTH(issue_date)
) AS t


--Total Amount Received
SELECT 
	SUM(total_payment) [Total Amount Received] 
FROM bank_loan;

--MTD
SELECT 
	YEAR(issue_date) [Year of Month],
	DATENAME(MONTH,issue_date) [Name Of Month],
	SUM(total_payment) [Total Amount Received]
FROM bank_loan
	GROUP BY
		YEAR(issue_date),
		DATENAME(MONTH,issue_date),
		MONTH(issue_date)
	ORDER BY 
		MONTH(issue_date)

--PREVIOUS MTD OF AMOUNT RECEIVED 
SELECT 
	[Year Of Month],
	[Month Name],
	[Total Amount Received],
	LAG([Total Amount Received],1,NULL) OVER(ORDER BY Mnth) [Previous MTD]
FROM 
(
SELECT 
	YEAR(issue_date) [Year Of Month],
	MONTH(issue_date) [Mnth],
	DATENAME(MONTH,issue_date) [Month Name],
	SUM(total_payment) [Total Amount Received]
FROM bank_loan
GROUP BY
	YEAR(issue_date),
	DATENAME(MONTH,issue_date),
	MONTH(issue_date)
) AS t


--Average Interest Rate

SELECT
	CAST(ROUND(AVG(int_rate)*100,2) AS VARCHAR) + '%' AS Average_Interest_Rate
FROM bank_loan;

--MTD AVERAGE INTEREST RATE
SELECT 
	DATENAME(MONTH,issue_date) [Name of Month],
	ROUND(AVG(int_rate)*100,2) [Average Interest Rate]
FROM bank_loan
	GROUP BY 
		DATENAME(MONTH,issue_date),
		MONTH(issue_date)
	ORDER BY MONTH(issue_date);

--PREVIOUS MTD AVERAGE INTEREST RATE
SELECT
	[Name of Month],
	[Average Interest Rate],
	LAG([Average Interest Rate],1,NULL) OVER(ORDER BY mn) [Previous MTD]
FROM
(
SELECT
	MONTH(issue_date) [mn],
	DATENAME(MONTH,issue_date) [Name of Month],
	ROUND(AVG(int_rate)*100,2) [Average Interest Rate]
FROM bank_loan
	GROUP BY 
		DATENAME(MONTH,issue_date),
		MONTH(issue_date)
) AS t

--Average DTI ratio

SELECT
	ROUND(AVG(dti),2) [Average DTI Ratio]
FROM bank_loan

--Average DTI Ratio MTD
SELECT
	DATENAME(MONTH,issue_date) [Name of Month],
	ROUND(AVG(dti),2) [Average DTI Ratio]
FROM bank_loan
	GROUP BY
		 DATENAME(MONTH,issue_date),
		 MONTH(issue_date)
	ORDER BY 
		MONTH(issue_date);

--Previous MTD DTI Ratio
SELECT
	[Name of Month],
	[Average DTI Ratio],
	LAG([Average DTI Ratio],1,NULL) OVER(ORDER BY mn) [Previous DTI Ratio]
FROM
(
SELECT
	MONTH(issue_date) mn,
	DATENAME(MONTH,issue_date) [Name of Month],
	ROUND(AVG(dti),2) [Average DTI Ratio]
FROM bank_loan
	GROUP BY
		 DATENAME(MONTH,issue_date),
		 MONTH(issue_date)
) AS t

--Good Loan Percentage

SELECT
ROUND(CAST(COUNT(
	CASE 
		WHEN loan_status IN ('Fully Paid','Current') THEN id 
	END) AS FLOAT) / COUNT(id),2)*100 [Good Loan Percentage]
FROM bank_loan				

--Good Loan Applications

SELECT
	COUNT(id) [Good Loan Applications]
FROM bank_loan
	WHERE loan_status IN ('Fully Paid','Current');

--Good Loan Funded Amount
SELECT
	SUM(loan_amount) [Good Loan Funded Amount]
FROM bank_loan
	WHERE loan_status IN ('Fully Paid','Current');

--Good Loan Amount Received
SELECT 
	SUM(total_payment) [Good Loan Amount Received]
FROM bank_loan
	WHERE loan_status IN ('Fully Paid','Current');

--Bad Loan Percentage
SELECT
	ROUND((CAST(COUNT(CASE WHEN loan_status ='Charged Off' THEN id END) AS FLOAT)/COUNT(id))*100,2) [Bad Loan Percentage]
FROM bank_loan;

--Bad Loan Applications
SELECT 
	COUNT(id) [Bad Loan Applications]
FROM bank_loan
	WHERE loan_status='Charged Off';

--Bad Loan Funded Amount
SELECT 
	SUM(loan_amount) [Bad Loan Funded Amount]
FROM bank_loan
	WHERE loan_status='Charged Off'; 

--Bad Loan Amount Received
SELECT 
	SUM(total_payment) [Bad Loan Funded Amount]
FROM bank_loan
	WHERE loan_status='Charged Off'; 

--GRID VIEW
SELECT 
	loan_status,
	COUNT(*) [Count],
	SUM(total_payment) [Total Amount Received],
	SUM(loan_amount) [Total Funded Amount],
	ROUND(AVG(int_rate)*100,2) [Interest Rate],
	ROUND(AVG(dti)*100,2) [DTI]
FROM bank_loan
	GROUP BY loan_status

--loan status, MTD Amount Received, MTD Funded Amount
SELECT
	DATENAME(MONTH,issue_date) [Name of Month],
	loan_status,
	SUM(total_payment) [MTD Amount Received],
	SUM(loan_amount) [MTD Funded Amount]
FROM bank_loan
	GROUP BY DATENAME(MONTH,issue_date), MONTH(issue_date), loan_status
	ORDER BY MONTH(issue_date);

--MONTHLY TRENDS
SELECT 
	DATENAME(MONTH,issue_date) [Name of Month],
	COUNT(id) [Total Loan Application],
	SUM(loan_amount) [Total Funded Amount],
	SUM(total_payment) [Total Received Amount]
FROM bank_loan
	GROUP BY 
		MONTH(issue_date), 
		DATENAME(MONTH,issue_date)
	ORDER BY 
		MONTH(issue_date);

--Regional Analysis by States
SELECT 
	address_state,
	COUNT(id) [Total Loan Application],
	SUM(loan_amount) [Total Funded Amount],
	SUM(total_payment) [Total Received Amount]
FROM bank_loan
	GROUP BY 
		address_state
	ORDER BY 
		address_state;

--Loan Term Analysis
SELECT
	term,
	COUNT(id) [Total Loan Applications],
	SUM(loan_amount) [Total Funded Amount],
	SUM(total_payment) [Total Amount Received]
FROM bank_loan
	GROUP BY 
		term
	ORDER BY term;

--Employee Length Analysis
SELECT
	emp_length,
	COUNT(id) [Total Loan Applications],
	SUM(loan_amount) [Total Funded Amount],
	SUM(total_payment) [Total Amount Received]
FROM bank_loan
	GROUP BY 
		emp_length
	ORDER BY 
		emp_length;

--Loan Purpose Breakdown
SELECT
	purpose,
	COUNT(id) [Total Loan Applications],
	SUM(loan_amount) [Total Funded Amount],
	SUM(total_payment) [Total Amount Received]
FROM bank_loan
	GROUP BY 
		purpose
	ORDER BY 
		[Total Loan Applications] DESC;

--Home Ownership Analysis
SELECT
	home_ownership,
	COUNT(id) [Total Loan Applications],
	SUM(loan_amount) [Total Funded Amount],
	SUM(total_payment) [Total Amount Received]
FROM bank_loan
	GROUP BY 
		home_ownership
	ORDER BY 
		[Total Loan Applications] DESC;


