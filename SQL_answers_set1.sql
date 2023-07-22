Q.1 Query all columns for all American cities in the CITY table with 
 populations larger than 100000. The countryCode for America is USA.
->

CREATE TABLE city(
        id INT,
        name VARCHAR(17),
        countrycode VARCHAR(3),
        district VARCHAR(20),
        population INT

	);


INSERT INTO city VALUES 
        (6,'Rotterdam','NLD','Zuid-Holland',593321),
        (3878,'Scottsdale','USA','Arizona',202705),
        (3965,'Corona','USA','California',124966),
        (3973,'Concord','USA','California',121780),
        (3977,'Cedar Rapids','USA','Iowa',120758),
        (3982,'Coral Springs','USA','Florida',117549),
        (4054,'Fairfield','USA','California',92256),
        (4058,'Boulder','USA','Colorado',91238),
        (4061,'Fall River','USA','Massachusetts',90555),
        (1661,'NYC','USA','Newyork',90525),
        (4333,'Mitaka','JPN','Tokyo',91155),
        (4551,'Hino','JPN','Tokyo',45678);



SELECT  
        id,
        name,
        countrycode,
        district,
        population 
FROM 
        city
WHERE
		population > 100000 
        AND 
        countrycode = 'USA';



 Q.2 Query the name field for all American cities in the CITY table with 
 populations larger than 120000. The countryCode for America is USA.

->

SELECT  
      name
FROM 
      city
WHERE
     population > 120000 
     AND 
     countrycode = 'USA';



 Q.3 Query all columns (attributes) for every row in the CITY table. 
->

SELECT  
        id,
        name,
        countrycode,
        district,
        population  
FROM 
        city;



 Q.4 Query all columns for a city in CITY with the id 1661.

->

SELECT  
        id,
        name,
        countrycode,
        district,
        population  
FROM 
        city
WHERE
        id = 1661;



 Q.5 Query all attributes of every Japanese city in the CITY table. 
 The countryCODE for Japan is JPN.

->

SELECT  
        id,
        name,
        countrycode,
        district,
        population  
FROM 
        city
WHERE
        countrycode = 'JPN';



 Q.6 Query the names of all the Japanese cities in the CITY table. 
 The countryCODE for Japan is JPN.

->

SELECT  
        name
FROM 
        city
WHERE
        countrycode = 'JPN';



 Q.7 Query a list of CITY and STATE from the station table.
->

CREATE TABLE station(
        id INT,
        city VARCHAR(21),
        state VARCHAR(2),
        lat_n INT,
        long_w INT

	);


INSERT INTO station VALUES 
        (794,'Kissee Mills','MO',139,73),
        (824,'Loma Mar','CA',48,130),
        (603,'Sandy Hook','CT',72,148),
        (478,'Tipton','IN',33,97),
        (619,'Arlington','CO',75,92),
        (711,'Turner','AR',50,101),
        (839,'Slidell','LA',85,151),
        (411,'Negreet','LA',98,105),
        (588,'Glencoe','KY',46,136),
        (665,'Chelsea','IA',98,59),
        (342,'Chignik Lagoon','AK',103,153),
        (733,'Pelahatchie','MS',38,28),
        (441,'Hanna,City','IL',50,136),
        (811,'Dorrance','KS',102,121),
        (698,'Albany','CA',49,80),
        (325,'Monument','KS',70,141),
        (414,'Manchester','MD',73,37),
        (113,'Prescott','IA',39,65),
        (971,'Graettinger','IA',94,150),
        (266,'Cahone','CO',116,127);



SELECT 
	city, 
        state 
FROM 
	station;


 Q.8 Query a list of CITY names from STATION for cities that have an even ID number. 
 Print the results in any order, but exclude duplicates from the answer.
->

SELECT 
	DISTINCT city
FROM
	station
WHERE
	id%2 = 0;


 Q.9 Find the difference between the total number of CITY entries in the table and the 
 number of distinct CITY entries in the table.

->

SELECT 
	(COUNT(city) -  COUNT(DISTINCT city)) AS difference
FROM 
	station;



 Q.10 Query the two cities in STATION with the shortest and longest CITY names, as well as their 
 respective lengths (i.e.: number of characters in the name). If there is more than one smallest 
 or largest city, choose the one that comes first when ordered alphabetically

->

(SELECT
	city, 
        Length(city) AS len
FROM 
	station
ORDER BY 
        Length(city), 
        city 
        LIMIT 1)

UNION ALL

(SELECT
	city, 
        Length(city) AS len
FROM 
	station
ORDER BY 
        Length(city) DESC, 
        city 
LIMIT 1);



 Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from station. 
 Your result cannot contain duplicates.

->


SELECT  
		DISTINCT city
FROM
		station        
WHERE 
        LEFT(city , 1) IN ('a','e','i','o','u'); 
       



 Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from station. 
 Your result cannot contain duplicates.
->


SELECT  
	DISTINCT city
FROM
	station        
WHERE 
        RIGHT(city , 1) IN ('a','e','i','o','u');




Q13. Query the list of CITY names from station that do not start with vowels. 
 Your result cannot contain duplicates.
->


SELECT  
	DISTINCT city
FROM
	station        
WHERE 
        LEFT(city , 1) NOT IN ('a','e','i','o','u');



 Q14. Query the list of CITY names from station that do not end with vowels. 
 Your result cannot contain duplicates.
->

SELECT  
	DISTINCT city
FROM
	station        
WHERE 
        RIGHT(city , 1) NOT IN ('a','e','i','o','u');




 Q15. Query the list of CITY names from station that either do not start with vowels or 
 do not end with vowels. Your result cannot contain duplicates.
->

SELECT 
	DISTINCT city 
FROM 
	station 
WHERE 
		SUBSTR(city,1,1) NOT IN ('A','E','I','O','U') 
        OR
		SUBSTR(city,-1,1) NOT IN ('A','E','I','O','U');
        
        


 Q16. Query the list of CITY names from station that do not start with vowels and 
 do not end with vowels. Your result cannot contain duplicates.
->

SELECT 
	DISTINCT city 
FROM 
	station 
WHERE 
	SUBSTR(city,1,1) NOT IN ('A','E','I','O','U') 
        AND 
        SUBSTR(city,-1,1) NOT IN ('A','E','I','O','U');
        



 Q.17 Write an SQL query that reports the products that were only sold in the first quarter of 2019. 
 That is, between 2019-01-01 and 2019-03-31 inclusive. Return the result table in any order.


CREATE TABLE product(
        product_id INT,
        product_name VARCHAR(20),
        unit_price INT,
        CONSTRAINT prime_key PRIMARY KEY(product_id)
	);


INSERT INTO product VALUES
        (1,'S8',1000),
        (2,'G4',800),
        (3,'iPhone',1400);


CREATE TABLE sales(
        seller_id INT,
        product_id INT,
        buyer_id INT,
        sales_date DATE,
        quantity INT,
        price INT,
        CONSTRAINT foriegn_key FOREIGN KEY(product_id) REFERENCES product(product_id)       
	);


INSERT INTO sales VALUES
        (1,1,1,'2019-01-21',2,2000),
        (1,2,2,'2019-02-17',1,800),
        (2,2,3,'2019-06-02',1,800),
        (3,3,4,'2019-05-13',2,2800);


->

SELECT 
	p.product_id,
        p.product_name
FROM
	product p
INNER JOIN 
	sales s 
ON
	p.product_id = s.product_id
WHERE 
	p.product_id 
NOT IN (
	SELECT 
	product_id
	FROM 
	sales
	WHERE
	sales_date > '2019-03-31'
        )
GROUP BY 	
	p.product_id
HAVING 
	MAX(s.sales_date) <='2019-03-31' 
        AND 
        MIN(s.sales_date) >='2019-01-01';



 Q.18 Write an SQL query to find all the authors that viewed at least one of their own articles. 
 Return the result table sorted by id in ascending order.


CREATE TABLE views(
        article_id INT,
        author_id INT,
        viewer_id INT,
        view_date DATE
        
	);


INSERT INTO views VALUES
        (1,3,5,'2019-08-01'),
        (1,3,6,'2019-08-02'),
        (2,7,7,'2019-08-01'),
        (2,7,6,'2019-08-02'),
        (4,7,1,'2019-08-22'),
        (3,4,4,'2019-07-21'),
        (3,4,4,'2019-07-21');

->

SELECT 
	DISTINCT a.author_id
FROM 
	views a
JOIN   
	views v
ON 
	a.author_id = v.viewer_id
ORDER BY 
	a.author_id;



 Q.19 Write an SQL query to find the percentage of immediate orders in the table, 
 rounded to 2 decimal places.


CREATE TABLE delivery(
        delivery_id INT,
        customer_id INT,
        order_date DATE,
        customer_preferred_delivery_date DATE
        
	);


INSERT INTO delivery VALUES
        (1,1,'2019-08-01','2019-08-02'),
        (2,5,'2019-08-02','2019-08-02'),
        (3,1,'2019-08-11','2019-08-11'),
        (4,3,'2019-08-24','2019-08-26'),
        (5,4,'2019-08-21','2019-08-22'),
        (6,2,'2019-07-11','2019-08-13');



SELECT 
	ROUND(immediate_orders * 100 / total_orders, 2) AS immediate_orders_perct
FROM 
	(
        SELECT 
	COUNT(
              CASE 
              WHEN order_date = customer_preferred_delivery_date 
              THEN customer_id
              END
		) 	AS immediate_orders, 
				    COUNT(delivery_id) AS total_orders
		    FROM 
		        delivery
		) temp ;



 Q.20 Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.
 Return the result table ordered by ctr in descending order and by ad_id in 
 ascending order in case of a tie.


CREATE TABLE ads(
        ad_id INT,
        user_id INT,
        action ENUM('CLICKED','viewED','IGNORED'),
        CONSTRAINT prime_key PRIMARY KEY(ad_id, user_id)        
	);


INSERT INTO ads VALUES
        (1,1,'CLICKED'),
        (2,2,'CLICKED'),
        (3,3,'VIEWED'),
        (5,5,'IGNORED'),
        (1,7,'IGNORED'),
        (2,7,'VIEWED'),
        (3,5,'CLICKED'),
        (1,4,'VIEWED'),
        (2,11,'VIEWED'),
        (1,2,'CLICKED');

->

SELECT 
	ad_id,
        CASE 
            WHEN (num_of_clicks * 100) / (num_of_clicks + num_of_views) IS NULL THEN 0
            ELSE ROUND((num_of_clicks * 100) / (num_of_clicks + num_of_views), 2)
            END AS ctr 
FROM 
	(
	    SELECT 
	    ad_id,
		COUNT(
			CASE 
			WHEN action = 'CLICKED' THEN ad_id
			END
			) 	AS num_of_clicks, 
			COUNT(
				CASE WHEN action = 'VIEWED' THEN ad_id
				END
				) 	AS num_of_views
			FROM 
				ads
			GROUP BY 
				ad_id
		)	temp_ads
ORDER BY
		ctr DESC,
		ad_id ASC;

 Q.21 Write an SQL query to find the team size of each of the employees.


CREATE TABLE employee(
		employee_id INT,
		team_id INT,
		CONSTRAINT prime_key PRIMARY KEY(employee_id)        
	);


INSERT INTO employee VALUES
        (1,8),
        (2,8),
        (3,8),
        (4,7),
        (5,9),
        (6,9);

->

SELECT 
	employee_id, 
	COUNT(employee_id) OVER(PARTITION BY team_id) AS team_size
FROM
	employee
ORDER BY 
	employee_id;



 Q.22 Write an SQL query to find the type of weather in each country for November 2019. The type of weather is:
 ● Cold if the average weather_state is less than or equal 15,
 ● Hot if the average weather_state is greater than or equal to 25, and
 ● Warm otherwise.
 Return result table in any order.


CREATE TABLE countries(
        country_id INT,
        country_name VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(country_id)
	);


INSERT INTO countries VALUES
        (2, 'USA'),
        (3, 'AUSTRALIA'),
        (7, 'PERU'),
        (5, 'CHINA'),
        (8, 'MOROCCO'),
        (9, 'SPAIN');


CREATE TABLE weather(
        country_id INT,
        weather_state INT,
        day DATE,
        CONSTRAINT prime_key PRIMARY KEY(country_id, day) 
	);


INSERT INTO weather VALUES
        (2,15,'2019-11-01'),
        (2,12,'2019-10-28'),
        (2,12,'2019-10-27'),
        (3,-2,'2019-11-10'),
        (3,0,'2019-11-11'),
        (3,3,'2019-11-12'),
        (5,16,'2019-11-07'),
        (5,18,'2019-10-09'),
        (5,21,'2019-10-23'),
        (7,25,'2019-11-08'),
        (7,22,'2019-12-01'),
        (7,20,'2019-12-02'),
        (8,25,'2019-11-05'),
        (8,27,'2019-11-15'),
        (8,31,'2019-11-25'),
        (9,7,'2019-10-23'),
        (9,3,'2019-12-23');

->

SELECT 
        c.country_name,
        CASE
			WHEN AVG(weather_state) <= 15 THEN 'COLD'
			WHEN AVG(weather_state) >= 25 THEN 'HOT'
			ELSE 'WARM'
			END AS avg_weather
FROM 
countries c
INNER JOIN 
weather w
ON 
c.country_id = w.country_id
WHERE 
day BETWEEN '2019-11-01' AND '2019-11-30'
GROUP BY 
c.country_id,
c.country_name; 



 Q.23 Write an SQL query to find the average selling price for each product. 
 average_price should be rounded to 2 decimal places.


CREATE TABLE prices(
        product_id INT,
        start_date DATE,
        end_date DATE,
        price INT,
        CONSTRAINT prime_key PRIMARY KEY(product_id, start_date, end_date)
	);


INSERT INTO prices VALUES
        (1,'2019-02-17','2019-02-28',5),
        (1,'2019-03-01','2019-03-22',20),
        (2,'2019-02-01','2019-02-20',15),
        (2,'2019-02-21','2019-03-31',30);


CREATE TABLE units_sold(
        product_id INT,
        purchase_date DATE,
        units INT
	);


INSERT INTO units_sold VALUES
        (1,'2019-02-25',100),
        (1,'2019-03-01',15),
        (2,'2019-02-10',200),
        (2,'2019-02-22',30);

->

SELECT 
	p.product_id,
        ROUND(SUM(p.price * u.units)/SUM(u.units), 2) AS average_price
FROM 
	units_sold u
INNER JOIN
	prices p
ON 
	p.product_id = u.product_id
WHERE 	
	u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY 
	p.product_id;



 Q.24 Write an SQL query to report the first login date for each player. 
 Return the result table in any order.


CREATE TABLE activity(
        player_id INT,
        device_id INT,
        event_date DATE,
        games_played INT,
        CONSTRAINT prime_key PRIMARY KEY(player_id, event_date)
	);


INSERT INTO activity VALUES 
        (1,2,'2016-03-01',5),
        (1,2,'2016-03-02',6),
        (2,3,'2017-06-25',1),
        (3,1,'2016-03-02',0),
        (3,4,'2018-07-03',5);

->

WITH temp_activity AS (
			SELECT 
			player_id,
		        event_date as first_login,
			ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) as ranking
			FROM
			activity
				)
            
SELECT 
	player_id,
        first_login
FROM 
	temp_activity
WHERE
	ranking = 1;


 Q.25 Write an SQL query to report the device that is first logged in for each player. 
 Return the result table in any order.
->

WITH temp_activity AS (
			SELECT 
			player_id,
			device_id,
			ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY device_id) ranking
			FROM
			activity
				)
            
SELECT 
	player_id,
        device_id
FROM 
	temp_activity
WHERE
	ranking = 1;



 Q.26 Write an SQL query to get the names of products that have at least 100 units 
 ordered in February 2020 and their amount.


CREATE TABLE products(
        product_id INT,
        product_name VARCHAR(30),
        product_category VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(product_id)
	);


INSERT INTO products VALUES
        (1,'LEETCODE SOLUTIONS','BOOK'),
        (2,'JEWELS OF STRINGOLOGY','BOOK'),
        (3,'HP','LAPTOP'),
        (4,'LENOVO','LAPTOP'),
        (5,'LEETCODE KIT','T-SHIRT');


CREATE TABLE orders(
        product_id INT,
        order_date DATE,
        unit INT,
        CONSTRAINT foriegn_key FOREIGN KEY(product_id) REFERENCES products(product_id)
	);


INSERT INTO orders VALUES
        (1,'2020-02-05',60),
        (1,'2020-02-05',70),
        (2,'2020-01-05',30),
        (2,'2020-02-05',80),
        (3,'2020-02-05',2),
        (3,'2020-02-05',3),
        (4,'2020-03-05',20),
        (4,'2020-03-05',30),
        (4,'2020-03-05',60),
        (5,'2020-02-05',50),
        (5,'2020-02-05',50),
        (5,'2020-03-05',50);

->

SELECT 
	p.product_name,
        SUM(o.unit) AS total_unit_sold
FROM 
	products p
INNER JOIN
	orders o
ON 
	p.product_id = o.product_id
WHERE 
	order_date BETWEEN '2020-02-01' AND '2020-02-28'
GROUP BY
	p.product_id
HAVING 
	SUM(o.unit) >= 100;



 Q.27 Write an SQL query to find the users who have valid emails.


CREATE TABLE users(
		user_id INT,
		name VARCHAR(25),
		mail VARCHAR(25),
		CONSTRAINT prime_key PRIMARY KEY(user_id)
	);


INSERT INTO users VALUE 
        (1,'WINSTON','winston@leetcode.com'),
        (2,'JONATHAN','jonathonisgreat'),
        (3,'ANNABELLE','bella-@leetcode.com'),
        (4,'SALLY','sally.come@leetcode.com'),
        (5,'MARWAN','quarz-- 2020@leetcode.com'),
        (6,'DAVID','david45@gmail.com'),
        (7,'SHAPIRO','.shapo@leetcode.com');

->

SELECT
	user_id,
        name,
        mail
FROM
	users
WHERE
	mail LIKE '%@leetcode.com' AND mail REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*\\.[a-zA-Z]{2,4}$';



 Q.28 Write an SQL query to report the customer_id and customer_name of customers who have spent 
 at least $100 in each month of June and July 2020. Return the result table in any order.


CREATE TABLE customers(
        customer_id INT,
        name VARCHAR(20),
        country VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(customer_id)
	);


CREATE TABLE orders(
        order_id INT,
        customer_id INT,
        product_id INT,
        order_date DATE,
        quantity INT,
        CONSTRAINT prime_key PRIMARY KEY(order_id)
	);


CREATE TABLE products(
        product_id INT,
        description VARCHAR(20),
        price INT,
        CONSTRAINT prime_key PRIMARY KEY(product_id)
	);


INSERT INTO customers VALUES 
        (1,'WINSTON','USA'),
        (2,'JONATHON','PERU'),
        (3,'MOUSTAFA','EGYPT');


INSERT INTO products VALUES 
        (10,'LC PHONE',300),
        (20,'LC T-SHIRT',10),
        (30,'LC BOOK',45),
        (40,'LC KEYCHAIN',2);


INSERT INTO orders VALUES 
        (1,1,10,'2020-06-10',1),
        (2,1,20,'2020-07-01',1),
        (3,1,30,'2020-07-08',2),
        (4,2,10,'2020-06-15',2),
        (5,2,40,'2020-07-01',10),
        (6,3,20,'2020-06-24',2),
        (7,3,30,'2020-06-25',2),
        (9,3,30,'2020-05-08',3);

->

SELECT 
	customer_id,
	name
 FROM 
	(
	SELECT 
	c.customer_id,
        c.name,
	EXTRACT(MONTH FROM o.order_date) AS month_extracted,
	SUM(o.quantity * p.price) AS total_spent
	FROM 
	orders o
	INNER JOIN 
	customers c 
	ON 
	c.customer_id = o.customer_id
	INNER JOIN 
	products p
	ON 
        p.product_id = o.product_id
	WHERE 
	o.order_date BETWEEN '2020-06-01' AND '2020-07-31'
	GROUP BY 
	c.customer_id,
	c.name, 
        EXTRACT(MONTH FROM o.order_date)
        ) temp_customers
        
WHERE 
total_spent >= 100
GROUP BY 
customer_id
HAVING 
COUNT(customer_id) = 2;



 Q.29 Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020. 
 Return the result table in any order.


CREATE TABLE tv_program(
        program_date DATETIME,
        content_id INT,
        channel VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(program_date, content_id)
);


CREATE TABLE content(
        content_id INT,
        title VARCHAR(20),
        kids_content ENUM('Y','N'),
        content_type VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(content_id)
);


INSERT INTO content VALUES
        (1,'LEETCODE MOVIE', 'N','MOVIES'),
        (2,'ALG. FOR KidS', 'Y','SERIES'),
        (3,'DATABASE SOLS', 'N','SERIES'),
        (4,'ALADDIN', 'Y','MOVIES'),
        (5,'CINDERELLA', 'Y','MOVIES');
        

INSERT INTO tv_program VALUES
		('2020-06-10 18:00',1,'LC-channel'),
        ('2020-05-11 12:00',2,'LC-channel'),
        ('2020-05-12 12:00',3,'LC-channel'),
        ('2020-05-13 14:00',4,'DISNEY-CH'),
        ('2020-06-18 14:00',4,'DISNEY-CH'),
        ('2020-07-15 16:00',5,'DISNEY-CH');

->

SELECT 
DISTINCT c.title
FROM 
content c
INNER JOIN 
tv_program t
ON 
c.content_id = T.content_id
WHERE 
c.kids_content = 'Y' 
        AND 
        c.content_type = 'movies' 
        AND 
        T.program_date BETWEEN '2020-06-01' AND '2020-06-30';



 Q.30 Write an SQL query to find the npv of each query of the Queries table. 
 Return the result table in any order.



CREATE TABLE npv(
        id INT,
        year INT,
        npv INT,
        CONSTRAINT prime_key PRIMARY KEY(id, year)
	);


CREATE TABLE queries(
        id INT,
        year INT,
        CONSTRAINT prime_key PRIMARY KEY(id, year)
	);


INSERT INTO npv VALUES
        (1,2018,100),
        (7,2020,30),
        (13,2019,40),
        (1,2019,113),
        (2,2008,121),
        (3,2009,12),
        (11,2020,99),
        (7,2019,0);


INSERT INTO queries VALUES
        (1,2019),
        (2,2008),
        (3,2009),
        (7,2018),
        (7,2019),
        (7,2020),
        (13,2019);

->

SELECT 
	DISTINCT n.id,
	n.year,
        n.npv
FROM 
	queries q
INNER JOIN 
	npv n
ON 
	n.id = q.id 
        AND 
        n.year = q.year;



 Q.31 CREATE TABLE npv
(
  id INT,
  year INT,
  npv INT,
  CONSTRAINT pk_npv PRIMARY KEY(id, year)
);

CREATE TABLE queries
(
  id INT,
  year INT,
  CONSTRAINT pk_quereis PRIMARY KEY(id,year)
);

INSERT INTO npv VALUES(1, 2018, 100);
INSERT INTO npv VALUES(7, 2020, 30);
INSERT INTO npv VALUES(13, 2019, 40);
INSERT INTO npv VALUES(1, 2019, 113);
INSERT INTO npv VALUES(2, 2008, 121);
INSERT INTO npv VALUES(3, 2009, 12);
INSERT INTO npv VALUES(11, 2020, 99);
INSERT INTO npv VALUES(7, 2019, 0);

INSERT INTO queries VALUES(1, 2019);
INSERT INTO queries VALUES(2, 2008);
INSERT INTO queries VALUES(3, 2009);
INSERT INTO queries VALUES(7, 2018);
INSERT INTO queries VALUES(7, 2019);
INSERT INTO queries VALUES(7, 2020);
INSERT INTO queries VALUES(13, 2019);

->

SELECT 
  q.id,
  q.year, 
  ifnull(n.npv,0) as npv
FROM 
  queries AS q
  LEFT JOIN npv AS n ON q.id = n.id AND q.year = n.year
;




 Q.32 Write an SQL query to show the unique id of each user, If a user does not have a 
 unique id replace just show null. Return the result table in any order.


CREATE TABLE employees(
		id INT,
		name VARCHAR(20),
		CONSTRAINT prime_key PRIMARY KEY(id)
	);


CREATE TABLE employees_uni(
		id INT,
		unique_id INT,
		CONSTRAINT prime_key PRIMARY KEY(id, unique_id)
	);


INSERT INTO employees VALUES
		(1,'ALICE'),
		(7,'BOB'),
		(11,'MEIR'),
		(90,'WINSTON'),
		(3,'JONATHAN');


INSERT INTO employees_uni VALUES
		(3,1),
		(11,2),
		(90,3);

->

SELECT
	eu.unique_id,
        e.name
FROM 
	employees e
LEFT JOIN 
	employees_uni eu
ON 
	e.id = eu.id
ORDER BY 
	e.name;



 Q.33 Write an SQL query to report the distance travelled by each user. Return the result table ordered by travelled_distance 
 in descending order, if two or more users travelled the same distance, order them by their name in ascending order.


CREATE TABLE users(
		id INT,
		name VARCHAR(20),
		CONSTRAINT prime_key PRIMARY KEY(id)
	);


INSERT INTO users VALUES
		(1,'ALICE'),
		(2,'BOB'),
		(3,'ALEX'),
		(4,'DONALD'),
		(7,'LEE'),
		(13,'JONATHON'),
		(19,'ELVIS');


CREATE TABLE rides(
        id INT,
        user_id INT,
        distance INT,
        CONSTRAINT prime_key PRIMARY KEY(id)
	);


INSERT INTO rides VALUES
        (1,1,120),
        (2,2,317),
        (3,3,222),
        (4,7,100),
        (5,13,312),
        (6,19,50),
        (7,7,120),
        (8,19,400),
        (9,7,230);

->

SELECT
u.name AS riders,
COALESCE(SUM(r.distance), 0) AS distance_travelled
FROM 
users u
LEFT JOIN 
rides r
ON 
u.id = r.user_id
GROUP BY 
u.name
ORDER BY 
distance_travelled DESC, 
riders;



 Q.34 
->
SELECT 
	p.product_name,
        SUM(o.unit) AS total_unit_sold
FROM 
	products p
INNER JOIN
	orders o
ON 
	p.product_id = o.product_id
WHERE 
	order_date BETWEEN '2020-02-01' AND '2020-02-28'
GROUP BY
	p.product_id
HAVING 
	SUM(o.unit) >= 100;




 Q.35 Write an SQL query to:
 ● Find the name of the user who has rated the greatest number of movies. In case of a tie,
 return the lexicographically smaller user name.
 ● Find the movie name with the highest average rating in February 2020. In case of a tie, 
 return the lexicographically smaller movie name.


CREATE TABLE users(
		user_id INT,
		name VARCHAR(20),
		CONSTRAINT prime_key PRIMARY KEY(user_id)
	);


INSERT INTO users VALUES
		(1,'DANIEL'),
		(2,'MONICA'),
		(3,'MARIA'),
		(4,'JAMES');


CREATE TABLE movies(
		movie_id INT,
		title VARCHAR(20),
		CONSTRAINT prime_key PRIMARY KEY(movie_id)
	);


INSERT INTO movies VALUES
		(1,'AVENGERS'),
		(2,'FROZEN 2'),
		(3,'JOKER');


CREATE TABLE movie_rating(
		movie_id INT,
		user_id INT,
		rating INT,
		created_at DATE,
		CONSTRAINT prime_key PRIMARY KEY(movie_id, user_id)
	);


INSERT INTO movie_rating VALUES
		(1,1,3,'2020-01-12'),
		(1,2,4,'2020-02-11'),
		(1,3,2,'2020-02-12'),
		(1,4,1,'2020-01-01'),
		(2,1,5,'2020-02-17'),
		(2,2,2,'2020-02-01'),
		(2,3,2,'2020-03-01'),
		(3,1,3,'2020-02-22'),
		(3,2,4,'2020-02-25');



Q. Find the name of the user who has rated the greatest number of movies



SELECT 
	u.name as user
FROM 
	users u
INNER JOIN 
	movie_rating mr 
ON
	u.user_id = mr.user_id
GROUP BY 
	u.user_id
ORDER BY 
	COUNT(u.name) DESC,
        LENGTH(u.name)
LIMIT 1;



Q. Find the movie name with the highest average rating in February 2020.



SELECT 
        m.title
FROM 
	movies m
INNER JOIN 
	movie_rating mr 
ON
	m.movie_id = mr.movie_id
WHERE 
	mr.created_at BETWEEN '2020-02-01' AND '2020-02-28'
GROUP BY 
	m.movie_id
ORDER BY 
	AVG(rating) DESC,
        m.title
LIMIT 1;



 Q.36 

->

SELECT
u.name AS riders,
COALESCE(SUM(r.distance), 0) AS distance_travelled
FROM 
users u
LEFT JOIN 
rides r
ON 
u.id = r.user_id
GROUP BY 
u.name
ORDER BY 
distance_travelled DESC, 
riders;




 Q.37 
->

SELECT
	eu.unique_id,
        e.name
FROM 
	employees e
LEFT JOIN 
	employees_uni eu
ON 
	e.id = eu.id
ORDER BY 
	e.name;




 Q.38 Write an SQL query to find the id and the name of all students who are enrolled 
 in departments that no longer exist. Return the result table in any order.


CREATE TABLE departments(
		id INT,
		name VARCHAR(25),
		CONSTRAINT prime_key PRIMARY KEY(id)
	);


INSERT INTO departments VALUES
		(1,'ELECTRICAL ENGINEERING'),
		(7,'COMPUTER ENGINEERING'),
		(13,'BUSINESS ADMINISTRATION');


CREATE TABLE students(
		id INT,
		name VARCHAR(25),
		department_id INT,
		CONSTRAINT prime_key PRIMARY KEY(id)
	);


INSERT INTO students VALUES
		(23,'ALICE',1),
		(1,'BOB',7),
		(5,'JENNIFER',13),
		(2,'JOHN',14),
		(4,'JASMINE',77),
		(3,'STEVE',74),
		(6,'LUIS',1),
		(8,'JONATHON',7),
		(7,'DAIANA',33),
		(11,'MADELYNN',1);


->
SELECT
id,
name 
FROM 
students 
WHERE 
department_id NOT IN (
		     SELECT 
		     id 
		     FROM 
		     departments 
				);



 Q.39 Write an SQL query to report the number of calls and the total call duration between 
 each pair of distinct persons (person1, person2) where person1 < person2.
 Return the result table in any order.


CREATE TABLE calls(
		from_id INT,
		to_id INT,
		duration INT
	);


INSERT INTO calls VALUES
		(1,2,59),
		(2,1,11),
		(1,3,20),
		(3,4,100),
		(3,4,200),
		(3,4,200),
		(4,3,499);


->


SELECT 
        least(from_id, to_id) AS person1,
        greatest(from_id,to_id) AS person2,
        COUNT(*) AS call_count,
        SUM(duration) AS total_duration
FROM 
		calls
GROUP BY 
		person1, 
        person2;



 Q.40

->

SELECT 
	p.product_id,
        ROUND(SUM(p.price * u.units)/SUM(u.units), 2) AS average_price
FROM 
	units_sold u
INNER JOIN
	prices p
ON 
	p.product_id = u.product_id
WHERE 	
	u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY 
	p.product_id;




 Q.41 Write an SQL query to report the number of cubic feet of volume the inventory 
 occupies in each warehouse. Return the result table in any order.


CREATE TABLE warehouse(
		name VARCHAR(25),
		product_id INT,
		units INT,
		CONSTRAINT prime_key PRIMARY KEY(name,product_id)
	);


INSERT INTO warehouse VALUES
		('LCHOUSE1',1,1),
		('LCHOUSE1',2,10),
		('LCHOUSE1',3,5),
		('LCHOUSE2',1,2),
		('LCHOUSE2',2,2),
		('LCHOUSE3',4,1);


CREATE TABLE products(
		product_id INT,
		product_name VARCHAR(25),
		width INT,
		length INT,
		height INT,
		CONSTRAINT prime_key PRIMARY KEY(product_id)
	);


INSERT INTO products VALUES
		(1,'LC-TV',5,50,40),
		(2,'LC-KEYCHAIN',5,5,5),
		(3,'LC-PHONE',2,10,10),
		(4,'LC-SHIRT',4,10,20);


->
SELECT
        w.name AS warehouse_name,
        SUM(p.length * p.width * p.height * w.units) AS volume
FROM 
        warehouse w
INNER JOIN 
        products p
ON 
        w.product_id = p.product_id
GROUP BY 
        w.name;



 Q.42 Write an SQL query to report the difference between the number of 
 apples and oranges sold each day. Return the result table ordered by sale_date.


CREATE TABLE sales(
		sale_date DATE,
		fruit ENUM('APPLES','ORANGES'),
		sold_num INT,
		CONSTRAINT prime_key PRIMARY KEY(sale_date,fruit)
	);


INSERT INTO sales VALUES
		('2020-05-01','APPLES',10),
		('2020-05-01','ORANGES',8),
		('2020-05-02','APPLES',15),
		('2020-05-02','ORANGES',15),
		('2020-05-03','APPLES',20),
		('2020-05-03','ORANGES',0),
		('2020-05-04','APPLES',15),
		('2020-05-04','ORANGES',16);
->

SELECT
	sale_date,
        SUM(
		CASE
		WHEN fruit = 'APPLES' THEN sold_num
		WHEN fruit = 'ORANGES' THEN -sold_num
		END 
		) AS difference
FROM 
	sales
GROUP BY 
	sale_date
ORDER BY 
	sale_date;




 Q.43 Write an SQL query to report the fraction of players that logged in again on the day after the day 
 they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players 
 that logged in for at least two consecutive days starting from their first login date, 
 then divide that number by the total number of players.


->

WITH temp_activity AS (
			SELECT 
			player_id,
			LEAD(event_date, 1) OVER(PARTITION BY player_id ORDER BY event_date)  - event_date  AS difference
			FROM 
			activity
			),

	temp_activity2 AS (
			   SELECT 
			   COUNT(DISTINCT player_id) AS players_count
			   FROM 	
			   temp_activity
			   WHERE 
			   difference = 1
			   GROUP BY 
			   player_id
			)

SELECT 
	ROUND(COUNT(*) / (SELECT COUNT(DISTINCT player_id) FROM activity), 2) AS fraction
FROM 
	temp_activity2


 Q.44 Write an SQL query to report the managers with at least five direct reports.


CREATE TABLE employee(
		id INT,
		name VARCHAR(20),
		department VARCHAR(20),
		manager_id INT,
		CONSTRAINT prime_key PRIMARY KEY(id)
	);


INSERT INTO employee VALUES 
		(101,'JOHN','A',NULL),
		(102,'DAN','A',101),
		(103,'JAMES','A',101),
		(104,'AMY','A',101),
		(105,'ANNE','A',101),
		(106,'RON','A',101),
		(107,'BUTTLER','A',111),
		(108,'JIMMY','A',121),
		(111,'ROOT','A',NULL),
		(121,'POPE','A',NULL);



->

SELECT 
	name 
FROM 
	employee 
WHERE 
	id = (
		SELECT 
		e.manager_id
		FROM 
		employee e
		INNER JOIN 
		employee ee
		ON 
		e.manager_id = ee.id
		GROUP BY 
		e.manager_id
		HAVING 
		COUNT(e.manager_id) >= 5
			);





 Q.45 Write an SQL query to report the respective department name and number of students majoring in 
 each department for all departments in the department table (even ones with no current students). 
 Return the result table ordered by student_number in descending order. In case of a tie, order 
 them by dept_name alphabetically


CREATE TABLE department(
		dept_id INT,
		department_name VARCHAR(20),
		CONSTRAINT prime_key PRIMARY KEY(dept_id)
	);


CREATE TABLE student(
		student_id INT,
		student_name VARCHAR(20),
		gender VARCHAR(6),
		dept_id INT,
		CONSTRAINT prime_key PRIMARY KEY(student_id),
		CONSTRAINT foriegn_key FOREIGN KEY(dept_id) REFERENCES department(dept_id)
	);


INSERT INTO department VALUES 
		(1,'ENGINEERING'),
		(2,'SCIENCE'),
		(3,'LAW');
        
        
INSERT INTO student VALUES 
		(1,'JACK','M',1),
		(2,'JANE','F',1),
		(3,'MARK','M',2);


->

SELECT 
	d.department_name,
	COUNT(s.student_id) AS number_of_students
FROM 
	department d
LEFT JOIN 
	student s
ON 
	d.dept_id = s.dept_id
GROUP BY 
	d.department_name
ORDER BY 
	number_of_students DESC,
        department_name;



 Q.46 Write an SQL query to report the customer ids from the Customer table that bought 
 all the products in the product table. Return the result table in any order.


CREATE TABLE customer(
		customer_id INT,
		product_key INT
	);


INSERT INTO customer VALUES 
		(1,5),
		(2,6),
		(3,5),
		(3,6),
		(1,6);


CREATE TABLE product(
		product_key INT,
		CONSTRAINT prime_key PRIMARY KEY(product_key)
	);


INSERT INTO product VALUES 
		(5),
		(6);

->

SELECT 
customer_id
FROM 
customer
GROUP BY 
customer_id
HAVING 
COUNT(DISTINCT product_key) = (
				SELECT 
				COUNT(DISTINCT product_key) 
				FROM 
				product
					);



 Q.47 Write an SQL query that reports the most experienced employees in each project. In case of a tie, 
 report all employees with the maximum number of experience years. Return the result table in any order.


CREATE TABLE employee(
		employee_id INT,
		name VARCHAR(20),
		experience_years INT,
		CONSTRAINT prime_key PRIMARY KEY(employee_id)
	);


CREATE TABLE project(
		project_id INT,
		employee_id INT,
		CONSTRAINT prime_key PRIMARY KEY(project_id, employee_id)
	);


INSERT INTO employee VALUES 
		(1,'KHALED',3),
		(2,'ALI',2),
		(3,'JOHN',3),
		(4,'DOE',2);


INSERT INTO project VALUES 
		(1,1),
		(1,2),
		(1,3),
		(2,1),
		(2,4);


->

SELECT 
project_id,
employee_id
FROM
	(
	 SELECT 
	 p.project_id, 
	 e.employee_id,
	 DENSE_RANK() OVER(PARTITION BY p.project_id ORDER BY e.experience_years DESC) AS ranking
	 FROM 
	 employee e
	 INNER JOIN 
	 project p
	 ON 
	 e.employee_id = p.employee_id
	 ) temp_employee
WHERE 
ranking = 1;



 Q.48 Write an SQL query that reports the books that have sold less than 10 copies in the last year, 
 excluding books that have been available for less than one month from today. Assume today is 2019-06-23.
 Return the result table in any order.


CREATE TABLE books(
		book_id INT,
		name VARCHAR(20),
		available_from DATE,
		CONSTRAINT prime_key PRIMARY KEY(book_id)
	);
    
    
CREATE TABLE orders(
		order_id INT,
		book_id INT,
		quantity INT,
		dispatch_date DATE,
		CONSTRAINT prime_key PRIMARY KEY(order_id),
		CONSTRAINT foriegn_key FOREIGN KEY(book_id) REFERENCES books(book_id)
	);


INSERT INTO books VALUES 
		(1,"Kalila And Demna",'2010-01-01'),
		(2,"28 Letters",'2012-05-12'),
		(3,"The Hobbit",'2019-06-10'),
		(4,"13 Reasons Why",'2019-06-01'),
		(5,"The Hunger Games",'2008-09-21');


INSERT INTO orders VALUES 
		(1,1,2,'2018-07-26'),
		(2,1,1,'2018-11-05'),
		(3,3,8,'2019-06-11'), 
		(4,4,6,'2019-06-05'), 
		(5,4,5,'2019-06-20'), 
		(6,5,9,'2009-02-02'), 
		(7,5,8,'2010-04-13');

->

SELECT 
b.book_id, b.name
FROM 
books b
LEFT JOIN 
orders o
ON 
b.book_id = o.book_id 
WHERE 
available_from < '2019-05-23' 
AND 
(o.dispatch_date BETWEEN '2018-06-23' AND '2019-06-23')
		OR 
        dispatch_date IS NULL
GROUP BY  
	b.book_id,
        b.name
HAVING 
	COALESCE(SUM(o.quantity), 0) < 10;



 Q.49 Write a SQL query to find the highest grade with its corresponding course for each student. 
 In case of a tie, you should find the course with the smallest course_id. Return the result table 
 ordered by student_id in ascending order.


CREATE TABLE enrollments(
		student_id INT,
		course_id INT,
		grade INT,
		CONSTRAINT prime_key PRIMARY KEY(student_id,course_id)
    );


INSERT INTO enrollments VALUES 
		(2,2,95),
		(2,3,95),
		(1,1,90),
		(1,2,99),
		(3,1,80),
		(3,2,75),
		(3,3,82);
        
              
->

SELECT 
        student_id, 
        course_id, 
        grade 
FROM 
        (
            SELECT 
                    student_id, 
                    course_id, 
                    grade, 
                    ROW_NUMBER() OVER(PARTITION BY student_id ORDER BY grade DESC) AS ranking
            FROM 
                    enrollments
        ) temp_enrollments
WHERE 
        ranking = 1
order by 
        student_id;
        


 Q.50 Write an SQL query to find the winner in each group. Return the result table in any order.


CREATE TABLE matches(
		match_id INT,
		first_player INT,
		second_player INT,
		first_player_goals INT,
		second_player_goals INT,
		CONSTRAINT prime_key PRIMARY KEY(match_id)
	);


CREATE TABLE players(
		player_id INT,
		group_id INT,
		CONSTRAINT prime_key PRIMARY KEY(player_id)
    );


INSERT INTO matches VALUES 
		(1,15,45,3,0),
		(2,30,25,1,2),
		(3,30,15,2,0),
		(4,40,20,5,2),
		(5,35,50,1,1);


INSERT INTO players VALUES 
		(15,1),
		(25,1),
		(30,1),
		(45,1),
		(10,2),
		(35,2),
		(50,2),
		(20,3),
		(40,3);



SELECT 
	group_id,
	players as player_id
FROM 	(
	SELECT 
	p.group_id, 
	CASE
	WHEN first_player_goals > second_player_goals THEN first_player
	WHEN first_player_goals < second_player_goals THEN second_player
	WHEN first_player_goals = second_player_goals THEN IF(first_player < second_player, first_player, second_player)
	END AS players,
	MAX(IF(first_player_goals > second_player_goals, first_player_goals, second_player_goals)) AS goals,
	ROW_NUMBER() OVER(PARTITION BY team_id ORDER BY MAX(IF(first_player_goals > second_player_goals, first_player_goals, second_player_goals)) DESC) AS ranking
	FROM 
	players p
	INNER JOIN 
	matches m
	ON 
	m.first_player = p.player_id 
					OR 
					m.second_player = p.player_id
			                GROUP BY 
					p.group_id,
					players
	) temp_matches
WHERE 
	ranking = 1;


