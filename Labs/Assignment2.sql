--Name: Harsh Patel
--Class: NDD
--Student ID:146315205
--Purpose: Assignment #2
--Date: 1-04-2022
SET SERVEROUTPUT ON;
-- find_customer (customer_id IN NUMBER, found OUT NUMBER);
CREATE OR REPLACE PROCEDURE find_customer (customerID IN NUMBER, found OUT NUMBER)
AS num NUMBER := 0;
BEGIN
 SELECT
 COUNT(*)
 INTO num
 FROM
 customers
 WHERE
 customer_id = customerID;
 
 IF ( num > 0 ) THEN
 found := 1;
 dbms_output.put_line('Customer ID :' || customerID);
 dbms_output.put_line('Found :' || found);
 ELSE
 found := 0;
 dbms_output.put_line('Customer ID :' || customerID);
 dbms_output.put_line('Found :' || found || ', customer not found.');
 END IF;
EXCEPTION
 WHEN no_data_found THEN found := 0;
 dbms_output.put_line('Customer ID :' || customerID);
 dbms_output.put_line('Found :' || found);
END find_customer;
/
-- find_product (product_id IN NUMBER, price OUT products.list_price%TYPE);
CREATE OR REPLACE PROCEDURE find_product (id IN NUMBER, price OUT 
products.list_price%TYPE)
AS temp_price products.list_price%TYPE;
BEGIN
 SELECT
 list_price
 INTO
 temp_price
 FROM
 products p
 WHERE
 p.product_id = id;
 IF ( temp_price = 0 ) THEN
 price := 0;
 ELSE
 price := temp_price;
 END IF;
 dbms_output.put_line('Product ID: ' || id);
 dbms_output.put_line('Price : ' || price);
 EXCEPTION
 WHEN no_data_found THEN price := 0;
 dbms_output.put_line('Product ID: ' || id);
 dbms_output.put_line('Price : ' || price || ', product not found.'); 
END find_product;
/
-- add_order (customer_id IN NUMBER, new_order_id OUT NUMBER)
CREATE OR REPLACE PROCEDURE add_order(customerID IN NUMBER, new_order_id OUT 
NUMBER) AS
temp_order_id NUMBER;
BEGIN
 SELECT max(order_id) + 1
 INTO temp_order_id
 FROM orders
 WHERE orders.customer_id = customerID;
 
 IF ( temp_order_id <> 0 ) THEN
 new_order_id := temp_order_id;
 INSERT INTO orders
 (order_id, customer_id, status, salesman_id, order_date)
 VALUES
 (temp_order_id, customerID, 'Shipped', 56, SYSDATE);
 dbms_output.put_line('Customer ID: ' || customerID);
 dbms_output.put_line('New Order ID: ' || new_order_id);
 ELSE
 dbms_output.put_line('Invalid customer ID.');
 END IF;
END add_order;
/
-- add_order_item (orderId IN order_items.order_id%type,
-- itemId IN order_items.item_id%type,
-- productId IN order_items.product_id%type,
-- quantity IN order_items.quantity%type,
-- price IN order_items.unit_price%type)
CREATE OR REPLACE PROCEDURE add_order_item(orderId IN order_items.order_id%type,
 itemId IN order_items.item_id%type,
 productId IN order_items.product_id
%type,
 quantity1 IN order_items.quantity%type,
 price IN order_items.unit_price%type)
AS var_A NUMBER;
BEGIN
 SELECT order_id INTO var_A FROM order_items WHERE order_id = orderId;
 INSERT INTO order_items
 (order_id, item_id, product_id, quantity, unit_price)
 VALUES
 (orderId, itemId, productId, quantity1, price);
 dbms_output.put_line('Successfully added order item.');
 
 EXCEPTION
 WHEN no_data_found THEN
 dbms_output.put_line('Invalid order ID.');
 WHEN too_many_rows THEN
 INSERT INTO order_items
 (order_id, item_id, product_id, quantity, unit_price)
 VALUES
 (orderId, itemId, productId, quantity1, price);
 dbms_output.put_line('Successfully added order item.');
 
END add_order_item;
/
-- display_order (orderId IN NUMBER)
CREATE OR REPLACE PROCEDURE display_order(orderid IN NUMBER) AS
CURSOR order_cursor IS
SELECT i.order_id AS "o_id", o.customer_id AS "c_id", item_id, product_id, 
 quantity, unit_price, quantity * unit_price AS "total"
FROM
 (order_items i LEFT JOIN orders o ON i.order_id = o.order_id)
WHERE
 i.order_id = orderID;
round NUMBER := 0;
total_price NUMBER := 0;
o_id order_items.order_id%TYPE;
c_id orders.customer_id%TYPE;
item_id order_items.item_id%TYPE;
product_id order_items.product_id%TYPE;
quantity order_items.quantity%TYPE;
unit_price order_items.unit_price%TYPE;
total order_items.unit_price%TYPE;
BEGIN
 OPEN order_cursor;
 LOOP
 round := round + 1;
 FETCH order_cursor INTO o_id, c_id, item_id, product_id, quantity, unit_price, 
total;
 EXIT WHEN order_cursor%notfound;
 
 IF round <= 1 THEN
 dbms_output.put_line('Order ID : '|| o_id);
 dbms_output.put_line('Customer ID: '|| c_id);
 END IF;
 
 dbms_output.put_line(' Item ID: '|| item_id || ', Product ID: '|| product_id 
|| ', Quantity: '|| quantity || ', Price: '|| unit_price);
 total_price := total + total_price;
 END LOOP;
 
 IF order_cursor%rowcount = 0 THEN
 dbms_output.put_line('Order ID: '|| orderid ||' not found.');
 ELSE
 dbms_output.put_line('Total price: '|| total_price);
 END IF;
 
 CLOSE order_cursor;
 
END display_order;
/
-- master_proc (task IN NUMBER, parm1 IN NUMBER)
CREATE OR REPLACE PROCEDURE master_proc (task IN NUMBER, parm1 IN NUMBER) AS
num1 NUMBER;
num2 products.list_price%TYPE;
num3 NUMBER;
BEGIN
 CASE task
 WHEN 1 THEN find_customer(parm1, num1);
 WHEN 2 THEN find_product(parm1, num2);
 WHEN 3 THEN add_order(parm1, num3);
 WHEN 4 THEN display_order(parm1);
 END CASE;
 
 EXCEPTION
 WHEN OTHERS
 THEN
 dbms_output.put_line('ERROR');
 
END master_proc;
/
BEGIN
 dbms_output.put_line('1 – find_customer – with a valid customer ID');
 master_proc(1, 1); -- 1
 dbms_output.put_line('');
 dbms_output.put_line('2 – find_customer – with an invalid customer ID');
 master_proc(1, 10101); -- 2
 dbms_output.put_line('');
 dbms_output.put_line('3 – find_product – with a valid product ID');
 master_proc(2, 2); -- 3
 dbms_output.put_line('');
 dbms_output.put_line('4 – find_product – with an invalid product ID');
 master_proc(2, 10235); -- 4
 dbms_output.put_line('');
 dbms_output.put_line('5 – add_order – with a valid customer ID');
 master_proc(3, 1); -- 5
 dbms_output.put_line('');
 dbms_output.put_line('6 – add_order – with an invalid customer ID');
 master_proc(3, 45289); -- 6
 dbms_output.put_line('');
 dbms_output.put_line('7 – add_order_item – should execute successfully 5 
times');
 add_order_item(1, 4, 233, 333, 4333); -- 7
 add_order_item(1, 5, 233, 222, 5333);
 add_order_item(1, 6, 233, 555, 6333);
 add_order_item(1, 7, 233,666, 7333);
 add_order_item(1, 8, 233, 777, 8333);
 dbms_output.put_line('');
 dbms_output.put_line('8 – add_order_item – should execute with an invalid order
ID');
 add_order_item(2563, 0245, 585, 5748,86963); --8
 dbms_output.put_line('');
 dbms_output.put_line('9 – display_order – with a valid order ID which has at 
least 5 order items');
 master_proc(4, 2); -- 9
 dbms_output.put_line('');
 dbms_output.put_line('10 – display_order – with an invalid order ID');
 master_proc(4, 9999); -- 10
END;    
/