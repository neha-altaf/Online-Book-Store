--create database
create database Online_BookStore;

--creating table Books
create table Books(
	Book_ID	serial primary key,
	Title varchar(100),	
	Author varchar(100),	
	Genre varchar(50),	
	Published_Year int,
	Price numeric(10,2),
	Stock int	
);

--creating table Customers
create table Customers(
	Customer_ID	serial 	primary key,
	Name varchar(100),	
	Email varchar(100),	
	Phone varchar(15),	
	City varchar(50),	
	Country varchar(150)	
);

--creating table Orders
create table Orders(
	Order_ID serial primary key,
	Customer_ID	int	references Customers(Customer_ID),
	Book_ID	int	references Books(Book_ID),
	Order_Date date,
	Quantity int,	
	Total_Amount numeric(10,2)	
);

select * from Books
select * from Orders
select * from Customers

					--Basic queries
--retrieve all books in the 'fiction' genere
select * from Books where Genre='Fiction';

--find books published after year 1950
select * from Books where published_year>1950;

--list all the customers  from canada
select * from customers where country='Canada';

--show orders placed in november 2023
select * from Orders 
where order_date between '2023-11-01' and '2023-11-30';

--retrieves the total stock of books available
select sum(stock) as total_stock from Books;

--find the details of most expensive book
select * from Books 
order by price desc limit 1;

--show all customers who order more than one quantity of book
select * from Orders
where quantity>1;

--retrieve all orders where total amount exceeds $20
select * from Orders where total_amount>20;

--list all the genre available in books table
select distinct genre as All_genre
from Books;

--find the book with lowest stock
select * from books order by stock asc limit 1;

--calculate the total revenue generated from all orders
select sum(total_amount) as revenue from Orders;

						--Advance queries
--retrieve the total number of book sold for each genre
select b.genre,sum(o.quantity) as sold_quantity
from orders o inner join books b
on o.book_id=b.book_id
group by b.genre;

--find the average price of books in fantasy genre
select avg(price) from books where genre='Fantasy';

--list customers who have placed at least 2 orders
select o.customer_id,c.name,count(o.order_id) as order_count
from orders o join customers c on o.customer_id=c.customer_id 
group by o.customer_id, c.name
having count(order_id)>=2
;

--find the most frequently ordered book
select o.book_id,b.title,count(o.order_id) as order_count
from orders o inner join books b
on o.book_id=b.book_id
group by o.book_id,b.title
order by order_count desc limit 1;

--show the top three most expensive books of fantasy genre
select book_id,title,price
from books where genre='Fantasy'
order by price desc limit 3;

--retrieve the total quantity of books sold by each author
select b.author,sum(o.quantity) as total_book_sold
from orders o inner join books b
on o.book_id=b.book_id
group by b.author;

--list the cities where customers who spent over $30
select distinct c.city,o.total_amount
from customers c inner join orders o
on c.customer_id=o.customer_id
where o.total_amount>30;

--find the customers who spend most on orders
select c.name,c.customer_id,sum(o.total_amount) as total_spend
from customers c inner join orders o
on c.customer_id=o.customer_id
group by c.customer_id,c.name
order by sum(o.total_amount) desc limit 1;

--calculate the stock remaining after fulfilling all orders
select b.book_id,b.title,b.stock, coalesce(sum(o.quantity),0) as order_quantity,
b.stock - coalesce(sum(o.quantity),0) as remaining_quantity
from books b left join orders o
on b.book_id=o.book_id
group by b.book_id
order by b.book_id;

