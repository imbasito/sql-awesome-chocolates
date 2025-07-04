#--------------------------------Windows Functions--------------------------------------

select 
	row_number() over (order by s.SPID desc) as S_Rank,
    s.SPID, s.Amount, s.SaleDate
from sales s
Order by S_Rank;

#---------------------------------------------------------------------------------------
# Task: Assign row numbers to each product sale within its category,
# ordered by highest Amount.

select 
	Row_number() over (Partition by pr.Category order by s.Amount desc) as Nos,
    pr.Category,
	pr.Product,
	s.Amount
from sales s
JOIN products pr on s.PID = pr.PID
Order by pr.Category, Nos;

#---------------------------------------------------------------------------------------
#Step 2: RANK()
#Purpose:
#RANK() works like ROW_NUMBER(), but it gives the same rank to tied values,
# and then skips the next rank.
#note: ranks are assigned based on the order by in the rank function.

select Rank() over (partition by pr.Category order by s.Amount desc) as Rank_,
	pr.Category,
    pr.Product,
    s.Amount
from sales s
JOIN products pr on s.PID = pr.PID
order by pr.Category, Rank_;
#check rank_ 26 and above
#---------------------------------------------------------------------------------------

select dense_rank() over (partition by pr.Category order by s.Amount desc) as Rank_,
	pr.Category,
    pr.Product,
    s.Amount
from sales s
JOIN products pr on s.PID = pr.PID
order by pr.Category, Rank_;
#check rank_ 26 and above

#---------------------------------------------------------------------------------------
#Task: Compare each sale with the previous one using LAG()

select date_format(s.SaleDate, '%M %Y') as Date,
	s.Amount,
    lag(s.Amount) over (order by s.Amount desc) as Previous_Amount,
    s.Amount - lag(s.Amount) over (order by s.Amount desc) as Difference
from sales s
order by s.Amount desc
limit 10;

#---------------------------------------------------------------------------------------
#Task: Compare Each Sale With the Next Sale

select date_format(s.SaleDate, '%Y %M') as Date,
	s.Amount as Current_Revenue,
    Lead(s.Amount) over (order by s.SaleDate) as Predicted_Revenue,
    s.Amount - Lead(s.Amount) over (order by s.SaleDate) as Difference
from sales s
order by s.SaleDate
limit 20;

#--------------------------------------Window Functions---------------------------------
#Task 1: Assign unique row numbers to each sale, sorted by Amount (highest first)

select
	row_number() over (order by s.Amount desc) as Nos,
	s.Amount as Revenue
from sales s
order by Nos;

#---------------------------------------------------------------------------------------
#Task 2: Rank products by total revenue within each Category (use RANK() + PARTITION BY)

select 
	
    rank() over (partition by pr.Category order by sum(s.Amount)) as Ranks,
    pr.Category,
    pr.Product as Product_name,
    sum(s.Amount) as Revenue    
from sales s 
JOIN products pr on s.PID = pr.PID
group by pr.category, pr.Product
order by pr.Category, Ranks;

#---------------------------------------------------------------------------------------
#Task 3: Use DENSE_RANK() to rank sales by amount within each Region

select dense_rank() over (order by sum(s.Amount)) as Ranks,
	g.Region as Region,
    sum(s.Amount) as Sales
from geo g
JOIN sales s on g.GeoID = s.GeoID
group by Region
order by Ranks;

#--------------------------------------------------------------------------
#Task 4: Compare each sale to the previous one using LAG() (chronologically)

select 
	date_format(s.SaleDate, '%Y %M') as Date,
	s.Amount as Current_Sale,
	lag(s.Amount) over (order by s.SaleDate desc) as Previous_Sale
from sales s
order by date_format(s.SaleDate, '%Y %M') desc;

#--------------------------------------------------------------------------
#Task 5: Compare each sale to the next one using LEAD()

select s.Amount as c_sale,
	lead(s.Amount) over (order by s.Amount desc) as Prev_sale
from sales s
order by c_sale desc;

#--------------------------------------------------------------------------
#Task 6: Show the first sale (rank = 1) for each product 
# using ROW_NUMBER() + PARTITION BY

select 
	row_number() over (partition by pr.Product order by s.Amount desc) as Nos,
      pr.Product, 
   s.Amount as Sale
from sales s
JOIN products pr on s.PID = pr.PID
order by pr.Product;

#--------------------------------------------------------------------------
#Task 7: Calculate cumulative revenue per Region (bonus)

select date_format(s.saleDate, '%Y %M') as Date,
	g.Region as Region,
	sum(s.Amount) over (partition by g.Region order by s.SaleDate) as Cumulative_Sale
from sales s
join geo g on s.GeoID = g.GeoID
order by g.Region;

#--------------------------------Sub query---------------------------------
#Subquery in WHERE clause
#🔎 Filter data using a condition that comes from another query.

select Amount from sales
where Amount < (select avg(amount) from sales);


#--------------------------------------------------------------------------
#Subquery in FROM clause
#📊 Create a temporary table from another query.

select 
	Category, Max(Total_Revenue)
		from (select pr.Category,
				sum(s.Amount) as Total_Revenue
		from sales s
		JOIN products pr on s.PID = pr.PID
		group by pr.Category) as sub
	group by Category;
    #note: this is just for understanding, the output is not worth it here
    #the inner answer and the whole query answer is the same.


#--------------------------------------------------------------------------
# Subquery in the WHERE Clause
# “Show me all sales above average value.”

select Amount
from sales
where Amount > (select avg(amount) from sales)
order by Amount desc;

#--------------------------------------------------------------------------
#Task 2: Show salespeople who have made at least one above-average sale.

select p.Salesperson,
	s.Amount
from sales s
JOIN people p on s.SPID = p.SPID
where s.Amount >= (select avg(Amount) from sales)
order by s.Amount;

#--------------------------------------------------------------------------
#Task 3: Rank sales by Amount for each Salesperson using a Subquery + RANK()
#🎯 Show each salesperson's sales with their rank among their own sales.

select rank() over (partition by sub.Salesperson order by sub.Sales desc) as Rank_,
	sub.Salesperson,
	sub.Sales
from (select p.Salesperson,
	s.Amount as Sales
    from sales s
    join people p on s.SPID = p.SPID
    ) as sub
order by sub.Salesperson, sub.Sales desc;

#--------------------------------------------------------------------------
#Task 4: Rank sales by Amount for each Salesperson using a Subquery + RANK()
# Top 1 of every Salesperson

# the inside query is the same from the previous tasks, the new outer query
# filter via the where clause to only top 1 sale of salesperson.

select * from (

	select rank() over (partition by sub.Salesperson order by sub.Sales desc) as Rank_,
		sub.Salesperson,
		sub.Sales
	from (select p.Salesperson,
		s.Amount as Sales
		from sales s
		join people p on s.SPID = p.SPID
		) as sub
	order by sub.Salesperson, sub.Sales desc
    ) as Ranku
    
where Rank_ = 1;

#--------------------------------------------------------------------------
#Task: Use a Subquery in the SELECT Clause
#🎯 Use Case:
#“Show each product's name, total revenue, and the average revenue across all products next to it.”
#This allows you to compare each product’s performance to the overall average — a great KPI view.

select pr.Product as Product_Name,
	sum(s.Amount) as Total_Revenue,
	(select avg(Amount) from sales) as Avg_Revenue_All
    from sales s 
    join products pr on s.PID = pr.PID
    group by pr.Product
    order by Total_Revenue desc
#This is used for comparison with average to see which product revenue beats the average.


