#------------------------------------Mini Exam-------------------------------------------
# Q1. Write a query to show the names and locations of all salespeople from
# the people table whose location is 'Hyderabad'.

select Salesperson,
	Location
from people
where Location = 'Hyderabad'
order by Salesperson;

#----------------------------------------------------------------------------------------
#Q2. Show the top 5 highest individual sales (by Amount) from the sales table.

select Amount as Top_5_Amount
from sales
order by Amount desc
limit 5;

#----------------------------------------------------------------------------------------
# Q3. How would you filter rows where Boxes is greater than 10 and 
# Amount is between ₹8000 and ₹12000?

select boxes, Amount
from sales
where boxes > 10 and Amount between 8000 and 12000
order by Boxes;

#----------------------------------------------------------------------------------------
# Q4. Count how many unique teams are in the people table.

select count(distinct Team) as Unique_Teams
	from people;

#----------------------------------------------------------------------------------------
# Q5. Show the total sales amount per region (use a JOIN).
# Order by total sales descending.

select g.Region as Region,
	sum(s.Amount) as Total_Amount
from sales s
JOIN geo g on s.GeoID = g.GeoID
group by g.Region
order by sum(s.Amount) desc;

#----------------------------------------------------------------------------------------
#Q6. List products that have never been sold.

select pr.product as Product_Name
from products pr
left JOIN sales s on pr.PID = s.PID
where s.PID is null
order by pr.product;

#----------------------------------------------------------------------------------------
#Q7. Show the average sales amount per product.

select pr.Product as Product_Name,
	avg(s.Amount) as Avg_sales
from products pr
JOIN sales s on pr.PID = s.PID
group by pr.Product
order by avg(s.Amount) desc;

#----------------------------------------------------------------------------------------
#Q8. Write a query to show all unique product categories.

select distinct Category
from products
order by category desc;

#----------------------------------------------------------------------------------------
#Q9. Get the total revenue per product where total revenue is more than ₹1,000,000.

select pr.Product as Product_Name,
	sum(s.Amount) as Total_Revenue
from products pr 
JOIN sales s on pr.PID = s.PID
group by pr.Product
having sum(s.Amount) > 1000000
order by sum(s.Amount);

#----------------------------------------------------------------------------------------
#Q10. Show each salesperson and the number of unique products they’ve sold.

select p.salesperson as Salesperson, 
	count(distinct pr.product) as Number_of_products
from sales s
JOIN products pr on s.PID = pr.PID
JOIN people p on s.SPID = p.SPID
group by p.Salesperson
order by p.Salesperson;

#----------------------------------------------------------------------------------------
# Q11. List the names of all salespeople who haven’t made a sale.

select salesperson as Salesperson
from people p
LEFT JOIN sales s on p.SPID = s.SPID
where s.SPID is null;

#Q12. What is the difference between WHERE and HAVING? When do you use each?

/*Where execution happens in early stage of execution whereas Having execution happen mostly after having.
Where can't use aggregate functions like sum(), count() etc. However having has the
capability of using them.
Where works on rows while having works after grouping the data.*/





