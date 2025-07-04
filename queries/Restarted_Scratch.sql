#🛠️ Practice Task 1:
#Show salesperson, location, and team from the people table.

select Salesperson, Location, Team
from people
limit 10;

#---------------------------------------------------------------------------------
#🛠️ Practice Task 2:
# Get the names and teams of all salespeople in Hyderabad on the Delish team.

select Salesperson, Team
from people
where Location = 'Hyderabad' and Team = 'Delish';

#---------------------------------------------------------------------------------
#🛠️ Practice Task 3:
#List all salespeople in Hyderabad, sorted by their name in descending order.

select Salesperson
from people
where Location = 'Hyderabad'
order by Salesperson asc;

#---------------------------------------------------------------------------------
#Final Step for This Round: LIMIT
#Let’s apply all 4 together.

select Amount
from sales
Where Amount > 10000
order by Amount
limit 10;

#---------------------------------------------------------------------------------
#Show the first 10 transactions where the sale amount is greater than ₹5000.

select Amount
from sales
where Amount > 5000
order by Amount desc
Limit 10;

#---------------------------------------------------------------------------------
#List all salespeople who work in Mumbai.

select salesperson
from people
where Location = 'Mumbai'
order by salesperson asc;

#---------------------------------------------------------------------------------
#Show the top 5 largest sales (by amount) in the sales table.

select Amount
from sales
order by Amount desc
limit 5;

#---------------------------------------------------------------------------------
#List the salespeople who are in Hyderabad and belong to the Delish team.

select Salesperson, Team, Location
from people
where Location = 'Hyderabad' And Team = 'Delish'
order by Salesperson;

#---------------------------------------------------------------------------------
#Show the first 10 sales where:
#Amount is between ₹8000 and ₹12000
#The number of Boxes sold is more than 10

select Amount, boxes
from sales
where Amount between 8000 and 12000 And boxes > 10
order by boxes
limit 10;

#---------------------------------------------------------------------------------
#Find all products that contain the word "Dark" in their name.

select product
from products
where Product like '%Dark%'
order by product;

#---------------------------------------------------------------------------------
#List products where Category is either 'Bars' or 'Bites'.

select Category
from products
where Category in ('Bars' , 'Bites')
order by Category;

#---------------------------------------------------------------------------------
#Find all salespeople without a team assigned.

select Salesperson, Team
from people
where Team = "" or Team is Null
order by Salesperson;

#---------------------------------------------------------------------------------
#List each Team and the number of salespeople in that team.

select Team, 
count(Salesperson) as People
from people
group by Team
order by count(Salesperson);

#---------------------------------------------------------------------------------
#SUM() of sales grouped by region

select g.Region,
sum(s.Amount) as Sales
from sales s
JOIN geo g on s.GeoID = g.GeoID
group by g.region
order by sum(s.Amount);

#---------------------------------------------------------------------------------
#AVG() salary or amount

select p.product,
	avg(s.amount) as Avg_Amount
from sales s
JOIN products p on s.PID = p.PID
group by p.Product
order by Avg_Amount;

#---------------------------------------------------------------------------------
#HAVING conditions    
select p.product,
	avg(s.amount) as Avg_Amount
from sales s
JOIN products p on s.PID = p.PID
group by p.Product
Having Avg_Amount > 5500
order by Avg_Amount;

#---------------------------------------------------------------------------------
#Count salespeople in each team
select Team, count(team) as Members #difference between count(*) and count(team)
									#is count(*) all the values even NULL values. 
                                    #but count(team) exclude the NULL values.
from people
group by Team
order by Team desc;

#---------------------------------------------------------------------------------
#Count total orders by each salesperson

select p.Salesperson,
	count(s.SPID) as Orders
from sales s
JOIN people p on s.SPID = p.SPID
group by Salesperson, p.SPID
order by Orders desc;
	
#---------------------------------------------------------------------------------
#Total boxes sold per product   

select pr.Product,
	sum(s.boxes) as Total_Boxes
from sales s
JOIN products pr on s.PID = pr.PID
group by pr.Product
order by Total_Boxes;

#---------------------------------------------------------------------------------
#Average sales amount per region

select g.Region,
 Avg(s.Amount) as Avg_sales
from sales s
JOIN Geo g on s.GeoID = g.GeoID
group by g.Region
order by Avg_sales;

#---------------------------------------------------------------------------------
#Teams with more than 5 salespeople

select Team,
	count(salesperson) as members
from people
group by Team
Having count(salesperson) > 5
order by members desc;

#---------------------------------------------------------------------------------
#Products with over ₹1 million in revenue

select pr.Product,
	sum(s.Amount) as Revenue
from sales s
JOIN products pr on s.PID = pr.PID
group by pr.Product
having sum(s.Amount) > 1000000
order by Revenue;

#---------------------------------------------------------------------------------
#Show team-wise total and average number of orders per salesperson
select Team,
	count(*) as Total_Salespersons,
    sum(Total_Orders) as Total_orders,
    avg(Total_Orders) as Avg_Orders

from (select p.Team,
		s.SPID as Unique_ID,
        count(*) as Total_Orders
        from sales s
        JOIN people p on s.SPID = p.SPID
        group by p.Team, s.SPID 
        ) As sub
	group by Team
    order by Total_orders;

#---------------------------------------------------------------------------------
#Top 5 products by total units sold

select pr.Product,
	sum(s.Boxes) as Units
from sales s
join products pr on s.PID = pr.PID
group by Pr.Product
order by Units desc
limit 5;

#---------------------------------------------------------------------------------
#Show sales count and total revenue per region where average sale > ₹5000

select
	g.Region,
    sum(s.Amount) as Total_Revenue,
    avg(s.Amount) as Avg_sale

from sales s
JOIN geo g on s.GeoID = g.GeoID
group by Region
having sum(s.Amount) > 5000
order by Total_Revenue;


#-------------------------------JOINs------------------------------------
#List all sales with the product name included.

select pr.Product,
	s.Amount as Sales
from Sales s
INNER JOIN products pr on s.PID = pr.PID
order by Sales desc;

#------------------------------------------------------------------------
#List all people, and if they made a sale, show their total amount.

select p.Salesperson,
	sum(s.Amount) as Sales
from people p 
Left JOIN sales s on p.SPID = s.SPID
group by p.Salesperson
order by Sales desc;

#------------------------------------------------------------------------
#Find total revenue for each product.

select pr.Product,
	sum(s.Amount) as Total_Sales
from sales s
JOIN products pr on s.PID = pr.PID
group by pr.Product
order by Total_Sales desc;
    
#------------------------------------------------------------------------
#Find salespeople who haven’t made any sales.

select p.Salesperson,
	s.Amount as Sales
from people p
LEFT JOIN sales s on p.SPID = s.SPID
where s.Amount is NULL
order by p.Salesperson;


#------------------------------------------------------------------------
#DISTINCT keyword - List all unique product categories.

select DISTINCT Category
from products;

#------------------------------------------------------------------------
#List all unique teams that have made at least one sale.

select DISTINCT p.Team
from people p
JOIN sales s on p.SPID = s.SPID
Where s.Amount >=1
order by p.Team;

#🔁 JOIN & DISTINCT Consolidation Tasks
#------------------------------------------------------------------------
#Task 1: Get sales date, product name, and number of boxes sold

select date_format(s.SaleDate, '%M,%Y') as Date_,
pr.Product as Product_name, 
sum(s.boxes) as Total_boxes
from sales s 
JOIN products pr on s.PID = pr.PID
group by date_format(s.SaleDate, '%M,%Y'), pr.Product
Order by date_format(s.SaleDate, '%M,%Y');

#------------------------------------------------------------------------
#Task 2: Find the total amount sold by each team

select p.Team,
	sum(s.Amount) as Total_Amount
from people p
JOIN sales s on p.SPID = s.SPID
group by Team
order by Total_Amount desc;

#------------------------------------------------------------------------
#Task 3: List all salespeople (name + location) and their product sold

select Distinct p.Salesperson,
	p.Location,
    pr.Product
from sales s
JOIN products pr on s.PID = pr.PID
JOIN people p on s.SPID = p.SPID
order by pr.Product;

#------------------------------------------------------------------------
#Task 4: Show each region and its total number of orders

select g.Region as Region,
	count(s.SPID) as Total_orders
from sales s
JOIN geo g on s.GeoID = g.GeoID
group by Region
order by Total_orders desc;

#------------------------------------------------------------------------
#Task 5: Show products that have never been sold

select pr.Product as Product_Name
	from products pr
    LEFT JOIN sales s on s.PID = pr.PID
    where s.PID is NULL
    order by Product_Name;

#------------------------------------------------------------------------
#Task 6: Show all salespeople who belong to a team, but remove duplicates

Select distinct Salesperson,
	Team
    from people
    
    order by Salesperson;
    
#------------------------------------------------------------------------
#Task 7: List all unique combinations of Region and Product that have sales

select distinct g.Region as Region,
	pr.Product as Product,
    s.amount as Sales

from sales s
JOIN products pr on s.PID = pr.PID
JOIN geo g on s.GeoID = g.GeoID
order by Sales;

#------------------------------------------------------------------------
#Task 8: Show all people and how many different products they’ve sold

select distinct p.salesperson as Salesperson,
    count(distinct pr.Product) as Units_Sold
from sales s
JOIN products pr on s.PID = pr.PID
JOIN people p on s.SPID = p.SPID
group by salesperson
order by Salesperson;




































