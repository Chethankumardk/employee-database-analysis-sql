# SQL Analysis

This directory contains the PostgreSQL files used for the Employee Database Analysis project.

## Files

### `employee_analysis.sql`

Contains the main data-quality checks and analytical SQL queries.

The analysis uses:

- Common Table Expressions (CTEs)
- `JOIN` and `LEFT JOIN`
- `GROUP BY`
- `ORDER BY`
- aggregate functions
- temporary tables
- date functions
- filtering
- multi-table relational queries

### `employees_schema.sql`

Defines the relational database structure used by the analysis.

The database contains the following main entities:

- employees
- departments
- department-employee relationships
- department managers
- salaries
- job titles

## Data-Quality Checks

The analysis includes checks for:

- NULL values
- duplicate records
- employee/department relationships
- missing department references
- employee hire dates
- department-manager records
- salary records
- title records

## Analytical Questions

The SQL analysis investigates topics including:

- average salary by department
- average salary by job title
- salary distribution across titles
- salary distribution across departments
- active managers by department
- departments without an active manager
- title composition within departments
- department composition by title
- salaries of active department managers
- titles held by active department managers
- historical manager salaries
- employee distribution by employment duration

## Dataset Note

The complete PostgreSQL database dump is intentionally not included in this portfolio repository.

The repository focuses on the database schema and analytical SQL rather than distributing the full source dataset.
