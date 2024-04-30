-- 1. Write a query to display the names (first_name, last_name) using alias name “First Name", "Last Name".
    select e.first_name as 'First Name', e.last_name as 'Last Name' from employees e;

-- 2. Write a query to get unique department ID from employee table.
    select distinct department_id from employees;

-- 3. Write a query to get the names (first_name, last_name), salary, PF of all the employees (PF is calculated as 15% of salary).
    select first_name, last_name,salary,salary*0.15 as 'PF' from employees;

-- 4. Write a query to get the maximum and minimum salary from employees table.
    select max(salary) as maximum_salary, min(salary) as minimum_salary from employees;

-- 5. Write a query to get the average salary and number of employees in the employees table.
    select avg(salary) as average_salary, count(employee_id) as number_of_employees from employees;

-- 6. Write a query get all first name from employees table in upper case.
    select upper(first_name) from employees;

-- 7. Write a query to get the first 3 characters of first name from employees table.
    select substring(first_name,1,3) from employees;

-- 8. Write a query to select first 10 records from a table.
    select * from employees limit 10;

-- 9. Write a query to get monthly salary (round 2 decimal places) of each and every employee.
    select first_name, last_name, round(salary/12,2) as "Monthly Salary" from employees;

-- 10. Write a query to display the name (first_name, last_name) and department ID of all employees in departments 30 or 100 in ascending order.
    select first_name, last_name, department_id from employees where department_id = 30 or department_id=100 order by department_id;