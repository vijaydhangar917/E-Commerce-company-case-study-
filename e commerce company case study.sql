create database eccomerce;
use eccomerce;
select * from customers;
select * from orderdetails;
select * from orders;
select *from products;


/* 2.Identify the top 3 cities with the highest number of customers to determine key markets 
    for targeted marketing and logistic optimization.*/


select location, count(*) as Number_of_customer
from customers
group by location
order by Number_of_customer desc
limit 3;

/*4. Determine how many customers fall into each order frequency 
category based on the number of orders they have placed*/
with customer_orders as (
select customer_id,count(*) as order_count
from orders
group by customer_id)

select order_count as numberoforders,
count(*) as customercount
from customer_orders
group by numberoforders
order by customercount desc;

/* 7. Identify products where the average purchase quantity per order is 2 but
 with a high total revenue, suggesting premium product trends.*/
select product_id,avg(quantity) as AvgQuantity, 
sum(price_per_unit*quantity) as totalRevanue
from orderdetails
group by product_id
having AvgQuantity =2;

/*9. For each product category, calculate the unique number of customers purchasing from it.
 This will help understand which categories have wider appeal across the customer base.*/
 
 select p.category,count(distinct customer_id) as unique_customers
 from products p 
 join orderdetails od
 on p.product_id=od.product_id
 join orders o 
 on od.order_id=o.order_id
 group by category
 order by unique_customers desc;

/*11.Analyze the month-on-month percentage change in total sales to identify growth trends.*/

with cte1 as 
(select date_format(order_date,"%Y-%m") as month,
sum(total_amount) as TotalSales
from orders
group by month),
cte2 as (
select*,
lag(TotalSales) over(order by month) as privious_month_sale
from cte1)
select month,TotalSales,round(
((TotalSales-privious_month_sale)/privious_month_sale)*100,2) as percentChange
from cte2;

/*14.Examine how the average order value changes month-on-month. Insights can guide pricing and
 promotional strategies to enhance order value.*/
 
with cte1 as( select date_format(order_date,"%Y-%m") as month,
 round(avg(total_amount),2) as AvgOrderValue
 from orders
 group by month),
 cte2 as (select *,
 lag(AvgOrderValue) over(order by  month) as privious_month_sale
 from cte1)
select month,AvgOrderValue,round(
(avgordervalue-privious_month_sale),2) as ChangeInValue
from cte2
order by changeinvalue desc;

/* 16.Based on sales data, identify products with the fastest turnover rates,
 suggesting high demand and the need for frequent restocking.*/
 
 select product_id,count(*) as SalesFrequency
 from orderdetails
 group by product_id
 order by salesFrequency desc
 limit 5;
 
 /*18. List products purchased by less than 40% of the customer base, indicating 
 potential mismatches between inventory and customer interest.*/
 
 select p.product_id ,p.name,count(distinct o.customer_id) as UniqueCustomerCount
 from products p 
 join orderdetails od
 on p.product_id = od.product_id
 join orders o 
 on o.order_id= od.order_id
 group by p.product_id,p.name
 having UniqueCustomerCount< (select count(*) *0.40 from customers);


 /*21. Evaluate the month-on-month growth rate in the customer base to understand
 the effectiveness of marketing campaigns and market expansion efforts.*/
 
 with first_purchase as(
 select customer_id, min(order_date) as first_Order_date
 from orders
 group by customer_id)
 
 select date_format(first_order_date,"%Y-%m") as FirstPurchaseMonth,
 count(customer_id) as TotalNewCustomer
 from First_purchase
 group by FirstPurchaseMonth
 order by FirstPurchaseMonth;
 
 /*23. Identify the months with the highest sales volume, aiding in planning for 
 stock levels, marketing efforts, and staffing in anticipation of peak demand periods.*/
 
 select date_format(order_date,"%Y-%m") as Month,
 sum(total_amount) as TotalSales
 from orders
 group by Month
 order by TotalSales desc
 limit 3;
 
 
