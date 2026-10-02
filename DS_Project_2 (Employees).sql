
--1. Employee Table: Check for NULL values, duplicates, and inconsistent data types.
-- Check for NULL values
SELECT * FROM employees.employee WHERE first_name IS NULL;

-- No NULL Values

-- Check for duplicates
SELECT id, COUNT(*)
FROM employees.employee
GROUP BY id
HAVING COUNT(*) > 1;

-- No duplicates

--2. Department Employee Table: Verify foreign key relationships and check for duplicates.
-- Verify foreign key relationships
SELECT * FROM employees.department_employee
WHERE employee_id NOT IN (SELECT id FROM employees.employee) LIMIT 100;

-- Check for duplicates
SELECT employee_id, department_id, COUNT(*)
FROM employees.department_employee
GROUP BY employee_id, department_id
HAVING COUNT(*) > 1;

-- No duplicates

--3.Department Table: Check for NULL values, duplicates, and inconsistent data types.

-- Check for NULL values
SELECT * FROM employees.department WHERE dept_name IS NULL;
-- No NULL Values

-- Check for duplicates
SELECT dept_name, COUNT(*)
FROM employees.department
GROUP BY dept_name
HAVING COUNT(*) > 1;
-- No duplicates

--4.Department Manager Table:Verify foreign key relationships and check for duplicates.

-- Verify foreign key relationships
SELECT * FROM employees.department_manager
WHERE employee_id NOT IN (SELECT id FROM employees.employee)
   OR department_id NOT IN (SELECT id FROM employees.department);

-- Check for duplicates
SELECT employee_id, department_id, COUNT(*)
FROM employees.department_manager
GROUP BY employee_id, department_id
HAVING COUNT(*) > 1;
-- No duplicates

--5.Salary Table: Check for NULL values, duplicates, and inconsistent data types.

-- Check for NULL values
SELECT * FROM employees.salary WHERE amount IS NULL;
--No NULL Values

-- Check for duplicates
SELECT employee_id, amount, COUNT(*)
FROM employees.salary
GROUP BY employee_id, amount
HAVING COUNT(*) > 1;

--6.Title Table: Check for NULL values, duplicates, and inconsistent data types.

-- Check for NULL values
SELECT * FROM employees.title WHERE title IS NULL;
--No NULL Values

-- Check for duplicates

SELECT * FROM employees.title WHERE employee_id IN (SELECT employee_id
FROM employees.title
GROUP BY employee_id, title
HAVING COUNT(*) > 1);


--7.Check for Employee Join Date: Ensure that employees have valid join dates.

-- Check for NULL join dates
SELECT * FROM employees.employee WHERE hire_date IS NULL;
-- No NULL Values

-- Check for join dates in the future
SELECT * FROM employees.employee WHERE hire_date > CURRENT_DATE;
-- No join dates in the future

--8.Check for Department Manager Overlaps: Ensure that there are no overlaps in the periods when a manager is assigned to a department.

SELECT employee_id, department_id, from_date, to_date, COUNT(*)
FROM employees.department_manager
GROUP BY employee_id, department_id, from_date, to_date
HAVING COUNT(*) > 1;
-- No overlaps

--9.Check for Inactive Employees:Identify employees who have left the company.

SELECT * FROM employees.department_manager WHERE to_date IS NULL;


-- Question 2.
-- Which department has the highest average salary of active employees ? Give some plots to show the avg salary department-wise.

WITH ActiveEmployees AS (
    SELECT e.id, de.department_id, s.amount,d.dept_name
    FROM employees.employee e
    LEFT JOIN employees.department_employee de ON e.id = de.employee_id
    LEFT JOIN employees.salary s ON e.id = s.employee_id
	LEFT JOIN employees.department d ON d.id = de.department_id
	WHERE s.to_date = '9999-01-01' AND de.to_date = '9999-01-01'
)
SELECT ae.department_id,ae.dept_name, AVG(ae.amount) AS avg_salary
FROM ActiveEmployees ae
GROUP BY ae.department_id,ae.dept_name
ORDER BY avg_salary DESC;

-- Question 3.
-- Which title has the highest avg salary? Give some plots to show the avg salary title-wise.

WITH ActiveEmployees AS (
    SELECT e.id, ti.title, s.amount
    FROM employees.employee e
    LEFT JOIN employees.title ti ON e.id = ti.employee_id
    LEFT JOIN employees.salary s ON e.id = s.employee_id
	WHERE s.to_date = '9999-01-01' AND ti.to_date = '9999-01-01'
)
SELECT ae.title, AVG(ae.amount) AS avg_salary
FROM ActiveEmployees ae
GROUP BY ae.title
ORDER BY avg_salary DESC;

-- Question 4.
-- Distribution of salary across titles.
WITH ActiveEmployees AS (
    SELECT e.id, ti.title, s.amount
    FROM employees.employee e
    LEFT JOIN employees.title ti ON e.id = ti.employee_id
    LEFT JOIN employees.salary s ON e.id = s.employee_id
	WHERE s.to_date = '9999-01-01' AND ti.to_date = '9999-01-01'
)
SELECT ae.title, ae.amount AS salary
FROM ActiveEmployees ae;

-- Question 5.
-- Distribution of salary across departments.
WITH ActiveEmployees AS (
    SELECT e.id, de.department_id, s.amount
    FROM employees.employee e
    LEFT JOIN employees.department_employee de ON e.id = de.employee_id
    LEFT JOIN employees.salary s ON e.id = s.employee_id
	WHERE s.to_date = '9999-01-01' AND de.to_date = '9999-01-01'
)
SELECT ae.department_id, ae.amount AS salary
FROM ActiveEmployees ae;

-- Question 6.
-- How many active managers in each department. Is there any department with no manager?

CREATE TEMPORARY TABLE ActiveManagers AS (
    SELECT dm.employee_id, dm.department_id, d.dept_name
    FROM employees.department_manager dm
    JOIN employees.department d ON dm.department_id = d.id
    JOIN employees.employee e ON dm.employee_id = e.id
    WHERE dm.to_date = '9999-01-01'
);

SELECT am.department_id, am.dept_name, COUNT(am.employee_id) AS manager_count
FROM ActiveManagers am
GROUP BY am.department_id, am.dept_name;

SELECT d.id AS department_id, d.dept_name
FROM employees.department d
WHERE d.id NOT IN (SELECT DISTINCT department_id FROM ActiveManagers);

-- Question 7.
-- Composition of titles department-wise. Appropriate plots.
WITH ActiveTitles AS (
    SELECT ti.title, de.department_id, d.dept_name
    FROM employees.title ti
    JOIN employees.department_employee de ON ti.employee_id = de.employee_id
    JOIN employees.department d ON de.department_id = d.id
    JOIN employees.employee e ON ti.employee_id = e.id
	WHERE de.to_date = '9999-01-01' AND ti.to_date = '9999-01-01'
)
SELECT at.department_id, at.dept_name, at.title, COUNT(at.title) AS title_count
FROM ActiveTitles at
GROUP BY at.department_id, at.dept_name, at.title;

-- Question 8.
-- Composition of departments title-wise. Appropriate plots.
WITH ActiveTitles AS (
    SELECT ti.title, de.department_id, d.dept_name
    FROM employees.title ti
    JOIN employees.department_employee de ON ti.employee_id = de.employee_id
    JOIN employees.department d ON de.department_id = d.id
    JOIN employees.employee e ON ti.employee_id = e.id
	WHERE de.to_date = '9999-01-01' AND ti.to_date = '9999-01-01'
)
SELECT at.title, at.department_id, at.dept_name, COUNT(at.title) AS title_count
FROM ActiveTitles at
GROUP BY at.title, at.department_id, at.dept_name;

-- Question 9.
-- Salaries of active department managers. Which department's manager who is active earns the most?

WITH ActiveManagers AS (
    SELECT dm.employee_id, dm.department_id, s.amount, d.dept_name
    FROM employees.department_manager dm
    JOIN employees.salary s ON dm.employee_id = s.employee_id
    JOIN employees.department d ON dm.department_id = d.id
    JOIN employees.employee e ON dm.employee_id = e.id
    WHERE s.to_date = '9999-01-01'
)
SELECT am.department_id, am.dept_name, am.amount AS salary
FROM ActiveManagers am
ORDER BY am.amount DESC
LIMIT 1;

-- Question 10.
-- What are the titles of active department managers? Are they managers only?

WITH ActiveManagers AS (
    SELECT dm.employee_id, ti.title
    FROM employees.department_manager dm
    JOIN employees.title ti ON dm.employee_id = ti.employee_id
    JOIN employees.employee e ON dm.employee_id = e.id
    WHERE dm.to_date = '9999-01-01'
)
SELECT DISTINCT am.title
FROM ActiveManagers am;

-- Question 11.
-- Past history of salaries of managers across department (yearly)

WITH ManagerSalaries AS (
    SELECT dm.employee_id, dm.department_id, s.amount, s.from_date
    FROM employees.department_manager dm
    JOIN employees.salary s ON dm.employee_id = s.employee_id
    JOIN employees.employee e ON dm.employee_id = e.id
    WHERE dm.to_date = '9999-01-01'
)
SELECT ms.department_id, d.dept_name, EXTRACT(YEAR FROM ms.from_date) AS year, SUM(ms.amount) AS avg_salary
FROM ManagerSalaries ms
JOIN employees.department d ON ms.department_id = d.id
GROUP BY ms.department_id, d.dept_name, year
ORDER BY ms.department_id, year;

-- Question 12.
-- Distribution of salaries of active employees working for more than 10 years vs 4 years vs 1 year.

WITH ActiveEmployees AS (
    SELECT e.id, s.amount, e.hire_date,de.to_date
    FROM employees.employee e
    LEFT JOIN employees.salary s ON e.id = s.employee_id
	LEFT JOIN employees.department_employee de ON e.id = de.employee_id
	WHERE DATE_PART('year',s.to_date) = 9999 AND ((DATE_PART('year',de.to_date))-(DATE_PART('year',e.hire_date))) <= 60
	
    
)
SELECT count(ae.id) AS count_of_emp,
       CASE
           WHEN (DATE_PART('year',ae.to_date))-(DATE_PART('year',ae.hire_date)) > 10 THEN 'More than 10 years'
           WHEN (DATE_PART('year',ae.to_date))-(DATE_PART('year',ae.hire_date)) > 4 THEN '4 to 10 years'
		   WHEN (DATE_PART('year',ae.to_date))-(DATE_PART('year',ae.hire_date)) > 1 THEN '1 to 4 years'
           ELSE 'New Joiners'
       END AS work_duration
FROM ActiveEmployees ae
GROUP BY work_duration;