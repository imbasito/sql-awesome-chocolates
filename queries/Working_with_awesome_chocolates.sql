select * from products;
select Category, Size from products;
select * from sales;
select Amount, Customers, GeoID from sales;

select SaleDate, Amount, Boxes, Amount/boxes as 'Amount per box' from sales;

select * from sales 
where Amount>10000;

select * from sales 
where Amount>10000
order by Amount desc;

select * from sales 
where Amount>10000
order by Amount;

select * from sales
where geoid = "g1"
order by PID, Amount desc;

select * from sales
where amount > 10000 and SaleDate >= '2021-01-01'
order by PID;

select amount, PID, SaleDate from sales
where amount > 10000 and year(SaleDate) = 2022
order by amount desc;

select * from sales
where boxes >= 0 and boxes<= 50
order by boxes desc;

select * from sales
where boxes between 0 and 50
order by boxes desc;

select Amount, SaleDate, boxes, weekday(SaleDate) as 'Day of week' from sales
where weekday(SaleDate) = 2;

select * from people
where team = 'Delish' or team = 'Jucies';

select * from people
where team in ('Delish', 'Jucies');

select * from people
where team like "Jucies";

select * from people
where location like "hyderabad";

select * from people
where salesperson like "%a%";

select * from people
where salesperson like "%b%";

select * from people
where location not like "%a%";

/*--------Alias--------*/
#for table
select * from sales;
select PID, Amount, Customers from sales as record;

#for column
select PID as ID, Amount, Customers from sales;

/*---------------------------------------------*/

#--------------CASE (If-else)-------------------

select GeoID, 
CASE
	When GeoID = 'G4' then 'Chachakhel'
    When GeoID = 'G2' then 'Awanan'
    When GeoID = 'G3' then 'Gara'
    When GeoID = 'G1' then 'Khankhel'
    Else 'Unknown'
End as Location
from sales;

#-------------------Important - JOIN -------------

select * from sales as s inner join people as p on s.SPID = p.SPID;

select * from sales as s right join people as p on s.SPID = p.SPID;

select sales.spid, sales.Amount, people.spid 
from sales left join people on sales.spid = people.spid;

#------------------------------------------------------

select saleDate,amount,
	case
			when amount < 1000 then 'under 1k'
            when amount < 2000 then 'under 2k'
            when amount < 3000 then 'under 3k'
            when amount < 4000 then 'under 4k'
		else '4k or more'
	end as 'amount category'
    from sales;
#-------------------------------------------













