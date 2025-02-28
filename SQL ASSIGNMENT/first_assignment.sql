use DATABASE RISE;

--creating the table---
CREATE or replace table MA_SALES_DATA

(    order_id STRING PRIMARY KEY,
     order_date DATE,
     
     ship_date DATE,
     
     ship_mode VARCHAR2(100),
     
     customer_name VARCHAR2(100),
     
     segment string,
     
     state STRING,
     
     country VARCHAR(100),
     
     market VARCHAR(20),
     
     region CHAR(40),
     
     product_id STRING,
     
     category STRING,
     
     sub_category VARCHAR(40),

     product_name STRING,
     
     sales NUMBER(10,0),

     quantity INT,

     discount FLOAT,

     profit FLOAT,

     shipping_cost FLOAT,

     order_priority VARCHAR(40),

     year INT
     );
     DESCRIBE TABLE MA_SALES_DATA;
     SELECT * FROM MA_SALES_DATA; -- loaded the csv file after some cleaning

-- Q1. SET PRIMARY KEY----------------------------------

-- Answer-
     
ALTER TABLE MA_SALES_DATA DROP PRIMARY KEY;
DESCRIBE TABLE MA_SALES_DATA;

ALTER TABLE MA_SALES_DATA ADD PRIMARY KEY (ORDER_ID); 

-- Q2.  CHECK THE ORDER DATE AND SHIP DATE TYPE AND THINK IN WHICH DATA TYPE YOU HAVE TO CHANGE.
     
-- Answer- changed the data type in excel.

-- Q3.  EXTACT THE LAST NUMBER AFTER THE - AND CREATE OTHER COLUMN AND UPDATE IT.

-- Answer-

alter table MA_SALES_DATA add last_num_order_id int; -- created an empty column by alter table 

update MA_SALES_DATA
set last_num_order_id = split_part(order_id, '-',3); --extracting after last '-' and updating the table column

select order_id, last_num_order_id from MA_SALES_DATA;

--Q4. FLAG IF DISCOUNT IS GREATER THEN 0 THEN  YES ELSE FALSE AND PUT IT IN NEW COLUMN FOR EVERY ORDER ID.

ALTER TABLE MA_SALES_DATA
ADD COLUMN DISCOUNT_OR_NOT VARCHAR(10);

ALTER TABLE MA_SALES_DATA
DROP COLUMN DISCOUNT_OR_NOT;

SELECT * FROM MA_SALES_DATA;

CREATE OR REPLACE TABLE MA_SALES_DATA_DISCOUNT_FLAG AS
SELECT *,
CASE WHEN DISCOUNT > 0 THEN 'YES'
ELSE 'NO'
END AS DISCOUNT_OR_NOT
FROM MA_SALES_DATA;

SELECT * FROM MA_SALES_DATA_DISCOUNT_FLAG;
SELECT DISCOUNT, DISCOUNT_OR_NOT FROM MA_SALES_DATA_DISCOUNT_FLAG;

-- Q6.  FIND OUT HOW MUCH DAYS TAKEN FOR EACH ORDER TO PROCESS FOR THE SHIPMENT FOR EVERY ORDER ID.

-- Answers-
SELECT * FROM MA_SALES_DATA;

SELECT ORDER_ID, ORDER_DATE, SHIP_DATE,
DATEDIFF('DAY', ORDER_DATE, SHIP_DATE) AS ORDER_PROCESS_TIME
FROM MA_SALES_DATA
ORDER BY ORDER_PROCESS_TIME DESC;

--Q7. FLAG THE PROCESS DAY AS BY RATING IF IT TAKES LESS OR EQUAL 3  DAYS MAKE 5,LESS OR EQUAL THAN 6 DAYS BUT MORE THAN 3 MAKE 4,LESS THAN 10 BUT MORE THAN 6 MAKE 3,MORE THAN 10 MAKE IT 2 FOR EVERY ORDER ID.

--Answer

SELECT ORDER_ID, ORDER_DATE, SHIP_DATE,
DATEDIFF('DAY', ORDER_DATE, SHIP_DATE) AS ORDER_PROCESS_TIME,
CASE
    WHEN ORDER_PROCESS_TIME <= 3 THEN 5
    WHEN ORDER_PROCESS_TIME >3 AND ORDER_PROCESS_TIME <=6 THEN 4
    WHEN ORDER_PROCESS_TIME >6 AND ORDER_PROCESS_TIME <10 THEN 3
    ELSE 2
    END AS RATING
FROM MA_SALES_DATA
ORDER BY RATING DESC;








     