# Pewlett Hackard Analysis

### Summary
The purpose of the project is to determine how many retirees there will be and their respective job titles. These counts give us an idea of the positions we will need to fill and train for. We then analyze employees that are eligible for mentorship with matching job titles

Please see the below image for a snapshot of the ERD of the relevant employee information.

![ERD](/EmployeeDB.png)

### Analysis
Based on the summary counts of employees retiring and ones ready for mentorship, there will be a significant deficit of employees to help the company transition through attrition. The company is tens of thousand employee short to cover all positions of retiring employees.

There are 33,118‬ employees retiring and 1,549 employees ready for mentorship. The challenge did not require analysis of employees hired so I do not have a number for that.

I would recommend further analysis to break down retirement exposure by department to determine where hiring managers will have to focus most.

CSVs are located in the Data/Challenge folder. Challenge.sql is located in the Queries folder.

### SQL Code and Snippets

```SQL
--Number of [titles] Retiring
SELECT 
e.emp_no,
e.first_name,
e.last_name,
t.title,
t.from_date,
s.salary
INTO titles_retiring
FROM employees e
INNER JOIN titles t ON e.emp_no = t.emp_no
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (t.to_date = '9999-01-01');
```
![Task1.1](/Task%201.1%20-%20Titles%20Retiring.PNG)

```SQL
--Only Most Recent Titles
SELECT count(title), title
INTO most_recent_titles
FROM
	(SELECT *, ROW_NUMBER() OVER 
		(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
	FROM titles_retiring
	) tmp WHERE rn = 1
GROUP BY title 
ORDER BY count desc
```
![Task1.2](/Task%201.2%20-%20Most%20Recent%20Titles.PNG)

```SQL
-- Who's Ready for a Mentor?
SELECT
e.emp_no,
e.first_name,
e.last_name,
t.title,
t.from_date,
t.to_date
--INTO mentor
FROM
employees e
INNER JOIN titles t ON e.emp_no = t.emp_no
INNER JOIN dept_employee de ON e.emp_no = de.emp_no
WHERE t.to_date = ('9999-01-01')
AND de.to_date = ('9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31');
```
![Task1.3](/Task%201.3%20-%20Ready%20for%20Mentor.PNG)

```SQL
--count mentor titles to check how many matching
SELECT count(title), title
--INTO mentor_titles_count
FROM
	(SELECT *, ROW_NUMBER() OVER 
		(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
	FROM mentor
	) tmp WHERE rn = 1
GROUP BY title 
ORDER BY count desc
```

![Task1.4](/Task1.4-MentorMostRecentTitles.PNG)

### Challenge
