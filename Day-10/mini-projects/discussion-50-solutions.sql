-- Mastering SQL: A Comprehensive Exercise on Grouping, Filtering, and Analyzing Data in MySQL
-- Part 1: Basic Grouping and Aggregation in classicmodels
    -- Task-1.1: Product Performance Analysis: Generate a report showing the total sales per product line. Include the product line, the total number of products sold, and the total sales amount.
        select productLine,count(quantityOrdered) as no_of_products_sold,sum(quantityOrdered*priceEach) as total_sales_amount from orderdetails join products using(productCode) group by productLine;

    -- Task-1.2: Office Sales Analysis: Determine the total sales for each office, including office city, number of orders processed, and total sales amount.
        select o.officeCode, o.city as officeCity,count(od.orderNumber) as no_of_orders_processed, sum(od.quantityOrdered*od.priceEach) as total_sales from offices o join employees e using(officeCode) join customers c on e.employeeNumber=c.salesRepEmployeeNumber join orders ods using(customerNumber) join orderdetails od using(orderNumber) group by o.officeCode order by o.officeCode;

    -- Task-1.3: Total Quantity Sold by Product Line: Determine the total quantity sold for each product line.
        select productLine,sum(quantityOrdered) as total_quantity_sold from orderdetails join products using(productCode) group by productLine;


-- Part 2: Advanced Grouping and Filtering with HAVING in classicmodels
    -- Task-2.1: Average Sale Amount by Product Line with Filtering: Find product lines with an average sale amount above a specified threshold.
        select productLine,avg(quantityOrdered*priceEach) as average_sale_amount from orderdetails join products using(productCode) group by productLine having avg(quantityOrdered*priceEach)<3000;

    -- Task-2.2: High-Value Order Analysis: Identify offices with an average order value greater than a certain threshold. Include office city, average order value, and total number of orders.
        select o.city as officeCity, avg(od.quantityOrdered*od.priceEach) as average_order_value,count(od.orderNumber) as no_of_orders from offices o join employees e using(officeCode) join customers c on e.employeeNumber=c.salesRepEmployeeNumber join orders ods using(customerNumber) join orderdetails od using(orderNumber) group by o.city having avg(od.quantityOrdered*od.priceEach)>2000;

    -- Task-2.3: Product Line Performance Filter: Filter product lines that have an average product sale price above a specific value.
        select productLine, avg(MSRP) as average_productSale_price from products group by productLine having avg(MSRP)>100;


-- Part 3: Complex Aggregations and Grouping in world
    -- Task-3.1: Continent Analysis: For each continent, find the average population and total GDP. Filter out continents with an average population below a certain threshold.
        select continent,avg(population) as average_population,sum(GNP) as total_GDP from country group by continent;
        select continent,avg(population) as average_population from country group by continent having avg(population)<15000000;

    -- Task-3.2: Language Diversity: Identify countries with more than a specific number of official languages and display the country name, number of official languages, and total population.
        select name as countryName, count(IsOfficial='T') as no_of_official_languages, sum(population) as total_population from country join countrylanguage on country.code=countrylanguage.CountryCode group by name having count(IsOfficial='T')>10;


-- Part 4: Advanced Scenario - Time Series Analysis in classicmodels
    -- Task-4.1: Monthly Sales Growth: Calculate the month-over-month sales growth percentage for each product line.
        select p.productLine, extract(year from o.orderDate) as year, extract(month from o.orderDate) as month, sum(od.quantityOrdered*od.priceEach) as sales, (sum(od.quantityOrdered*od.priceEach)-lag(sum(od.quantityOrdered*od.priceEach)) over(order by extract(year from o.orderDate), extract(month from o.orderDate)))/lag(sum(od.quantityOrdered*od.priceEach)) over(order by extract(year from o.orderDate), extract(month from o.orderDate))*100 as growth_percentage from orders o join orderdetails od using(orderNumber) join products p using(productCode) group by p.productLine,extract(year from o.orderDate),extract(month from o.orderDate);
        
    -- Task-4.2: Seasonal Effect Analysis: Identify quarters with significantly higher sales for each office and investigate possible reasons.
        select officeCode, year(orderDate) as year, quarter(orderDate) as quarter, sum(quantityOrdered*priceEach) as sales, (sum(quantityOrdered*priceEach)-lag(sum(quantityOrdered*priceEach)) over (order by officeCode, year(orderDate), quarter(orderDate)))/lag(sum(quantityOrdered*priceEach)) over (order by officeCode, year(orderDate), quarter(orderDate))*100 as growth_percentage from offices o join employees e using(officeCode) join customers c on e.employeeNumber=c.salesRepEmployeeNumber join orders ods using(customerNumber) join orderdetails od using(orderNumber) group by o.officeCode,year(ods.orderDate),quarter(ods.orderDate);