-- Monday coffee -- Data Analysis

select * from city;
select * from products;
select * from customers;
select * from sales;

-- Reports & Data Analysis --

-- Q1. Coffee Consumers Count --
-- How many people in each city are estimated to consume coffee, given that 25% of the population does? --

select 
city_name,
round(
(population * 0.25)/1000000,
2) as coffee_consumers_in_millions,
city_rank
from city
order by 2 desc

-- Q2. Total revenue from coffee sales --
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023? --

Select 
   ci.city_name,
   sum(s.total) as total_revenue
from sales as s
join customers as c
on s.customer_id = c.customer_id
join city as ci
on ci.city_id = c.city_id
where
    extract(year from s.sale_date) = 2023
	and
	extract(quarter from s.sale_date) = 4
	group by 1
	order by 2 desc

-- Q3. Sales count for each product --
-- How many units of each coffee product have been sold?--

select 
  p.product_name,
  count(s.sale_id) as total_orders
from products as p
left join 
sales as s
on s.product_id = p.product_id
group by 1
order by 2 desc

-- Q4. Average sales amount per city --
-- What is the average sales amount per customer in each city?--

Select 
   ci.city_name,
   sum(s.total) as total_revenue,
   count(distinct s.customer_id) as total_cx,
   ROUND(
   sum(s.total)::numeric/
               count(distinct s.customer_id)::numeric
			   ,2) as avg_sale_per_cx
from sales as s
join customers as c
on s.customer_id = c.customer_id
join city as ci
on ci.city_id = c.city_id
group by 1
order by 2 

-- Q5. City population and coffee consumers --
-- Provide a list of cities along with their population and estimated coffee consumers?--

with city_table as
(select 
  city_name,
  round((population * 0.25)/1000000, 2) as coffee_consumers
from city
),
customers_table 
as
(select
   ci.city_name,
   count(distinct c.customer_id) as unique_cx
from sales as s
join customers as c
on c.customer_id = s.customer_id
join city as ci
on ci.city_id = c.city_id
group by 1
)
select 
  customers_table.city_name,
  city_table.coffee_consumers as coffee_consumer_in_millions,
  customers_table.unique_cx
  from city_table 
  join
  customers_table 
  on city_table.city_name = customers_table.city_name

-- Q6. Top selling products by city --
-- What are the top 3 selling products in each city based on sales volume?--

select * from --table
(select 
  ci.city_name,
  p.product_name,
  count(s.sale_id) as total_orders,
  dense_rank() over(partition by  ci.city_name order by count(s.sale_id) desc) as rank
from sales as s
join products as p
on s.product_id = p.product_id
join customers as c
on c.customer_id = s.customer_id
join city as ci
on ci.city_id = c.city_id
group by 1, 2) as t1
where rank <=3

-- Q7. Customer segmentation by city --
-- How many unique customers are there in each city who have purchased coffee products?--

select 
   ci.city_name,
   count (distinct c.customer_id) as unique_cx
from city as ci
left join
customers as c
on c.city_id = ci.city_id
join sales as s
on s.customer_id = c.customer_id
where 
  s.product_id in (1,2,3,4,5,6,7,8,9,10,11,12,13,14)
  group by 1

--Q8. Average sale Vs rent --
-- Find each city and their average sale per customer and average rent per customer?--

with city_table
as
(
   Select 
   ci.city_name,
   count(distinct s.customer_id) as total_cx,
   ROUND(
   sum(s.total)::numeric/
               count(distinct s.customer_id)::numeric
			   ,2) as avg_sale_per_cx
			   
from sales as s
join customers as c
on s.customer_id = c.customer_id
join city as ci
on ci.city_id = c.city_id
group by 1
order by 2 
),
city_rent
as
(select city_name,
       estimated_rent
	   from city
)
select
   cr.city_name,
   cr.estimated_rent,
   ct.total_cx,
   ct.avg_sale_per_cx,
   round(
   cr.estimated_rent::numeric/ ct.total_cx::numeric
   , 2) as avg_rent_per_cx
   from city_rent as cr
   join city_table as ct
   on cr.city_name = ct.city_name
   order by 4 desc

-- Q9. Monthly sales growth --
-- Sales growth rate : calculate the % growth (or decline) in sales over different time periods (monthly) by each city.--

with
monthly_sales
as
(
select 
   ci.city_name,
   extract(month from sale_date) as month,
    extract(year from sale_date) as year,
	sum(s.total) as total_sale
from sales as s
join customers as c
on c.customer_id = s.customer_id
join city as ci
on ci.city_id = c.city_id
group by 1,2,3
order by 1, 3, 2
),
growth_ratio
as
(
select
   city_name,
   month,
   year,
   total_sale as cr_month_sale,
   lag(total_sale, 1) over(partition by city_name order by year, month) as last_month_sale
from monthly_sales
)
select
  city_name,
  month,
  year,
  cr_month_sale,
  last_month_sale,
  round((cr_month_sale-last_month_sale)::numeric/last_month_sale::numeric * 100
  , 2
  ) as growth_ratio

  from growth_ratio
where 
last_month_sale is not null

-- Q10. Market potential Analysis --
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumers.--

with city_table
as
(
   Select 
   ci.city_name,
   sum(s.total) as total_revenue,
   count(distinct s.customer_id) as total_cx,
   ROUND(
   sum(s.total)::numeric/
               count(distinct s.customer_id)::numeric
			   ,2) as avg_sale_per_cx
			   
from sales as s
join customers as c
on s.customer_id = c.customer_id
join city as ci
on ci.city_id = c.city_id
group by 1
order by 2 
),
city_rent
as
(
select city_name,
       estimated_rent,
	   round((population * 0.25)/1000000, 3) as estimated_coffee_consumer_in_millions
	   from city
)
select
   cr.city_name,
   total_revenue,
   cr.estimated_rent as total_rent,
   ct.total_cx,
   estimated_coffee_consumer_in_millions,
   ct.avg_sale_per_cx,
   round(
   cr.estimated_rent::numeric/ ct.total_cx::numeric
   , 2) as avg_rent_per_cx
   from city_rent as cr
   join city_table as ct
   on cr.city_name = ct.city_name
   order by 2 desc

/*
-- Recomendation
city 1: Pune
1. Avg Rent per customer is very less
2. Highest total revenue
3. Avg_sale per cx is also high

City 2 : Delhi
1. Highest estimated coffee consumer which is 7.7 M
2. Highest total cx which is 68
3. Avg rent per cx is 330 (still under 500)

City 3 : Jaipur
1. Highest cx numbers
2. Avg rent per cx is very less - 156
3. Avg sale per cx is better which at 11.6k




