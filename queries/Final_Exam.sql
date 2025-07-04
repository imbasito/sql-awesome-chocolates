#Final SQL Exam — 12 Questions

#Q1: Show all products with revenue above the average revenue across all products.
#Include columns: Product, Total_Revenue, Average_Revenue, Performance (Above / Below)

select pr.Product,
	s.Amount Total_Revenue,
    (select Avg(amount) from sales) as Avg_Revenue,
    Case
	when s.Amount > (select Avg(amount) from sales) Then "Above"
    Else "Below"
	end as Performance
from sales s
JOIN products pr on s.PID = pr.PID
order by s.Amount desc
limit 10;

#--------------------------------------------------------------------------
#Q2: For each region, show the total revenue and average sale amount
#only where the region has more than ₹2 million in sales.
#Include: Region, Total_Revenue, Average_Amount


select g.Region,
	sum(s.amount) as Total_Revenue,
    (select avg(amount) from sales) as Avg_Sale
from sales s
    JOIN geo g on s.GeoID = g.GeoID
    group by Region
    having sum(s.Amount) > 2000000
    order by Total_Revenue desc;

/*--------------------------------------------------------------------------
Q3: Show the top 3 products by total revenue within each category.
Use RANK() and PARTITION BY Category. Include: Category, Product, Revenue, Rank*/

select * from(
select 
	rank() over (partition by sub.Category	order by sub.sales desc) as Ranks,
    sub.Product,
    sub.Category,
    sub.Sales
from( select 
    pr.Product,
    pr.Category,
    sum(s.Amount) as Sales
    from sales s
    JOIN products pr on s.PID = pr.PID
    group by pr.Category, pr.Product
	) as sub
order by sub.category, sub.sales desc
) as Top3

where Ranks <= 3;

/*Q4:Find the first sale date for each product using ROW_NUMBER() and filter only Rank = 1.
Include: Product, SaleDate, Amount, FirstSaleRank*/

select * from (
	select row_number() over (partition by pr.Product order by s.SaleDate) as Nos,
		date_format(s.saleDate, '%D %Y %M') as Date,
		pr.Product,
		s.Amount as Revenue
	from sales s
	JOIN products pr on s.PID = pr.PID
	order by pr.Product ) as sub

where sub.Nos = 1
order by Revenue desc;

#Q5: For each sale, show the previous sale amount chronologically using LAG().
#Include: SaleID, SaleDate, Amount, Previous_Amount, Difference

select s.SPID as ID,
	date_format(s.SaleDate, '%D %M %Y') as Date,
    s.Amount as Revenue,
    Lag(s.Amount) over (order by s.Amount) as Previous_Revenue,
    s.Amount - Lag(s.Amount) over (order by s.Amount) as Difference
    from sales s
    order by s.SaleDate;

# Q6: Find all salespeople who haven’t made any sales.
# Include: Salesperson, Team, Location
	select p.Salesperson,
		p.Team,
        p.Location,
		s.Amount,
        pr.Product
	from people p
    LEFT JOIn sales s on p.SPID = s.SPID
    left JOIN products pr on s.PID = pr.PID	#to see which products have never been sold.
    where s.Amount is null or s.Amount = 0
	order by p.Salesperson;


#Q7: Show each salesperson’s highest sale ever using a subquery with RANK().
#Include: Salesperson, Amount, Rank, only Rank = 1

select * from(
	select 
      p.Salesperson,
    s.Amount as Revenue,
    rank() over (partition by p.salesperson order by s.Amount desc) as Ranks  
    from sales s
    JOIN people p on s.SPID = p.SPID
    order by Salesperson) as sub
where ranks = 1;
    
#Q8: List all products that have never been sold.
#Include: Product, Category

select pr.Product,
	pr.Category,
    s.Amount as Revenue
    from products pr
    LEFT JOIN sales s on pr.PID = s.PID
    where s.PID is Null
    order by pr.Product;
    
#Q9: Find monthly revenue trend for 2021, and show the Revenue,
# Previous_Month_Revenue, and the Difference.
#Use: SUM(Amount) grouped by month, use LAG()

select Date,
	Revenue,
	lag(revenue) over (order by date) as Prev_Month_Revenue,
    sum(Revenue) - lag(revenue) over (order by date) as Difference
from (
	select date_format(Saledate, '%y-%M') as Date,
		sum(Amount) as Revenue
		from sales
        group by date_format(SaleDate, '%y-%M')
        ) as montly_revenue
group by date;

# Q10: Show each region's total number of orders, total boxes sold, and total revenue.
# Use JOINs between sales and geo. 


select g.Region,
	count(s.GeoID) as Orders,
    sum(s.boxes) as Boxes,
    sum(s.Amount) as Revenue
    from sales s
    JOIN geo g on s.GeoID = g.GeoID
    group by g.Region
    order by Revenue desc;

#Q11: Show all unique combinations of Region and Product that have been sold.
#Include: Region, Product, Amount
#Use DISTINCT

select distinct 
	g.Region,
	pr.Product,
    s.Amount as Amount
    from sales s 
    join products pr on s.PID = pr.PID
    Join geo g on s.GeoID = g.GeoID
    where s.Amount > 0
    order by g.Region, pr.Product;

#Q12: Bonus – Show top-performing products (revenue > ₹1M) 
#and their profit (Revenue - Cost).
#Include: Product, Revenue, Total_Cost, Profit

select pr.Product,
	round(sum(pr.Cost_per_box * s.boxes),2) as Total_Cost,
    sum(s.Amount) as Revenue,
    round(sum(s.Amount) - sum(pr.Cost_per_box* s.Boxes),2) as Profit
    from sales s
    JOIN products pr on s.PID = pr.PID
    group by pr.Product
    having Revenue > 1000000
    order by Revenue;































































