-- Scenario-based Exercises - Views - MySQL #25
-- 1. Scenario 1: Advanced Analytics Dashboard- You're working as a data engineer for Classic Models and your task is to create an advanced analytics dashboard for the sales team. They are interested in a daily report showing the number of orders, total sales, and the most purchased product of each day. This is quite a complex query, so you decide to use views to break down the problem:
    -- Create an inline view to calculate the daily total sales.
        create view daily_total_sales as select date(orderDate) AS order_date, SUM(quantityOrdered * priceEach) AS total_sales from orders join orderdetails using (orderNumber) group by order_date;

    -- Create an updatable view to show the number of orders for each day. Also include a functionality to update the order status in the same view.
        create view daily_orders as select date(orderDate) as order_date, count(orderNumber) as no_of_orders, status from orders group by order_date, status;
        update daily_orders set status='new_status' where order_date='some_date';

    -- Create a view to identify the most purchased product of each day.
        create view daily_top_products as select date(orderDate) as order_date, productCode, sum(quantityOrdered) as total_quantity from orders join orderdetails using(orderNumber) group by order_date, productCode order by total_quantity desc;

    -- Finally, combine these views to produce the required daily report.
        select distinct order_date, total_sales, no_of_orders, (select productCode from daily_top_products where daily_top_products.order_date=daily_total_sales.order_date limit 1) as top_product from daily_total_sales join daily_orders using(order_date) join daily_top_products using(order_date);


-- 2. Scenario 2: Sales Monitoring System- Classic Models has a system to monitor the performance of sales reps. The sales reps' performance is judged based on the number of customers handled, total payments received, and the total number of orders. The details of sales reps are in the employees table and the sales are recorded in the orders and payments tables.
    -- Create a view that shows the total number of customers handled by each sales rep.
        CREATE VIEW rep_customers AS SELECT salesRepEmployeeNumber, COUNT(DISTINCT customerNumber) AS no_of_customers FROM customers GROUP BY salesRepEmployeeNumber;

    -- Create a view that displays the total payments received by each sales rep.
        CREATE VIEW rep_payments AS SELECT salesRepEmployeeNumber, SUM(amount) AS total_payments FROM customers JOIN payments USING (customerNumber) GROUP BY salesRepEmployeeNumber;

    -- Create another view that shows the total number of orders handled by each sales rep.
        CREATE VIEW rep_orders AS SELECT salesRepEmployeeNumber, COUNT(DISTINCT orderNumber) AS no_of_orders FROM customers JOIN orders USING (customerNumber) GROUP BY salesRepEmployeeNumber;

    -- Finally, create a combined view that uses the above views to display the performance of each sales rep.
        create view rep_performance as select salesRepEmployeeNumber, no_of_customers, total_payments, no_of_orders from rep_customers join rep_payments using(salesRepEmployeeNumber) join rep_orders using(salesRepEmployeeNumber);


-- 3. Scenario 3: HR and Sales Data Analysis- Assume the Classic Models has recently acquired a company and you now also have access to the hr database. The management wants to know if there's a relationship between employee's department, age, and their sales performance.
    -- Create a view in the hr database that shows the department and age of each employee.
        CREATE VIEW emp_details AS SELECT employee_id, department_id, TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age FROM employees; -- Ensure that employees table contains birth_date column --

    -- Create a view in the classicmodels database that shows the sales performance of each employee.
        CREATE VIEW emp_sales_performance AS SELECT salesRepEmployeeNumber, SUM(amount) AS total_sales FROM customers JOIN payments USING (customerNumber) GROUP BY salesRepEmployeeNumber;

    -- As MySQL doesn't support cross-database queries in the form of database.schema.table, you may need to combine the data in one database or manually join the exported data from these views in a tool like Python or Excel to analyze the combined data.