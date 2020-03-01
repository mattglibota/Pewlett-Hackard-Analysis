--Number of [titles] retiring
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
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--only the most recent titles
SELECT count(title), title
--INTO most_recent_titles
FROM
	(SELECT *, ROW_NUMBER() OVER 
		(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
	FROM titles_retiring
	) tmp WHERE rn = 1
GROUP BY title 
ORDER BY count desc