#---------------------Industry - Beginner level-------------------------
#“Give me the 10 highest-value sales we've made.”
select * from sales
order by Amount	desc
limit 10;

#“Show me all sales made by the Mumbai team.”
select s.spid, 
p.salesperson, 
s.amount, 
p.Location from sales s JOIN people p 
on s.spid = p.spid 
where location = 'Hyderabad' 
limit 20;

#“What were our sales in January 2021?”
select * from sales 
where saleDate 
between '2021-01-01' and '2021-01-31' 
limit 20;

#“List all products that cost more than ₹5 per box.”
select * from products 
where Cost_per_box>5;

#“Which products are our top sellers?”
select p.product, 
sum(s.boxes) as Total_Units from sales s JOIN products p 
on s.pid = p.pid 
group by Product 
order by Total_Units desc 
limit 5;

#“How much has each salesperson sold?”
select p.Salesperson, 
sum(s.amount) as Total_Revenue from sales s JOIN people p 
on s.spid = p.spid 
group by salesperson 
order by Total_Revenue desc 
limit 10;

#“Give me monthly sales totals for 2021.”
select date_format(saleDate, '%M, %Y') as Month, sum(amount) as Monthly_Sales from sales 
where year(saleDate) = '2021' 
group by Month with rollup
order by Month;

#“Give me the profit (Revenue - Cost) per product.”
select p.Product, 
round(sum(s.Amount),2) as Revenue,
round(p.Cost_per_box * sum(s.Boxes),2) as Total_cost, 
round(sum(s.Amount) - p.Cost_per_box * sum(s.Boxes),2) as Profit 
from sales s JOIN products p on s.pid = p.pid 
group by p.Product, p.Cost_per_box
order by profit desc;
#-----------------------------------------------------------------------------
 
#Task 9: Which product has the highest average revenue per order?
#Find the product with the highest average Amount per transaction.

select p.product, 
	count(s.amount) as Orders,
    round(avg(s.amount),2) as avg_revenue_per_order
from sales s JOIN products p
on s.pid = p.pid
group by p.product
order by avg_revenue_per_order desc
limit 1;
#-------------------------------------------------------------------------------
#Task 10: Find the region generating the highest total profit
#Join sales, products, and geo. Then calculate total profit per region.





#---------------------------------------------------------------------------
#Task 11: Show monthly profit trend for 2021
#For each month in 2021, calculate the total revenue, total cost, and total profit.
 
select 
	DATE_FORMAT(s.SaleDate,'%Y, %M') as Month_year,
		round(sum(s.Amount),2) as Total_Revenue, 
        round(sum(p.cost_per_box * s.boxes),2) as Total_Cost,
        round(sum(s.amount) - sum(p.cost_per_box * s.boxes),2) as Total_Profit
from sales s 
JOIN products p
on s.pid = p.pid
Where year(s.saleDate) = 2021
group by DATE_FORMAT(s.SaleDate,'%Y, %M') with Rollup
order by min(s.SaleDate);


#-----------------------------------------------------------------------------
#Task 12: Which salesperson generated the highest profit?
#Similar to revenue, but calculate profit instead.

SELECT
  p.Salesperson,
  SUM(s.amount) AS Revenue,
  SUM(s.amount - pr.cost_per_box * s.boxes) AS Profit
FROM sales s
JOIN products pr ON s.PID = pr.PID
JOIN people p ON s.SPID = p.SPID
GROUP BY p.salesperson
ORDER BY profit DESC
LIMIT 1;

#------------------------------------------------------------------
#Task 13: Top 3 most profitable products in each category
#Find top 3 products by profit in each product category (subquery or window function).

select pr.product,
	sum(s.amount - pr.cost_per_box * s.boxes) as Profit
from sales s
JOIN products pr on s.PID = pr.PID
group by pr.product
order by Profit desc
limit 5;

#-----------------------------------------------------------------------
#Task 14: Which products are losing money?
#List any products where total cost > total revenue (negative profit).

select pr.product,
	sum(s.amount - pr.cost_per_box * s.boxes) as Profit
from sales s
JOIN products pr on s.PID = pr.PID
group by pr.product
having profit < 0
order by Profit









