-- CUSTOMERS TABLE
CREATE TABLE customers ( 
  customer_id INT PRIMARY KEY, 
  full_name   VARCHAR(100), 
  city        VARCHAR(50) 
); 
INSERT INTO customers (customer_id, full_name, city) VALUES 
(1,'Asha Kumar','Bangalore'), 
(2,'Ravi Menon','Chennai'), 
(3,'Neha Singh','Hyderabad'), 
(4,'Imran Ali','Bangalore'), 
(5,'Priya Iyer','Chennai'), 
(6,'Karthik Rao','Pune'); 
SELECT * FROM CUSTOMERS;
-- ORDER TABLE
CREATE TABLE orders(
order_id int primary key,
customer_id INT,
order_date DATE,
status VARCHAR(20),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO orders(order_id,customeR_id,order_date,status) values
(1001,1,'2026-01-05','Delivered'), 
(1002,2,'2026-01-06','Delivered'), 
(1003,1,'2026-01-10','Shipped'), 
(1004,3,'2026-01-11','Cancelled'), 
(1005,4,'2026-01-12','Delivered'), 
(1006,5,'2026-01-14','Delivered'), 
(1007,6,'2026-01-15','Created'), 
(1008,2,'2026-01-16','Delivered'), 
(1009,3,'2026-01-17','Delivered'), 
(1010,5,'2026-01-18','Delivered'); 

SELECT * FROM orders;
-- CATEGORIES TABLE
CREATE TABLE categories ( 
  category_id   INT PRIMARY KEY, 
  category_name VARCHAR(50) 
); 
INSERT INTO categories (category_id, category_name) VALUES 
(10,'Electronics'), 
(20,'Fashion'), 
(30,'Home'), 
(40,'Books'), 
(50,'Beauty'); 

SELECT * FROM categories;

-- PRODUCTS TABLE
CREATE TABLE products ( 
  product_id   INT PRIMARY KEY, 
  product_name VARCHAR(100), 
  category_id  INT, 
  FOREIGN KEY (category_id) REFERENCES categories(category_id) 
);  
INSERT INTO products (product_id, product_name, category_id) VALUES 
(101,'Wireless Mouse',10), 
(102,'USB-C Charger',10), 
(103,'T-Shirt',20), 
(104,'Jeans',20), 
(105,'Water Bottle',30), 
(106,'Cooking Pan',30), 
(107,'Novel - Mystery',40), 
(108,'Face Wash',50);
-- ORDER ITEMS
 
CREATE TABLE order_items ( 
  order_id    INT, 
  product_id  INT, 
  quantity    INT, 
  unit_price  DECIMAL(10,2), 
  PRIMARY KEY (order_id, product_id), 
  FOREIGN KEY (order_id) REFERENCES orders(order_id), 
  FOREIGN KEY (product_id) REFERENCES products(product_id) 
);
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(1001,101,1,799.00), 
(1001,102,1,999.00), 
(1002,103,2,499.00), 
(1002,105,1,299.00), 
(1003,104,1,1499.00), 
(1004,107,1,399.00), 
(1005,106,1,1299.00), 
(1005,108,2,249.00), 
(1006,101,1,799.00), 
(1006,103,1,499.00), 
(1008,102,1,999.00), 
(1008,105,2,299.00), 
(1009,107,3,399.00), 
(1010,106,1,1299.00), 
(1010,104,1,1499.00); 

SELECT * FROM order_items;


 -- PAYMENTS
 CREATE TABLE payments ( 
  payment_id     INT PRIMARY KEY, 
  order_id       INT, 
  paid_amount    DECIMAL(10,2), 
  payment_date   DATE, 
  payment_method VARCHAR(20), 
  FOREIGN KEY (order_id) REFERENCES orders(order_id) 
);
INSERT INTO payments (payment_id, order_id, paid_amount, payment_date, payment_method) VALUES 
(1,1001,1798.00,'2026-01-05','UPI'),        
(2,1002,1297.00,'2026-01-06','Card'),       
(3,1003,500.00,'2026-01-10','UPI'),         
(4,1005,1000.00,'2026-01-12','Card'),       
(5,1005,797.00,'2026-01-13','UPI'),         
(6,1006,1298.00,'2026-01-14','Card'),       
(7,1008,500.00,'2026-01-16','UPI'),         
(8,1009,1197.00,'2026-01-17','Card');  

SELECT * FROM payments;
-- 1.. Display all orders along with customer name and city. 
SELECT o.customer_id,o.order_id,c.full_name,c.city,o.order_date,o.status from orders o  join customers c on o.customer_id=c.customer_id;

-- 2. Show all orders placed by customers from Bangalore. 
SELECT o.customer_id,o.order_id,c.full_name,c.city,o.order_date,o.status from orders o  join customers c on o.customer_id=c.customer_id where c.city='Bangalore';

-- 3. List only Delivered orders with customer name and order date.
select c.full_name,o.order_id,o.order_date from orders o join customers c on o.customer_id=c.customer_id where o.status='delivered';

-- 4. Find customers who have placed at least one order. 
SELECT  c.customer_id,c.full_name,c.city from  customers c join orders o on c.customer_id=o.customer_id group by c.customer_id,full_name,city;

-- 5. Find customers who have never placed any order.
SELECT  c.customer_id,c.full_name,c.city from  customers c join orders o on c.customer_id=o.customer_id  where o.customer_id is null;

-- SECTION B: Orders & Products  (Multi-table JOINs) 
-- 6. Display order_id, product_name, quantity, and unit_price.
select o.order_id,product_name,o.quantity,o.unit_price from order_items o join products p on o.product_id=p.product_id;

-- 7. Calculate line total for each product in an order (quantity × unit_price).
select order_id,product_id,quantity*unit_price as line_total from order_items;

-- 8. Calculate total order amount for each order.
select order_id,SUM(quantity*unit_price) as order_total from order_items group by order_id;

-- 9. List the top 5 highest value orders. 
select order_id,SUM(quantity*unit_price) as order_total from order_items group by order_id order by order_total desc limit 5;

-- 10. Display order details along with product name and category name.
select o.order_id,p.product_name,c.category_name from order_items o join products p on o.product_id=p.product_id join categories c on c.category_id=p.category_id;

-- 11. Display all products with their category name. 
select p.product_id,p.product_name,c.category_name from products p join categories c on p.category_id=c.category_id;

-- 12. Find categories that have no products. 
select p.product_id,p.product_name,c.category_name from categories c left join products p on p.category_id=c.category_id  where product_id is null;

-- 13. Count number of products in each category (include categories with zero products).
select c.category_id,c.category_name,count(p.product_id) as product_count from categories c left join products p on c.category_id=p.category_id group by c.category_id;

-- SECTION D: Payments & Order Status 
-- 14. Display all orders along with their payment status (Paid / Not Paid). 
select o.order_id,case when p.order_id is null then 'Not Paid' else 'Paid' end as payment_status from orders o left join payments p on o.order_id=p.order_id;

-- 15. Find orders where payment amount is less than order total. 
select o.order_id  from order_items o LEFT JOIN payments p ON o.order_id=p.order_id GROUP BY o.order_id HAVING IFNULL(SUM(p.paid_amount),0)<SUM(o.quantity*o.unit_price);

-- 16. Identify orders that have multiple payments.

-- 17. Calculate total amount paid for each order
select order_id ,sum(paid_amount) as total_amount_paid from payments group by order_id

-- 18. Find Delivered orders that are not paid yet. 

-- SECTION E: Business Insights (Real-world  Questions) 
-- 19. Calculate total revenue generated by each customer.
select c.customer_id,c.full_name,sum(oi.quantity*oi.unit_price) as revenue from customers c join orders o on c.customer_id=o.customer_id join order_items oi on o.order_id=oi.order_id group by c.customer_id,c.full_name;

-- 20. Identify top 3 customers by revenue. 
select c.full_name,sum(oi.quantity*oi.unit_price) as revenue from customers c join orders o on c.customer_id=o.customer_id join order_items oi on o.order_id=oi.order_id group by c.full_name order by revenue desc limit 3;

-- 21. Calculate revenue by product category. 
select c.category_name,sum(oi.quantity*oi.unit_price) as revenue from order_items oi join products p on oi.product_id=p.product_id join categories c on c.category_id=p.category_id group by c.category_name;

-- 22. Find the best-selling product based on quantity sold. 
select p.product_name,sum(oi.quantity) as sold_quantity from order_items oi join products p on oi.product_id=p.product_id group by p.product_name order by sold_quantity desc limit 1;

-- 23. Calculate city-wise revenue. 
select c.city,sum(oi.quantity*oi.unit_price) as revenue from customers c join orders o on c.customer_id=o.customer_id join order_items oi on o.order_id=oi.order_id group by c.city;

-- 24. Find orders that have no order items (data issue). 
select o.order_id from orders o left join order_items oi on o.order_id=oi.order_id where oi.order_id is null;

-- 25. Find products that were never sold. 
select product_name from products left join order_items  on products.product_id=order_items.product_id WHERE order_items.product_id IS NULL;


-- SECTION F: Advanced / Interview-Level Challenges (Optional) 

-- 26. For each customer, show their latest order date  (include customers with no orders). 
select c.customer_id,c.full_name,max(o.order_date) as last_order from customers c join orders o on c.customer_id=o.customer_id group by c.customer_id,c.full_name;

-- 27. For each category, find the top-selling product.
select c.category_name,p.product_name,sum(oi.quantity) as total_quantity from categories c join products p on c.category_id=p.category_id join order_items oi on p.product_id=oi.product_id group by c.category_name,p.product_name;

-- 28. Find customers who bought products from at least two different categories. 
select c.customer_id,c.full_name from customers c join orders o on c.customer_id=o.customer_id join order_items oi on o.order_id=oi.order_id join products p on oi.product_id=p.product_id group by c.customer_id,c.full_name having count(distinct p.category_id)>=2;

-- 29. Identify repeat customers with more than one order.
select c.customer_id,c.full_name from customers c join orders o ON c.customer_id=o.customer_id GROUP BY c.customer_id,c.full_name HAVING COUNT(o.order_id)>1;

 -- 30. Generate monthly revenue trend. 
 select DATE_FORMAT(o.order_date,'%Y-%m') as month,sum(oi.quantity * oi.unit_price) as revenue from orders o join order_items oi on o.order_id=oi.order_id group by month order by month;

