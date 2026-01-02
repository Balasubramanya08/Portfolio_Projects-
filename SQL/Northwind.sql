
---1. Which shippers do we have? 

select* from [dbo].[Shippers]
----------------------------------------------------------------------------------
---2 Certain fields from Categories ?

 select CategoryName,Description     
  from [dbo].[Categories]
---------------------------------------------------------------------------------
--- 3 Sales Representatives ?

Select Firstname,lastname,Hiredate 
from [dbo].[Employees]
where title = 'sales Representative'
-------------------------------------------------------------------------------
---4 Sales Representatives in the United States ?
Select Firstname,lastname,Hiredate
from [dbo].[Employees]
where title = 'sales Representative' and country ='USA'

select * from [dbo].[Employees]
---------------------------------------------------------------------------------------
---5 Orders placed by specific EmployeeID?
Select orderID,Orderdate
from [dbo].[Orders]
where EmployeeID=5  
--------------------------------------------------------------------------------------------
---6 Suppliers and ContactTitles ?

Select SupplierID,ContactName,ContactTitle
from [dbo].[Suppliers]
where ContactTitle <> 'Marketing Manager'

select * from [dbo].[Suppliers]
-------------------------------------------------------------------------------------------------
---7 Products with “queso” in ProductName ?

Select ProductID,ProductName
From [dbo].[Products]
where ProductName like 'Queso%'

select * from[dbo].[Products]
-------------------------------------------------------------------------------------------------------
---8 Orders shipping to France or Belgium ? 

Select OrderID,CustomerID,ShipCountry
from [dbo].[Orders]
where ShipCountry in ('France','Belgium')

select * from[dbo].[Orders]
select * from [dbo].[OrderDetails]
----------------------------------------------------------------------------------------------
---9 Orders shipping to any country in Latin America ?
Select OrderID,CustomerID,ShipCountry
from [dbo].[Orders]
where ShipCountry in ('Brazil','Mexico','Argentina','Venezuela')
-----------------------------------------------------------------------------------------------
---10.Employees, in order of age ?
Select FirstName,LastName,Title,BirthDate
from [dbo].[Employees]
order by  BirthDate 

select * from [dbo].[Employees]
---------------------------------------------------------------------------------------------
---11.Showing only the Date with a DateTime field ?

select FirstName,LastName,Title, CONVERT(VARCHAR(10), BirthDate, 120) as DataonlyBirthdata 
from [dbo].[Employees]
order By BirthDate 
---------------------------------------------------------------------------------------------
--- 12.Employees full name ?

select FirstName,LastName, concat (FirstName,' ',LastName) as Fullname
from [dbo].[Employees]
---------------------------------------------------------------------------------------

---13 OrderDetails amount per line item  

Select Orderid,ProductID,UnitPrice,Quantity, (Unitprice*Quantity) as Totalprice 
from [dbo].[OrderDetails]


Select * from [dbo].[OrderDetails]
----------------------------------------------------------------------------------------
---14 How many customers? 

Select count (ContactName) as Totalcustomers

from [dbo].[Customers]

select * from [dbo].[Customers]
------------------------------------------------------------------------------
---15 When was the first order? 

Select MIN(orderdate) as Firstorder
from [dbo].[Orders]

Select * From[dbo].[Orders]
----------------------------------------------------------------------------
---16 Countries where there are customers  
Select  country 
from [dbo].[Customers]
Group by  Country

	Select * From[dbo].[Customers]
---------------------------------------------------------------------------
---17 Contact titles for customers

Select ContactTitle, count (ContactTitle) as TotalContactTitle
from [dbo].[Customers]
Group By contactTitle   
Order By TotalContactTitle Desc

---18 Products with associated supplier names

Select * From [dbo].[Products]
Select * from [dbo].[Suppliers]

Select Products.ProductID,ProductName, Suppliers.CompanyName
From [dbo].[Products]
inner Join [dbo].[Suppliers]
on Suppliers.SupplierID = Products.SupplierID
----------------------------------------------------------------------------
---19 Orders and the Shipper that was used

select*from[dbo].[Orders]
select*from[dbo].[Shippers]

Select Orders.OrderID,orderdate, Shippers.CompanyName
from [dbo].[Orders]
inner Join [dbo].[Shippers]
on Orders.ShipVia = Shippers.ShipperID
where OrderID < 10300
-------------------------------------------------------------------------------
---20 Categories, and the total products in each category

Select * From[dbo].[Categories]
Select * From [dbo].[Products]

select [dbo].[Categories].CategoryName, count (CategoryName) as Totalproduct
from [dbo].[Categories]
inner Join [dbo].[Products]
on Products.CategoryID = Categories.CategoryID
group by  CategoryName
order by Totalproduct desc
---------------------------------------------------------------
---21	Total customers per country/city 

select* From [dbo].[Customers]

select Country,City, COUNT  (country) as Totalcustomers
from [dbo].[Customers]
group by country,city
order by Totalcustomers desc
----------------------------------------------------------------
--- 22 Products that need reordering 

select* From [dbo].[Products]

Select ProductID,ProductName,UnitsInStock,ReorderLevel
from [dbo].[Products]
where UnitsInStock < ReorderLevel
------------------------------------------------------------
--- 23. Products that need reordering, continued 
select * from [dbo].[Products]

select ProductID,ProductName,UnitsInStock,UnitsOnOrder,ReorderLevel, Discontinued
from Products
where UnitsInStock + UnitsOnOrder <= ReorderLevel 
And  Discontinued = 0
order by Discontinued 
------------------------------------------------------------
---24. Customer list by region (DOB)
select * from [dbo].[Customers]

select CustomerID,CompanyName,Region 
from [dbo].[Customers]
ORDER BY CASE WHEN Region IS NULL THEN 1 ELSE 0 END,
    Region ASC;
------------------------------------------------------
---25 High freight charges
select* from [dbo].[Orders]

select top 3  ShipCountry,avg (Freight) as Averagefreight
from [dbo].[Orders]
group by ShipCountry 
order by  averagefreight desc
------------------------------------------------------

---26 High freight charges - 2015

select* from [dbo].[Orders]

select top 3 ShipCountry,avg (freight) as Averagefreight
from [dbo].[Orders]
WHERE OrderDate BETWEEN '2015-01-01 00:00:000' AND '2015-12-31 00:00:000'
group By ShipCountry 
order By averagefreight desc

-----------------------------------------

----27.High freight charges with between 
select top 3 ShipCountry,avg (freight) as Averagefreight
from[dbo].[Orders]
where OrderDate > '2014-12-31' AND OrderDate < '2016-01-01'
group by ShipCountry
order By Averagefreight desc
--------------------------------------------------
----28.High freight charges - last year

Select * from [dbo].[Orders]

SELECT TOP 3 ShipCountry,AVG(Freight) AS AverageFreight
FROM dbo.Orders
WHERE OrderDate > DATEADD(MONTH, -12, (SELECT MAX(OrderDate) FROM dbo.Orders))
GROUP BY ShipCountry
ORDER BY AverageFreight DESC;
-----------------------------------------------------
----30. Inventory list  
select* from [dbo].[Orders]
select * from[dbo].[Employees]
select * from [dbo].[Products]
select * from[dbo].[OrderDetails]

 select [dbo].[Employees].EmployeeID,LastName,Orders.OrderID,[dbo].[Products].productname,[dbo].[OrderDetails].Quantity 
 from [dbo].[Orders]
 Inner Join [dbo].[Employees]
 on [dbo].[Employees].EmployeeID =[dbo].[Orders].EmployeeID
 inner Join [dbo].[OrderDetails]
 on [dbo].[OrderDetails].orderID = [dbo].[Orders].orderid
 inner Join Products
 on Products.productid = [dbo].[OrderDetails].ProductID
 ----------------------------------------------------------
 ---- 30.Customers with no orders 
 select * from  [dbo].[Customers]
 select * from [dbo].[Orders]

 select Customers.CustomerID as Customers_CustomerID, Orders.CustomerID as Orders_CustomerID
 from Customers
 left outer join Orders
 on [dbo].[Orders].customerid = customers.customerid
  where Orders.CustomerID is null 
  ---------------------------------------------------------------
  ---31.Customers with no orders for EmployeeID 4
  select * from [dbo].[Orders]
  select * from [dbo].[Customers]

 select Customers.CustomerID,Orders.CustomerID
 from Customers
 left outer join Orders
 on Orders.CustomerID =  customers.CustomerID 
 and Orders.EmployeeID =4 
  where Orders.CustomerID is null 
  ------------------------------------------------------------
 
  