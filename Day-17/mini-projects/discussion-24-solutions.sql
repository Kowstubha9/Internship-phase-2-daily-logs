-- Practice Exercise - Views - Types of Views - MySQL #24
-- 1. Updatable View: Create an updatable view that includes customerNumber, customerName, contactLastName, and contactFirstName from the customers table. Then, try to update the contactFirstName for a specific customerNumber.
    create view customer_view as select customerNumber,customerName,contactLastName,contactFirstName from customers;
    update customer_view set contactFirstName="Peter" where customerNumber=121;

-- 2. Read-Only View: Create a read-only view that joins the orderdetails table and the products table on productCode and includes orderNumber, productName, and quantityOrdered. Try to update the quantityOrdered for a specific orderNumber and see what happens.
    create view orderdetails_products_view as select od.orderNumber, p.productName, od.quantityOrdered from orderdetails od join products p on od.productCode=p.productCode;
    update orderdetails_products_view set productName="Lamp" where orderNumber=10101;

-- 3. Inline View: Write a query that uses an inline view to get the total number of orders for each customer. The inline view should select customerNumber and orderNumber from the orders table. The main query should then group by customerNumber.
    select inline_view.customerNumber, count(inline_view.orderNumber) as toatal_no_of_orders from (select customerNumber, orderNumber from orders) as inline_view group by inline_view.customerNumber;

-- 4. Materialized View: Note that MySQL does not natively support materialized views, but you can mimic them with a combination of stored procedures and triggers. The task here would be to create a stored procedure that creates a new table with productName and totalQuantityOrdered (this total should be aggregated from the orderdetails table). Then, create an AFTER INSERT trigger on the orderdetails table that calls this stored procedure to update the table (acting as a materialized view) whenever a new order detail is inserted.
    -- Procedure
    delimiter &
    CREATE PROCEDURE refresh_materialized_view()
    BEGIN
    CREATE TABLE materialized_view AS SELECT p.productName, SUM(od.quantityOrdered) as total_quantity_ordered FROM orderdetails od JOIN products p ON od.productCode = p.productCode GROUP BY p.productName;
    END&
    delimiter ;
    -- Trigger
    CREATE TRIGGER orderdetails_after_insert AFTER INSERT ON orderdetails FOR EACH ROW CALL refresh_materialized_view();