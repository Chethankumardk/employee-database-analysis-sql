# Employee Database Analysis using PostgreSQL

SQL-based analysis of a relational employee database using **PostgreSQL**, with a focus on data-quality validation, workforce structure, salary analysis, departments, job titles, and management records.

## Project Overview

This project demonstrates the use of SQL to explore and analyze a multi-table employee database.

The database contains information about:

- employees
- departments
- department assignments
- department managers
- salaries
- job titles

The analysis combines database validation with business-oriented analytical queries.

## Database Structure

The analysis works across six main relational tables:

```text
employee
   │
   ├── department_employee ── department
   │
   ├── department_manager ─── department
   │
   ├── salary
   │
   └── title
```

The supplied schema defines primary keys, foreign-key relationships, and indexes supporting these relationships.

## Data-Quality Validation

Before the analytical queries, the SQL performs checks for issues such as:

- NULL values
- duplicate records
- invalid employee references
- invalid department references
- missing hire dates
- future hire dates
- department-manager records
- salary records
- job-title records

This provides a basic validation layer before performing the workforce analysis.

## SQL Analysis

The project investigates several employee and organizational questions.

### Salary Analysis

Queries examine:

- average salary by department
- average salary by job title
- salary distribution across titles
- salary distribution across departments
- salaries of active department managers
- historical manager salaries

### Workforce and Department Analysis

Queries also examine:

- active managers by department
- departments without active managers
- title composition within departments
- department composition by job title
- titles held by active department managers
- employee distribution by employment duration

## SQL Techniques Demonstrated

The analysis uses:

- PostgreSQL
- Common Table Expressions (CTEs)
- `JOIN`
- `LEFT JOIN`
- `GROUP BY`
- `ORDER BY`
- aggregate functions
- `CASE`
- temporary tables
- subqueries
- date functions
- filtering
- multi-table relational analysis

## Example — Average Salary by Department

```sql
WITH ActiveEmployees AS (
    SELECT
        e.id,
        de.department_id,
        s.amount,
        d.dept_name
    FROM employees.employee e
    LEFT JOIN employees.department_employee de
        ON e.id = de.employee_id
    LEFT JOIN employees.salary s
        ON e.id = s.employee_id
    LEFT JOIN employees.department d
        ON d.id = de.department_id
    WHERE s.to_date = '9999-01-01'
      AND de.to_date = '9999-01-01'
)
SELECT
    department_id,
    dept_name,
    AVG(amount) AS avg_salary
FROM ActiveEmployees
GROUP BY department_id, dept_name
ORDER BY avg_salary DESC;
```

This query combines employee, department-assignment, salary, and department information to calculate average salaries for active employees by department.

## Repository Structure

```text
employee-database-analysis-sql/
├── README.md
└── sql/
    ├── README.md
    ├── employee_analysis.sql
    └── employees_schema.sql
```

## Dataset and Publication Scope

The original PostgreSQL database dump is not included in this portfolio repository.

The repository instead focuses on the two artifacts most relevant for demonstrating SQL capability:

- the relational database schema
- the analytical SQL queries

This keeps the repository concise while preserving the database structure required to understand the analysis.

## Skills Demonstrated

**SQL · PostgreSQL · Relational Databases · Data Validation · Data Analysis · CTEs · Joins · Aggregation · Data Quality · Workforce Analysis**
