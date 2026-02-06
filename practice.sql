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

-- ORDERS TABLE
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
 -- PAYMENTS
 CREATE TABLE payments ( 
  payment_id     INT PRIMARY KEY, 
  order_id       INT, 
  paid_amount    DECIMAL(10,2), 
  payment_date   DATE, 
  payment_method VARCHAR(20), 
  FOREIGN KEY (order_id) REFERENCES orders(order_id) 
)
INSERT INTO payments (payment_id, order_id, paid_amount, payment_date, 
payment_method) VALUES 
(1,1001,1798.00,'2026-01-05','UPI'),        
(2,1002,1297.00,'2026-01-06','Card'),       
(3,1003,500.00,'2026-01-10','UPI'),         
(4,1005,1000.00,'2026-01-12','Card'),       
(5,1005,797.00,'2026-01-13','UPI'),         
(6,1006,1298.00,'2026-01-14','Card'),       
(7,1008,500.00,'2026-01-16','UPI'),         
(8,1009,1197.00,'2026-01-17','Card');  

-- SECTION A: Basic JOINs (Customers & Orders) 
-- 1.. Display all orders along with customer name and city. 
SELECT orders.order_id,orders.order_date,orders.status,customers.full_name, customers.city FROM orders LEFT JOIN customers ON orders.customer_id = customers.customer_id;

-- 2. Show all orders placed by customers from Bangalore. 
SELECT  order_id,full_name,order_date,status FROM customers LEFT JOIN orders  ON  customers.customer_id =orders.customer_id WHERE city='Bangalore';

-- 3. List only Delivered orders with customer name and order date.
SELECT order_id,full_name,order_date FROM orders o JOIN customers c ON o.customer_id = c.customer_id WHERE o.status = 'Delivered';

-- 4. Find customers who have placed at least one order. 
SELECT  c.customer_id,full_name,city FROM customers c JOIN orders o ON c.customer_id=o.customer_id GROUP BY c.customer_id,full_name,city;
-- 5. Find customers who have never placed any order.
SELECT customers.customer_id, full_name, city FROM customers LEFT JOIN orders ON customers.customer_id = orders.customer_id WHERE orders.customer_id IS NULL;
-- SECTION B: Orders & Products  (Multi-table JOINs) 
-- 6. Display order_id, product_name, quantity, and unit_price.
SELECT order_items.order_id,products.product_name,order_items.quantity,order_items.unit_price FROM order_items JOIN products ON order_items.product_id=products.product_id;
 
-- 7. Calculate line total for each product in an order (quantity × unit_price).
SELECT order_id,product_id,quantity*unit_price AS line_total FROM order_items;

-- 8. Calculate total order amount for each order.
SELECT order_id,SUM(quantity*unit_price) AS order_total FROM order_items GROUP BY order_id;
 
-- 9. List the top 5 highest value orders. 
SELECT order_id,SUM(quantity*unit_price) AS order_total FROM order_items GROUP BY order_id ORDER BY order_total DESC LIMIT 5;

-- 10. Display order details along with product name and category name.
SELECT order_items.order_id,products.product_name,categories.category_name FROM order_items JOIN products ON order_items.product_id=products.product_id JOIN categories ON products.category_id=categories.category_id;

-- SECTION C: Product & Category Analysis 

-- 11. Display all products with their category name. 
SELECT products.product_name,categories.category_name FROM products JOIN categories ON products.category_id=categories.category_id;

-- 12. Find categories that have no products. 
SELECT categories.category_id,categories.category_name FROM categories LEFT JOIN products ON categories.category_id=products.category_id WHERE products.product_id IS NULL;

-- 13. Count number of products in each category (include categories with zero products).
SELECT categories.category_name,COUNT(products.product_id) AS product_count FROM categories LEFT JOIN products ON categories.category_id=products.category_id GROUP BY categories.category_name;
 
-- SECTION D: Payments & Order Status 
-- 14. Display all orders along with their payment status (Paid / Not Paid). 
SELECT orders.order_id,CASE WHEN payments.order_id IS NULL THEN 'Not Paid' ELSE 'Paid' END AS payment_status FROM orders LEFT JOIN payments ON orders.order_id=payments.order_id;

-- 15. Find orders where payment amount is less than order total. 
SELECT oi.order_id FROM order_items oi LEFT JOIN payments p ON oi.order_id=p.order_id GROUP BY oi.order_id HAVING IFNULL(SUM(p.paid_amount),0)<SUM(oi.quantity*oi.unit_price);

-- 16. Identify orders that have multiple payments. 
SELECT order_id FROM payments GROUP BY order_id HAVING COUNT(payment_id)>1;

-- 17. Calculate total amount paid for each order
SELECT order_id,SUM(paid_amount) AS total_paid FROM payments GROUP BY order_id;

-- 18. Find Delivered orders that are not paid yet. 
SELECT orders.order_id FROM orders LEFT JOIN payments ON orders.order_id=payments.order_id WHERE orders.status='Delivered' AND payments.order_id IS NULL;

-- SECTION E: Business Insights (Real-world  Questions) 
-- 19. Calculate total revenue generated by each customer.
SELECT customers.customer_id,customers.full_name,SUM(order_items.quantity*order_items.unit_price) AS revenue FROM customers JOIN orders ON customers.customer_id=orders.customer_id JOIN order_items ON orders.order_id=order_items.order_id GROUP BY customers.customer_id,customers.full_name;
 
-- 20. Identify top 3 customers by revenue. 
SELECT customers.full_name,SUM(order_items.quantity*order_items.unit_price) AS revenue FROM customers JOIN orders ON customers.customer_id=orders.customer_id JOIN order_items ON orders.order_id=order_items.order_id GROUP BY customers.full_name ORDER BY revenue DESC LIMIT 3;

-- 21. Calculate revenue by product category. 
SELECT categories.category_name,SUM(order_items.quantity*order_items.unit_price) AS revenue FROM order_items JOIN products ON order_items.product_id=products.product_id JOIN categories ON products.category_id=categories.category_id GROUP BY categories.category_name;

-- 22. Find the best-selling product based on quantity sold. 
SELECT products.product_name,SUM(order_items.quantity) AS total_qty FROM order_items JOIN products ON order_items.product_id=products.product_id GROUP BY products.product_name ORDER BY total_qty DESC LIMIT 1;

-- 23. Calculate city-wise revenue. 
SELECT customers.city,SUM(order_items.quantity*order_items.unit_price) AS revenue FROM customers JOIN orders ON customers.customer_id=orders.customer_id JOIN order_items ON orders.order_id=order_items.order_id GROUP BY customers.city;

-- 24. Find orders that have no order items (data issue). 
SELECT orders.order_id FROM orders LEFT JOIN order_items ON orders.order_id=order_items.order_id WHERE order_items.order_id IS NULL;

-- 25. Find products that were never sold. 
SELECT products.product_name FROM products LEFT JOIN order_items ON products.product_id=order_items.product_id WHERE order_items.product_id IS NULL;

-- SECTION F: Advanced / Interview-Level Challenges (Optional) 
-- 26. For each customer, show their latest order date  (include customers with no orders). 
SELECT customers.customer_id,customers.full_name,MAX(orders.order_date) AS last_order FROM customers LEFT JOIN orders ON customers.customer_id=orders.customer_id GROUP BY customers.customer_id,customers.full_name;

-- 27. For each category, find the top-selling product. 
SELECT categories.category_name,products.product_name,SUM(order_items.quantity) AS total_qty FROM categories JOIN products ON categories.category_id=products.category_id JOIN order_items ON products.product_id=order_items.product_id GROUP BY categories.category_name,products.product_name;

-- 28. Find customers who bought products from at least two different categories. 
SELECT customers.customer_id,customers.full_name FROM customers JOIN orders ON customers.customer_id=orders.customer_id JOIN order_items ON orders.order_id=order_items.order_id JOIN products ON order_items.product_id=products.product_id GROUP BY customers.customer_id,customers.full_name HAVING COUNT(DISTINCT products.category_id)>=2;

-- 29. Identify repeat customers with more than one order. 
SELECT customers.customer_id,customers.full_name FROM customers JOIN orders ON customers.customer_id=orders.customer_id GROUP BY customers.customer_id,customers.full_name HAVING COUNT(orders.order_id)>1;

-- 30. Generate monthly revenue trend. 
SELECT DATE_FORMAT(orders.order_date,'%Y-%m') AS month,SUM(order_items.quantity*order_items.unit_price) AS revenue FROM orders JOIN order_items ON orders.order_id=order_items.order_id GROUP BY month ORDER BY month;
