--Creating Table

Create Table Retail_Sale(

transactions_id INT Primary Key,
sale_date Date ,
sale_time Time,
customer_id INT,
gender Varchar(15),
age int,
category varchar (50),
quantiy int,
price_per_unit float,
cogs float,
total_sale float


)

---- DATA Cleaning
select count(*) from Retail_Sale
where transactions_id is NULL OR Sale_date is NULL OR sale_time is NULL OR customer_id is NULL
OR gender is NULL OR age is NULL OR category is NULL OR quantiy is null or price_per_unit is NULL 
OR cogs is NULL or total_sale is NULL

delete from retail_sale 
where transactions_id is NULL OR Sale_date is NULL OR sale_time is NULL 
OR gender is NULL OR category is NULL OR quantiy is null 
OR cogs is NULL or total_sale is NULL


---- DATA Exploration
select count(transactions_id) from retail_sale
select count(distinct customer_id) from retail_sale
select count(distinct category) from retail_sale

----- DATA Analysis

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select to_char(sale_date,'YYYY-MM-DD') from retail_sale
select * from retail_sale where sale_date = '2022-11-05'

/*Write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity sold is more than 4 in the month of Nov-2022*/:

select * from retail_sale 
where category = 'Clothing' 
and quantiy >= '4' 
and to_char(sale_date,'YYYY-MM') = '2022-11'

--Write a SQL query to calculate the total sales (total_sale) for each category.:

select category, sum(total_sale) as total_sale, count(*) as total_order_per_category
from retail_sale
group by 1;

-- find the average age of customers who purchased items from the 'Beauty' category:

select round(avg(age),2) as average_customer_age from retail_sale where category='Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000:

select * from retail_sale where total_sale > 1000

/*Write a SQL query to find the total number of 
transactions (transaction_id) made by each gender in each category:*/

select category, gender, count(transactions_id) from retail_sale
group by 1,2 order by 1

--calculate the average sale for each month. Find out best selling month in each year:
select month,year, avg_sale
from 
( select 
extract (year from sale_date) as year,
extract (month from sale_date) as month,
avg(total_sale) as avg_sale,
Rank()Over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
From retail_sale
group by 1,2) as sq1
where rank =1


--find the top 5 customers based on the highest total sales :**
select customer_id, sum(total_sale) as total_sale from retail_sale
Group by 1 order by 2 desc limit 5

-- Find the number of unique customers who purchased items from each category:
select category, count (distinct customer_id) from retail_sale
group by 1


/*Create each shift and number of orders 
(Example Morning <12, Afternoon Between 12 & 17, Evening >17):*/

with shiftwise_sales 
as (
select *, 
Case when extract (hour from sale_time) <12 then 'Morning'
     when extract (hour from sale_time) > 12 and extract (hour from sale_time) < 17 then 'Afternoon'
     when extract (hour from sale_time) > 17 and extract (hour from sale_time) < 19 then 'Evening'
Else 'Night'
End as Shift From retail_sale)

Select Shift, Count(transactions_id) as Count_of_Orders
from shiftwise_sales
group by shift

