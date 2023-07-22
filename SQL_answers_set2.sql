 Q.51 Write an SQL Query to report the name, population, and area of the big countries. 
 Return the result table in any order . 


CREATE TABLE world(
	name VARCHAR(20) NOT NULL,
	continent VARCHAR(15) NOT NULL,
	area INT NOT NULL,
	population BIGINT NOT NULL,
	gdp BIGINT NOT NULL,
	CONSTRAINT prime_key PRIMARY KEY(name)
	);


INSERT INTO world VALUES 
	('Afghanistan', 'Asia', 652230, 25500100, 203430000000),
        ('Albania', 'Europe', 28748, 2831741, 12960000000),
        ('Algeria', 'Africa', 2381741, 37100000, 188681000000),
        ('Andorra', 'Europe', 468, 78115, 3712000000),
        ('Angola', 'Africa', 1246700, 20609294, 100990000000),
        ('Dominican Republic', 'Caribbean', 48671, 9445281, 58898000000),
        ('China', 'Asia', 652230, 1365370000, 8358400000000),
        ('Colombia', 'South America', 1141748, 47662000, 369813000000),
        ('Comoros', 'Africa', 1862, 743798, 616000000),
        ('Denmark', 'Europe', 43094, 5634437, 314889000000),
        ('Djibouti', 'Africa', 23200, 886000, 1361000000),
        ('Dominica', 'Caribbean', 751, 71293, 499000000),
	('SriLanka', 'Asia', 652230, 25500100, 203430000000);
        
->        

SELECT 
        name, 
        population, 
        area 
FROM 
        world 
WHERE 
        area > 3000000 
        OR 
        population > 25000000;



 Q.52 Write an SQL Query to report the names of the customer that are not referred by the customer with id = 2.
 Return the result table in any order.


CREATE TABLE customer(
	id INT,
	name VARCHAR(10),
	refree_id INT,
	CONSTRAINT prime_key PRIMARY KEY(id)
	);
    

INSERT INTO customer VALUES 
	(1,'Will',NULL),
	(2,'Jane',NULL),
	(3,'Alex',2),
	(4,'Bill',NULL),
	(5,'Zack',1),
	(6,'Mark',2);



SELECT 
        name 
FROM 
        customer 
WHERE 
        refree_id <> 2
        OR
        refree_id IS NULL;



 Q.53 Write an SQL Query to report all customers who never order anything. 
 Return the result table in any order .


CREATE TABLE orders(
        id INT,
        customer_id INT,
        CONSTRAINT prime_key PRIMARY KEY(id)
    );


INSERT INTO orders VALUES 
        (1,3),
        (2,1);


CREATE TABLE customers(
        id INT,
        name VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(id)
    );


INSERT INTO customers VALUES 
        (1,'JOE'),
        (2,'HENRY'),
        (3,'SAM'),
        (4,'MAX');

->

SELECT 
        name AS customers
FROM 
        customers
WHERE 
        id NOT IN (
			SELECT 
			customer_id 
			FROM 
			orders
		);



 Q.54 Write an SQL Query to find the team size of each of the employees. 
 Return result table in any order .


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
        COUNT(employee_id) OVER(PARTITION BY team_id ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS team_size
FROM 
        employee
ORDER BY 
        employee_id;



 Q.55 Write an SQL Query to find the countries where this company can invest .
 Return the result table in any order .


CREATE TABLE person(
        id INT,
        name VARCHAR(20),
        phone_number VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(id)
    );


CREATE TABLE country(
        name VARCHAR(20),
        country_code VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(country_code)
    );


CREATE TABLE calls(
        caller_id INT,
        callee_id INT,
        duration INT
    );


INSERT INTO person VALUES 
        (3,'JONATHON','051-1234567'),
        (21,'ELVIS','051-7654321'),
        (1,'MONCEF','212-1234567'),
        (2,'MAROUA','212-6523651'),
        (7,'MEIR','972-1234567'),
        (9,'RACHEL','972-0011100');


INSERT INTO calls VALUES 
        (1,9,33),
        (1,2,59),
        (3,12,102),
        (3,12,330),
        (12,3,5),
        (7,9,13),
        (7,1,3),
        (9,7,1),
        (1,7,7),
        (2,9,4);


INSERT INTO country VALUES 
        ('PERU','51'),
        ('ISRAEL','972'),
        ('MOROCCO','212'),
        ('GERMANY','49'),
        ('ETHIOPIA','251');

->

SELECT 
name AS country
FROM 	(
	SELECT 
	c.name, 
	SUM(ca.duration) AS call_duration, 
	COUNT(c.country_code) AS number_of_calls
	FROM (
	      SELECT 
				id, 
				name,
				CASE
				WHEN LEFT(SUBSTR(phone_number, 1,3),1) = '0' THEN RIGHT(SUBSTR(phone_number, 1,3), (LENGTH(SUBSTR(phone_number, 1,3))-1)) 
				ELSE SUBSTR(phone_number, 1,3) END AS country_code 
	      FROM 
	      person
		    ) temp_person
JOIN 
country c
ON 
temp_person.country_code = c.country_code
JOIN 
calls ca
ON 
temp_person.id = caller_id
GROUP BY 
c.name


UNION ALL



SELECT 
	c.name,
        SUM(ca.duration) AS call_duration, 
        COUNT(c.country_code) AS number_of_calls
FROM 	(
		SELECT 
			id, 
			name,
			CASE
			WHEN LEFT(SUBSTR(phone_number, 1,3),1) = '0' THEN RIGHT(SUBSTR(phone_number, 1,3), (length(SUBSTR(phone_number, 1,3))-1)) 
			ELSE SUBSTR(phone_number, 1,3) END AS country_code 
		FROM 
		person
	) 	temp_person
JOIN 
country c
ON 
temp_person.country_code = c.country_code
JOIN 
calls ca
ON 
temp_person.id = ca.callee_id
GROUP BY 
c.name 
        
	) temp

GROUP BY 
name 
HAVING 
SUM(call_duration)/SUM(number_of_calls) >  (SELECT AVG(duration) FROM calls);



 Q.56 Write an SQL Query to report the device that is first logged in for each player. 
- Return the result table in any order.


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
        
SELECT 
        player_id,
        device_id 
FROM 
        (
            SELECT 
                    player_id, 
                    device_id, 
                    event_date, 
                    ROW_number() OVER(PARTITION BY player_id ORDER BY event_date) ranking 
            FROM 
            activity
        ) temp_activity
WHERE 
        ranking = 1;



 Q.57 Write an SQL Query to find the customer_number for the customer who has placed the largest number of orders.


CREATE TABLE orders(
        order_number INT,
        customer_number INT,
        CONSTRAINT prime_key PRIMARY KEY(order_number)
    );


INSERT INTO orders VALUES
        (1,1),
        (2,2),
        (3,3),
        (4,3);



WITH temp_orders AS (
			SELECT 
				DISTINCT customer_number, 
				DENSE_RANK() OVER(ORDER BY total_orders DESC) AS ranking 
			FROM ( 
				SELECT  
        				customer_number, 
					COUNT(order_number) OVER(PARTITION BY customer_number) total_orders
				FROM 
				orders
			)   temp_cust_details
		)

SELECT  
	customer_number
FROM 
        temp_orders
WHERE 
        ranking = 1;



 Q.58 Write an SQL Query to report all the consecutive available seats in the cinema.
 Return the result table ordered by seat_id in ascending order.


CREATE TABLE cinema(
        seat_id INT AUTO_INCREMENT,
        free BOOLEAN,
        CONSTRAINT prime_key PRIMARY KEY(seat_id)
    );


INSERT INTO cinema (free) VALUES 
        (1),(0),(1),(1),(1),(1),(0),(1),
        (1),(0),(1),(1),(1),(0),(1),(1);

->

SELECT 
        DISTINCT c1.seat_id 
FROM 
        cinema c1
INNER JOIN 
cinema c2
ON 
ABS(c1.seat_id - c2.seat_id) = 1
AND 
(c1.free = 1 AND c2.free = 1)
ORDER BY 
c1.seat_id;



 Q.59 Write an SQL Query to report the names of all the salespersons who did not have any 
 orders related to the company with the name "RED".


CREATE TABLE sales_person(
        sales_id INT,
        name VARCHAR(20),
        salary INT,
        commission_rate INT,
        hire_date VARCHAR(25),
        CONSTRAINT prime_key PRIMARY KEY(sales_id)
    );


INSERT INTO sales_person VALUES
        (1,'JOHN',100000,6,'4/1/2006'),
        (2,'AMY',12000,5,'5/1/2010'),
        (3,'MARK',65000,12,'12/25/2008'),
        (4,'PAM',25000,25,'1/1/2005'),
        (5,'ALEX',5000,10,'2/3/2007');


CREATE TABLE company(
        company_id INT,
        name VARCHAR(20),
        city VARCHAR(10),
        CONSTRAINT prime_key PRIMARY KEY(company_id)
    );


INSERT INTO company VALUES
        (1,'RED','BOSTON'),
        (2,'ORANGE','NEW YORK'),
        (3,'YELLOW','BOSTON'),
        (4,'GREEN','AUSTIN');


CREATE TABLE orders(
        order_id INT,
        order_date VARCHAR(30),
        company_id INT,
        sales_id INT,
        amount INT,
        CONSTRAINT prime_key PRIMARY KEY(order_id),
        CONSTRAINT company_foreign_key FOREIGN KEY (company_id) REFERENCES company(company_id),
        CONSTRAINT sales_foreign_key FOREIGN KEY (sales_id) REFERENCES sales_person(sales_id)
    );


INSERT INTO orders VALUES
        (1,'1/1/2014',3,4,10000),
        (2,'2/1/2014',4,5,5000),
        (3,'3/1/2014',1,1,50000),
        (4,'4/1/2014',1,4,25000);

->

SELECT 
name 
FROM 
sales_person
WHERE 
        sales_id NOT IN (
                            SELECT 
                            o.sales_id
                            FROM 
                            orders o
                            INNER JOIN 
                            company c 
                            ON 
                            c.company_id = o.company_id
                            WHERE 
                            c.name = 'RED'
                        );



 Q.60 Write an SQL Query to report for every three line segments whether they can form a triangle. 
 Return the result table in any order.


CREATE TABLE triangle(
        x INT,
        y INT,
        z INT,
        CONSTRAINT prime_key PRIMARY KEY(x,y,z)
    );


INSERT INTO triangle VALUES
        (13,15,30),
        (10,20,15);

->

SELECT 
        x,
        y,
        z, 
        IF(x+y>z AND x+z>y AND y+z>x, 'YES','NO') AS is_triangle
FROM 
        triangle;



 Q.61 Write an SQL Query to report the shortest distance between any two points from the Point table.


CREATE TABLE point(
        x INT,
        CONSTRAINT prime_key PRIMARY KEY(x)
    );


INSERT INTO point VALUES
        (-1),
        (0),
        (2);


->

SELECT 
        MIN(ABS(c1.x - c2.x)) AS shortest_distance
FROM 
        point c1
INNER JOIN 
        point c2
WHERE 
        c1.x!=c2.x;



 Q.62 Write a SQL Query for a report that provides the pairs (actor_id, director_id) where the actor has 
 cooperated with the director at least three times. Return the result table in any order.


CREATE TABLE actor_director(
        actor_id INT,
        director_id INT,
        timestamp INT,
        CONSTRAINT prime_key PRIMARY KEY(timestamp)
    );


INSERT INTO actor_director VALUES 
        (1,1,0),
        (1,1,1),
        (1,1,2),
        (1,2,3),
        (1,2,4),
        (2,1,5),
        (2,1,6);

->

WITH temp_actor_director AS (
				SELECT 
					DISTINCT actor_id, 
					director_id, 
					DENSE_RANK() OVER(ORDER BY total_movies DESC) AS ranking 
				FROM ( 
					SELECT  
						actor_id, 
						director_id, 
						COUNT(actor_id) OVER(PARTITION BY  actor_id, director_id) AS total_movies
					FROM 
						actor_director                       
				) temp
		)

SELECT 
        actor_id, 
        director_id 
FROM 
        temp_actor_director
WHERE 
        ranking = 1;



 Q.63 Write an SQL Query that reports the product_name, year, and price for each sale_id in
 the sales table. Return the resulting table in any order.


CREATE TABLE sales(
        sale_id INT,
        product_id INT,
        year INT,
        Quantity INT,
        price INT,
        CONSTRAINT prime_key PRIMARY KEY(sale_id, year)
    );


CREATE TABLE product(
        product_id INT,
        product_name VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(product_id)
    );


INSERT INTO sales VALUES 
        (1,100,2008,10,5000),
        (2,100,2009,12,5000),
        (7,200,2011,15,9000);


INSERT INTO product VALUES
        (100,'NOKIA'),
        (200,'APPLE'),
        (300,'SAMSUNG');

->

SELECT 
        p.product_name,
        s.year,
        s.price
FROM 
        sales s
INNER JOIN 
        product p
ON 
        p.product_id = s.product_id;



 Q.64 Write an SQL Query that reports the average experience years of all the employees for each project, 
 rounded to 2 digits. Return the result table in any order.


CREATE TABLE project(
        project_id INT,
        employee_id INT,
        CONSTRAINT prime_key PRIMARY KEY(project_id, employee_id)
    );


INSERT INTO project VALUES 
        (1,1),
        (1,2),
        (1,3),
        (2,1),
        (2,4);


CREATE TABLE employee(
        employee_id INT,
        name VARCHAR(20),
        experience_years INT,
        CONSTRAINT prime_key PRIMARY KEY(employee_id)
    );


INSERT INTO employee VALUES 
        (1,'KHALED',3),
        (2,'ALI',2),
        (3,'JOHN',1),
        (4,'DOE',2);


->

SELECT 
        p.project_id, 
        ROUND(AVG(experience_years), 2) AS average_years
FROM 
        employee e
INNER JOIN 
        project p
ON 
        p.employee_id = e.employee_id
GROUP BY 
        project_id;



 Q.65 Write an SQL Query that reports the best seller by total sales price, If there is a tie, 
 report them all. Return the result table in any order.


CREATE TABLE product(
        product_id INT,
        product_name VARCHAR(20),
        unit_price INT,
        CONSTRAINT prime_key PRIMARY KEY(product_id)
    );


INSERT INTO product VALUES 
        (1,'S8',1000),
        (2,'G4',800),
        (3,'Iphone',1400);


CREATE TABLE sales(
        seller_id INT,
        product_id INT,
        buyer_id INT,
        sale_date DATE,
        quantity INT,
        price INT,
        CONSTRAINT FOREIGN_KEY FOREIGN KEY(product_id) REFERENCES product(product_id)
    );


INSERT INTO sales VALUES 
        (1,1,1,'2019-01-21',2,2000),
        (1,2,2,'2019-01-21',1,800),
        (2,2,3,'2019-01-21',1,800),
        (3,3,4,'2019-01-21',2,2800);

->

WITH temp_sales AS (
                SELECT 
                        seller_id, 
                        total_price, 
                        DENSE_RANK() OVER (ORDER BY total_price DESC) ranking
                FROM
                    (
                        SELECT 
                                s.seller_id, 
                                SUM(s.quantity*p.unit_price) AS total_price
                        FROM 
                                sales s
                        INNER JOIN 
                                product p
                        ON 
                            p.product_id = s.product_id
                        GROUP BY 
                                seller_id
                    ) temp
             )


SELECT 
        seller_id 
FROM 
        temp_sales 
WHERE 
        ranking = 1;



 Q.66 Write an SQL Query that reports the buyers who have bought S8 but not iphone. Note that S8 and iphone 
 are products present in the product table. Return the result table in any order.


-- Same input table as for previous question i.e. 65


->

SELECT 
        s.buyer_id
FROM 
	sales s
INNER JOIN 
	product p
ON
	p.product_id = s.product_id
WHERE 
	p.product_name = 'S8' 
        AND 
        s.buyer_id NOT IN (
                                SELECT 
				        s.buyer_id 
                                FROM 
					sales S 
                                INNER JOIN 
					product P 
				ON 
					s.product_id = p.product_id 
                                WHERE 
					p.product_name = 'Iphone'
			);



 Q.67 Write an SQL Query to compute the moving average of how much the customer paid in a seven days window 
 (i.e., current day + 6 days before). average_amount should be rounded to two decimal places. 
 Return result table ordered by visited_on in ascending order.


CREATE TABLE customer(
	customer_id INT,
	name VARCHAR(20),
	visited_on DATE,
	amount INT,
	CONSTRAINT PRIMARY_KEY PRIMARY KEY(customer_id,visited_on)
	);


INSERT INTO customer VALUES 
	(1,'JOHN','2019-01-01',100),
	(2,'DANIEL','2019-01-02',110),
	(3,'JADE','2019-01-03',120),
	(4,'KHALED','2019-01-04',130),
	(5,'WINSTON','2019-01-05',110),
	(6,'ELVIS','2019-01-06',140),
	(7,'ANNA','2019-01-07',150),
	(8,'MARIA','2019-01-08',80),
	(9,'JAZE','2019-01-09',110),
	(1,'JOHN','2019-01-10',130),
	(3,'JADE','2019-01-10',150);

->

WITH temp_customer AS (
			SELECT 
				visited_on, 
				SUM(amount) AS amount
			FROM 
				customer
			GROUP BY 
				visited_on
		),

    temp_customer2 AS (
			SELECT 
			        visited_on, 
				SUM(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6  PRECEDING AND CURRENT ROW) AS weekly_amount, 
			        ROUND(AVG(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount,
			        DENSE_RANK() OVER(ORDER BY visited_on) as ranking
			FROM 
				temp_customer
		)

SELECT 
        visited_on, 
        weekly_amount, 
        average_amount 
FROM 
        temp_customer2
WHERE 
        ranking > 6;



 Q.68 Write an SQL Query to find the total score for each gender on each day.
 Return the result table ordered by gender and day in ascending order.


CREATE TABLE scores(
        player_name VARCHAR(20),
        gender VARCHAR(20),
        day DATE,
        score_points INT,
        CONSTRAINT prime_key PRIMARY KEY(gender,day)
    );


INSERT INTO scores VALUES
        ('ARON','F','2020-01-01',17),
        ('ALICE','F','2020-01-07',23),
        ('BAJRANG','M','2020-01-07',7),
        ('KHALI','M','2019-12-25',11),
        ('SLAMAN','M','2019-12-30',13),
        ('JOE','M','2019-12-31',3),
        ('JOSE','M','2019-12-18',2),
        ('PRIYA','F','2019-12-31',23),
        ('PRIYANKA','F','2019-12-30',17);

->

SELECT 
        gender, 
        day, 
        SUM(score_points) OVER(PARTITION BY gender ORDER BY day 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_points 
FROM 
        scores
order by 
	gender,
        day;



 Q.69 Write an SQL Query to find the start and end number of continuous ranges in the table logs. 
  Return the result table ordered by start_id.


CREATE TABLE logs(
        log_id INT,
        CONSTRAINT prime_key PRIMARY KEY(log_id)
    );


INSERT INTO logs VALUES
        (1),
        (2),
        (3),
        (7),
        (8),
        (10);

->

SELECT 
	MIN(log_id) AS start_id, 
	MAX(log_id) AS end_id 
FROM 
	(
                SELECT 
                        log_id, 
                        DENSE_RANK() OVER(ORDER BY log_id - RN) AS ranking
                FROM 
                    (
                        SELECT 
                        log_id,
                        ROW_number() OVER(ORDER BY log_id) AS RN
                        FROM 
                        logs
                    )	temp_log
        ) temp_log2
GROUP BY 
	ranking
ORDER BY
	start_id;



 Q.70 Write an SQL Query to find the number of times each student attended each exam. 
 Return the result table ordered by student_id and subject_name.


CREATE TABLE students(
        student_id INT,
        student_name VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(student_id)
    );


CREATE TABLE subjects(
        subject_name VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(subject_name)
    );


CREATE TABLE exams(
        student_id INT,
        subject_name VARCHAR(20)
    );


INSERT INTO students VALUES
        (1,'ALICE'),
        (2,'BOB'),
        (13,'JOHN'),
        (6,'ALEX');


INSERT INTO subjects VALUES
        ('MATHS'),
        ('PHYSICS'),
        ('PROGRAMMING');


INSERT INTO exams VALUES    
        (1,'MATHS'),
        (1,'PHYSICS'),
        (1,'PROGRAMMING'),
        (2,'PROGRAMMING'),
        (1,'PHYSICS'),
        (1,'MATHS'),
        (13,'MATHS'),
        (13,'PROGRAMMING'),
        (13,'PHYSICS'),
        (2,'MATHS'),
        (1,'MATHS');
    
->

WITH temp_student AS (
			SELECT 
				student_id, 
				student_name, 
				subject_name  
			FROM 
				students, 
				subjects
					),

    temp_student2 AS (
			SELECT 
				student_id, 
				subject_name, 
				COUNT(*) AS times_attended_each_exam 
			FROM 
				exams
			GROUP BY 
				student_id, 
				subject_name
					)

SELECT 
        t.student_id,
        t.student_name, 
        t.subject_name, 
        COALESCE(times_attended_each_exam,0) AS attended_exams
FROM 
        temp_student t
LEFT JOIN 
        temp_student2 t2
ON 
        t.student_id = t2.student_id 
        AND 
        t.subject_name = t2.subject_name
ORDER BY 
        t.student_id, 
        t.subject_name;



 Q.71 Write an SQL Query to find employee_id of all employees that directly or indirectly 
 report their work to the head of the company. The indirect relation between managers will not exceed 
 three managers as the company is small. Return the result table in any order.


CREATE TABLE employees(
        employee_id INT,
        employee_name VARCHAR(20),
        manager_id INT,
        CONSTRAINT prime_key PRIMARY KEY(employee_id)
    );


INSERT INTO employees VALUES    
        (1,'BOSS',1),
        (3,'ALICE',3),
        (2,'BOB',1),
        (4,'DANIEL',2),
        (7,'LUIS',4),
        (8,'JHON',3),
        (9,'ANGELA',8),
        (77,'ROBERT',1);


->

with recursive managers as (
				SELECT 
                                    employee_id, 
                                    manager_id 
                                FROM 
                                    employees 
                                WHERE 
                                    employee_id = 1
                                    
				UNION

			        SELECT
                                    e.employee_id, 
                                    m.manager_id 
                                FROM 
                                    managers m
        			INNER JOIN  
                                    employees e
				ON 
                                    e.manager_id = m.employee_id
		)
                        
SELECT 
employee_id 
FROM 
managers 
WHERE 
employee_id <> manager_id;



 Q.72 Write an SQL Query to find for each month and country, the number of transactions and their total amount, 
 the number of approved transactions and their total amount. Return the result table in any order.


CREATE TABLE transactions(
        id INT,
        country VARCHAR(20),
        state ENUM ('APPROVED','DECLINED'),
        amount INT,
        trans_date DATE,
        CONSTRAINT prime_key PRIMARY KEY(id)
    );


INSERT INTO transactions VALUES 
        (121,'US','APPROVED',1000,'2018-12-18'),
        (122,'US','DECLINED',2000,'2018-12-19'),
        (123,'US','APPROVED',2000,'2019-01-01'),
        (124,'DE','APPROVED',2000,'2019-01-07');

->   
   
WITH temp_transactions AS (
				SELECT 
				        concat(YEAR(trans_date), '-',MONTH(trans_date)) AS transaction_date, 
					country, 
					state,
					count(*) OVER (PARTITION BY concat(YEAR(trans_date), '-',MONTH(trans_date)), country) AS total_transactions,
					sum(amount) OVER (PARTITION BY concat(YEAR(trans_date), '-',MONTH(trans_date)), country) AS total_transactions_amount,
					sum(amount) OVER (PARTITION BY concat(YEAR(trans_date), '-',MONTH(trans_date)), country, state) AS amount
									
				FROM
				transactions
			)
        
SELECT 
        transaction_date,
	country,
        total_transactions,
        count(*) OVER(PARTITION BY transaction_date, country, state) AS approved_transactions,
        total_transactions_amount,
        amount AS approved_amount
        
FROM 
        temp_transactions
WHERE 
        state = 'Approved';



 Q.73 Write an SQL Query to find the average daily percentage of posts that got 
 removed after being reported as spam, rounded to 2 decimal places.


CREATE TABLE actions(
        user_id INT,
        post_id INT,
        action_date DATE,
        action ENUM ('VIEW','LIKE','REACTION','COMMENT','REPORT','SHARE'),
        extra VARCHAR(20)
    );


CREATE TABLE removals(
        post_id INT,
        remove_date DATE,
        CONSTRAINT prime_key PRIMARY KEY(post_id)
    );


INSERT INTO actions VALUES
        (1,1,'2019-07-01','VIEW','NULL'),
        (1,1,'2019-07-01','LIKE','NULL'),
        (1,1,'2019-07-01','SHARE','NULL'),
        (2,2,'2019-07-04','VIEW','NULL'),
        (2,2,'2019-07-04','REPORT','SPAM'),
        (3,4,'2019-07-04','VIEW','NULL'),
        (3,4,'2019-07-04','REPORT','SPAM'),
        (4,3,'2019-07-02','VIEW','NULL'),
        (4,3,'2019-07-02','REPORT','SPAM'),
        (5,2,'2019-07-03','VIEW','NULL'),
        (5,2,'2019-07-03','REPORT','RACISM'),
        (5,5,'2019-07-03','VIEW','NULL'),
        (5,5,'2019-07-03','REPORT','RACISM');


INSERT INTO removals VALUES
        (2,'2019-07-20'),
        (3,'2019-07-18');


->

WITH temp_action AS (
			SELECT 
				action_date, 
				post_id, 
				COUNT(EXTRA) OVER(PARTITION BY action_date) num_post_reported_spam
	        	FROM 
				actions
			WHERE 
				extra = 'SPAM'
		)

SELECT 
        ROUND(AVG(percentage), 2) AS avg_daily_percent 
FROM 
        (
                SELECT 
                        action_date, 
                        ROUND((COUNT(post_id)/num_post_reported_spam) * 100, 2) AS percentage
                FROM 
                        temp_action
                WHERE 
                        post_id IN (
                                        SELECT 
                                                post_id 
                                        FROM 
                                                removals
				)
                GROUP BY 
                    action_date
        ) temp;



  Q.74 Write an SQL Query to find the countries where this company can invest .
 Return the result table in any order .


CREATE TABLE person(
        id INT,
        name VARCHAR(20),
        phone_number VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(id)
    );


CREATE TABLE country(
        name VARCHAR(20),
        country_code VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(country_code)
    );


CREATE TABLE calls(
        caller_id INT,
        callee_id INT,
        duration INT
    );


INSERT INTO person VALUES 
        (3,'JONATHON','051-1234567'),
        (21,'ELVIS','051-7654321'),
        (1,'MONCEF','212-1234567'),
        (2,'MAROUA','212-6523651'),
        (7,'MEIR','972-1234567'),
        (9,'RACHEL','972-0011100');


INSERT INTO calls VALUES 
        (1,9,33),
        (1,2,59),
        (3,12,102),
        (3,12,330),
        (12,3,5),
        (7,9,13),
        (7,1,3),
        (9,7,1),
        (1,7,7),
        (2,9,4);


INSERT INTO country VALUES 
        ('PERU','51'),
        ('ISRAEL','972'),
        ('MOROCCO','212'),
        ('GERMANY','49'),
        ('ETHIOPIA','251');

->

SELECT 
name AS country
FROM 	(
	SELECT 
	c.name, 
	SUM(ca.duration) AS call_duration, 
	COUNT(c.country_code) AS number_of_calls
	FROM (
	      SELECT 
				id, 
				name,
				CASE
				WHEN LEFT(SUBSTR(phone_number, 1,3),1) = '0' THEN RIGHT(SUBSTR(phone_number, 1,3), (LENGTH(SUBSTR(phone_number, 1,3))-1)) 
				ELSE SUBSTR(phone_number, 1,3) END AS country_code 
	      FROM 
	      person
		    ) temp_person
JOIN 
country c
ON 
temp_person.country_code = c.country_code
JOIN 
calls ca
ON 
temp_person.id = caller_id
GROUP BY 
c.name


UNION ALL



SELECT 
	c.name,
        SUM(ca.duration) AS call_duration, 
        COUNT(c.country_code) AS number_of_calls
FROM 	(
		SELECT 
			id, 
			name,
			CASE
			WHEN LEFT(SUBSTR(phone_number, 1,3),1) = '0' THEN RIGHT(SUBSTR(phone_number, 1,3), (length(SUBSTR(phone_number, 1,3))-1)) 
			ELSE SUBSTR(phone_number, 1,3) END AS country_code 
		FROM 
		person
	) 	temp_person
JOIN 
country c
ON 
temp_person.country_code = c.country_code
JOIN 
calls ca
ON 
temp_person.id = ca.callee_id
GROUP BY 
c.name 
        
	) temp

GROUP BY 
name 
HAVING 
SUM(call_duration)/SUM(number_of_calls) >  (SELECT AVG(duration) FROM calls);
 




  Q.75 SAME AS Q.43



  Q.76 Write an SQL Query to find the salaries of the employees after applying taxes. 
  Round the salary to the nearest integer.


 CREATE TABLE salaries(
        company_id INT,
        employee_id INT,
        employee_name VARCHAR(20),
        salary INT,
        CONSTRAINT prime_key PRIMARY KEY(company_id, employee_id)
    );


INSERT INTO salaries VALUES    
        (1,1,'TONY',2000),
        (1,2,'PRONUB',21300),
        (1,3,'TYRROX',10800),
        (2,1,'PAM',300),
        (2,7,'BASSEM',450),
        (2,9,'HERMIONE',700),
        (3,7,'BOCABEN',100),
        (3,2,'OGNJEN',2200),
        (3,13,'NYAN CAT',3300),
        (3,15,'MORNING CAT',7777);

->

WITH temp_salaries AS (
			SELECT 
			        company_id, 
			        employee_id, 
				employee_name, 
				salary,
				MAX(salary) OVER(PARTITION BY company_id) max_sal_per_company
			FROM 
				salaries
		)

SELECT 
	company_id, 
	employee_id, 
	employee_name, 
	salary, 
        ROUND(
                CASE
                    WHEN max_sal_per_company > 10000 THEN salary - (salary * 0.49)
                    WHEN max_sal_per_company BETWEEN 1000 AND 10000 THEN salary - (salary * 0.24)
                    ELSE salary 
		        END, 0) AS sal_after_tax_deduction
FROM 
        temp_salaries;



 Q.77 Write an SQL Query to evaluate the boolean expressions in Expressions table. 
 Return the result table in any order.


CREATE TABLE variables(
        name VARCHAR(2),
        value INT,
        CONSTRAINT prime_key PRIMARY KEY(name)
    );


INSERT INTO variables VALUES    
        ('x',66),
        ('y',77);
       
       
CREATE TABLE expressions(
        left_operand VARCHAR(2),
        operator ENUM('<','=','>'),
        right_operand VARCHAR(2),
        CONSTRAINT prime_key PRIMARY KEY(left_operand, operator, right_operand)
    );


INSERT INTO expressions VALUES    
        ('x','>','y'),
        ('x','<','y'),
        ('x','=','y'),
        ('y','>','x'),
        ('y','<','x'),
        ('x','=','x');

->

SELECT 
	e.left_operand, 
        e.operator, 
        e.right_operand,
	CASE
		WHEN e.operator = '<' THEN IF(l.value < r.value, 'TRUE', 'FALSE')
		WHEN e.operator = '>' THEN IF(l.value > r.value, 'TRUE', 'FALSE')
                ELSE IF(l.value = r.value, 'TRUE', 'FALSE')
		END AS result
FROM 
	expressions e
JOIN 
	variables l
ON 		
	e.left_operand = l.name
JOIN 
	variables r
ON
        e.right_operand = r.name;



 Q.78 

CREATE TABLE person(
        id INT,
        name VARCHAR(20),
        phone_number VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(id)
    );


CREATE TABLE country(
        name VARCHAR(20),
        country_code VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(country_code)
    );


CREATE TABLE calls(
        caller_id INT,
        callee_id INT,
        duration INT
    );


INSERT INTO person VALUES 
        (3,'JONATHON','051-1234567'),
        (21,'ELVIS','051-7654321'),
        (1,'MONCEF','212-1234567'),
        (2,'MAROUA','212-6523651'),
        (7,'MEIR','972-1234567'),
        (9,'RACHEL','972-0011100');


INSERT INTO calls VALUES 
        (1,9,33),
        (1,2,59),
        (3,12,102),
        (3,12,330),
        (12,3,5),
        (7,9,13),
        (7,1,3),
        (9,7,1),
        (1,7,7),
        (2,9,4);


INSERT INTO country VALUES 
        ('PERU','51'),
        ('ISRAEL','972'),
        ('MOROCCO','212'),
        ('GERMANY','49'),
        ('ETHIOPIA','251');

->

SELECT 
name AS country
FROM 	(
	SELECT 
	c.name, 
	SUM(ca.duration) AS call_duration, 
	COUNT(c.country_code) AS number_of_calls
	FROM (
	      SELECT 
				id, 
				name,
				CASE
				WHEN LEFT(SUBSTR(phone_number, 1,3),1) = '0' THEN RIGHT(SUBSTR(phone_number, 1,3), (LENGTH(SUBSTR(phone_number, 1,3))-1)) 
				ELSE SUBSTR(phone_number, 1,3) END AS country_code 
	      FROM 
	      person
		    ) temp_person
JOIN 
country c
ON 
temp_person.country_code = c.country_code
JOIN 
calls ca
ON 
temp_person.id = caller_id
GROUP BY 
c.name


UNION ALL



SELECT 
	c.name,
        SUM(ca.duration) AS call_duration, 
        COUNT(c.country_code) AS number_of_calls
FROM 	(
		SELECT 
			id, 
			name,
			CASE
			WHEN LEFT(SUBSTR(phone_number, 1,3),1) = '0' THEN RIGHT(SUBSTR(phone_number, 1,3), (length(SUBSTR(phone_number, 1,3))-1)) 
			ELSE SUBSTR(phone_number, 1,3) END AS country_code 
		FROM 
		person
	) 	temp_person
JOIN 
country c
ON 
temp_person.country_code = c.country_code
JOIN 
calls ca
ON 
temp_person.id = ca.callee_id
GROUP BY 
c.name 
        
	) temp

GROUP BY 
name 
HAVING 
SUM(call_duration)/SUM(number_of_calls) >  (SELECT AVG(duration) FROM calls);






 Q.79 Write a Query that prints a list of employee names (i.e.: the name attribute) 
 from the employee table in alphabetical order.


CREATE TABLE employee(
        employee_id INT,
        name VARCHAR(20),
        months INT,
        salary INT
    );


INSERT INTO employee VALUES
        (12228,'ROSE',15,1968),
        (33645,'ANGELA',1,3443),
        (45692,'FRANK',17,1608),
        (56118,'PATRIK',7,1345),
        (74197,'KINBERLY',16,4372),
        (78454,'BONNIE',8,1771),
        (83565,'MICHAEL',6,2017),
        (98607,'TODD',5,3396),
        (99989,'JOE',9,3573);
->

SELECT 
        name 
FROM 
        employee 
ORDER BY 
        name;





 Q.80 Write a Query to obtain the year-on-year growth rate for the total spend of each product for each year.


CREATE TABLE user_transactions(
        transaction_id INT,
        product_id INT,
        spend FLOAT,
        transaction_date VARCHAR(30)
    );


INSERT INTO user_transactions VALUES
        (1341,123424,1500.60,'12/31/2019 12:00:00'),
        (1423,123424,1000.20,'12/31/2020 12:00:00'),
        (1623,123424,1246.44,'12/31/2021 12:00:00'),
        (1322,123424,2145.32,'12/31/2022 12:00:00');
->

WITH temp_transactions AS (
				SELECT 
					product_id,
					transaction_date,
				        spend AS curr_year_spend, 
					LAG(spend,1,0) OVER w AS prev_year_spend,
					IFNULL(spend - LAG(spend,1) OVER w, 0) AS prev_curr_spend_diff
				FROM 
					user_transactions
				WINDOW 
					w AS (PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date))
			)
 
SELECT 
        product_id,
        curr_year_spend, 
        ROUND(prev_year_spend, 2),
        IFNULL(ROUND((prev_curr_spend_diff * 100)/prev_year_spend,2),0) AS YOY 
FROM 
        temp_transactions;
        
    



 Q.81 Write a SQL Query to find the number of prime and non-prime items that can be stored 
 in the 500,000 square feet warehouse. Output the item type and number of items to be stocked.


CREATE TABLE inventory(
        item_id INT,
        item_type VARCHAR(20),
        item_category VARCHAR(20),
        square_foot FLOAT
    );


INSERT INTO inventory VALUES
        (1374,'PRIME_ELIGIBLE','MINI FRidGE',68.00),
        (4245,'NOT_PRIME','STANDING LAMP',26.40),
        (2452,'PRIME_ELIGIBLE','TELEVISION',85.00),
        (3255,'NOT_PRIME','SidE TABLE',22.60),
        (1672,'PRIME_ELIGIBLE','LAPTOP',8.50);



->

WITH temp_inventory AS (
			SELECT 
				item_type, 
				SUM(square_foot) AS square_foot_per_category, 
				COUNT(*) AS count_of_items
			FROM 
			inventory
			GROUP BY 
			item_type
		),
                    
    temp_inventory2 AS (
			SELECT 
			(500000 - SUM(square_foot_per_category)*FLOOR(500000/SUM(square_foot_per_category))) AS area_left 
			FROM 
			temp_inventory 
			WHERE 
			item_type = 'PRIME_ELIGIBLE'
		),
                    
    temp_inventory3 AS (
			SELECT 
				item_type,
				CASE 
				        WHEN item_type = 'PRIME_ELIGIBLE'
                                                        THEN FLOOR(500000/square_foot_per_category) * count_of_items
                                	WHEN item_type = 'NOT_PRIME' 
                                                        THEN FLOOR((SELECT area_left FROM temp_inventory2) / square_foot_per_category) * count_of_items
                                        END AS item_count
			FROM 
				temp_inventory
		)
             
SELECT 
        item_type,
        item_count
 FROM 
        temp_inventory3;



 Q.82 Write a Query to obtain the active user retention in July 2022. 
 Output the month (in numerical format 1, 2, 3) and the number of monthly active users (MAUs).


CREATE TABLE user_actions(
        user_id INT,
        event_id INT,
        event_type ENUM('SIGN-IN','LIKE','COMMENT'),
        event_date DATETIME
    );


INSERT INTO user_actions VALUES
        (445,7765,'SIGN-IN','2022-05-31 12:00:00'),
        (742,6458,'SIGN-IN','2022-06-03 12:00:00'),
        (445,3634,'LIKE','2022-06-05 12:00:00'),
        (742,1374,'COMMENT','2022-06-05 12:00:00'),
        (648,3124,'LIKE','2022-06-18 12:00:00');


->


WITH temp_actions AS (
			SELECT 
				user_id,
				event_date,
				event_type,
				SUBSTR(event_date, 6, 2) - lag(SUBSTR(event_date, 6, 2)) OVER w AS difference
			FROM 
				user_actions
			WINDOW 
				w as (PARTITION BY user_id ORDER BY event_date)
		),

        temp_actions2 AS (
			SELECT 
				SUBSTR(event_date, 6, 2) AS months,
				COUNT(user_id) AS monthly_active_users
			FROM 	
				temp_actions
			WHERE 
				difference = 1 AND event_type IN ('LIKE', 'COMMENT', 'SIGN-IN')
			GROUP BY 
				months
				)
   
SELECT 
months,
monthly_active_users
FROM 
temp_actions2;




 Q.83 Write a Query to report the median of searches made by a user. 
 Round the median to one decimal point.


CREATE TABLE search_frequency(
        searches INT,
        num_users INT
    );


INSERT INTO search_frequency VALUES
        (1,2),
        (2,2),
        (3,3),
        (4,1);

->

 WITH temp_search_freq AS (
				SELECT 
					searches,
					num_users,
					ROW_NUMBER() OVER(ORDER BY searches) row_num,
					COUNT(*) OVER(ORDER BY searches ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) total_records
				FROM
					search_frequency
			),
        
    temp_search_freq2 as (
				SELECT 
					searches,
					num_users,
					CASE
					WHEN total_records % 2 <>  0 THEN (
									SELECT 
										DISTINCT ROUND(SUM(searches) OVER w /
										COUNT(*) OVER w,1)
									FROM 
										temp_search_freq 
									WHERE 
										row_num = ROUND((total_records + 1) / 2, 0)
									WINDOW 
										w AS (ORDER BY searches ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
														
									)
													
					WHEN total_records % 2 = 0 THEN (
									SELECT 
										DISTINCT ROUND(SUM(searches) OVER w /
										COUNT(*) OVER w,1)
									FROM
										temp_search_freq 
									WHERE 
										row_num IN (total_records/2,(total_records/2)+1)
									WINDOW 
										w AS (ORDER BY searches ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
									)
							END AS median
							FROM 
                        temp_search_freq
            )
            

SELECT 
DISTINCT median 
FROM 
temp_search_freq2;



 Q.84 Write a Query to update the Facebook advertisers status using the daily_pay table. 
 Advertiser is a two-column table containing the user id and their payment status based 
 on the last payment and daily_pay table has current information about their payment. 
 Only advertisers who paid will show up in this table.
 Output the user id and current payment status sorted by the user id.


CREATE TABLE advertiser(
        user_id VARCHAR(20),
        status ENUM('NEW','EXISTING','CHURN','RESURRECT')
    );


CREATE TABLE daily_pay(
        user_id VARCHAR(20),
        paid DECIMAL
    );


INSERT INTO advertiser VALUES
        ('BING','NEW'),
        ('YAHOO','NEW'),
        ('ALIBABA','EXISTING');


INSERT INTO daily_pay VALUES
        ('YAHOO',45.00),
        ('ALIBABA',100.00),
        ('TARGET',13.00);

->

SELECT 
        user_id, 
        CASE
            WHEN user_id IN (SELECT user_id FROM daily_pay) THEN 'EXISTING'
            ELSE 'CHURN'
            END AS new_status
FROM 
        advertiser
ORDER BY
	user_id;



 Q.85 Write a SQL Query that calculates the total time that the fleet of 
 servers was running. The output should be in units of full days.


CREATE TABLE server_utilization(
        server_id INT,
        session_status VARCHAR(20),
        status_time VARCHAR(25)
    );


INSERT INTO server_utilization VALUES
        (1,'start','08/02/2022 10:00:00'),
        (1,'stop','08/04/2022 10:00:00'),
        (2,'stop','08/24/2022 10:00:00'),
        (2,'start','08/17/2022 10:00:00');


->


SELECT 
	stop_time - start_time AS total_up_time
FROM
	(
	SELECT
		SUM(
		    CASE
			WHEN session_status = 'start' then EXTRACT(DAY from STR_TO_DATE(status_time, '%m/%d/%y'))
			END
		    )       AS start_time,
				SUM(
				    CASE
				    WHEN session_status = 'stop' then EXTRACT(DAY from STR_TO_DATE(status_time, '%m/%d/%y'))
				    END
				    )  AS stop_time
			FROM
			server_utilization
        ) temp_server_utilization;




 Q.86 Sometimes, payment transactions are repeated by accident; it could be due to user error, 
 API failure or a retry error that causes a credit card to be charged twice.
 Using the transactions table, identify any payments made at the same merchant with the 
 same credit card for the same amount within 10 minutes of each other. Count such repeated payments.


CREATE TABLE transactions(
        transaction_id INT,
        merchant_id INT,
        credit_card_id INT,
        amount INT,
        transaction_timestamp DATETIME
    );


INSERT INTO transactions VALUES
        (1,101,1,100,'2022-09-25 12:00:00'),
        (2,101,1,100,'2022-09-25 12:08:00'),
        (3,101,1,100,'2022-09-25 12:28:00'),
        (4,102,2,300,'2022-09-25 12:00:00'),
        (5,102,2,400,'2022-09-25 14:00:00');

->

WITH temp_transactions AS (
				SELECT 
					merchant_id, 
					credit_card_id, 
					amount, 
				        transaction_timestamp,
					LAG(transaction_timestamp) OVER w AS prev_tran_timestamp,
					timestampdiff(MINUTE,LAG(transaction_timestamp) OVER w, transaction_timestamp) AS difference
				FROM 
					transactions
				WINDOW
					w as (PARTITION BY credit_card_id ORDER BY  transaction_timestamp)
            )
 
SELECT 
        COUNT(DISTINCT merchant_id) AS payment_count
FROM 
        temp_transactions
 WHERE 
        difference <= 10;

        


 Q.87 Write a SQL Query to find the bad experience rate in the first 14 days for new users who signed 
 up in June 2022. Output the percentage of bad experience rounded to 2 decimal places.


CREATE TABLE orders(
        order_id INT,
        customer_id INT,
        trip_id INT,
        status ENUM('COMPLETED SUCCESSFULLY','COMPLETED INCORRECTLY','NEVER_RECEIVED'),
        order_timestamp VARCHAR(30)
    );


INSERT INTO orders VALUES  
        (727424,8472,100463,'COMPLETED SUCCESSFULLY','06/05/2022 09:12:00'),
        (242513,2341,100482,'COMPLETED INCORRECTLY','06/05/2022 14:40:00'),
        (141367,1314,100362,'COMPLETED INCORRECTLY','06/07/2022 15:03:00'),
        (582193,5421,100657,'NEVER_RECEIVED','07/07/2022 15:22:00'),
        (253613,1314,100213,'COMPLETED SUCCESSFULLY','06/12/2022 13:43:00');


CREATE TABLE trips(
        dasher_id INT,
        trip_id INT,
        estimated_delivery_timestamp VARCHAR(25),
        actual_delivery_timestamp VARCHAR(25)
    );


INSERT INTO TRIPS VALUES 
        (101,100463,'06/05/2022 09:42:00','06/05/2022 09:38:00'),
        (102,100482,'06/05/2022 15:10:00','06/05/2022 15:46:00'),
        (101,100362,'06/07/2022 15:33:00','06/07/2022 16:45:00'),
        (102,100657,'07/07/2022 15:52:00',NULL),
        (103,100213,'06/12/2022 14:13:00','06/12/2022 14:10:00');


CREATE TABLE customers(
        customer_id INT,
        signup_timestamp VARCHAR(30)
    );


INSERT INTO customers VALUES    
        (8472,'05/30/2022 00:00:00'),
        (2341,'06/01/2022 00:00:00'),
        (1314,'06/03/2022 00:00:00'),
        (1435,'06/05/2022 00:00:00'),
        (5421,'06/07/2022 00:00:00');

->

SELECT 
        ROUND(
            SUM(
                CASE
                    WHEN status !='completed successfully'  THEN 1 ELSE 0
                    END 
                )*100.0/count(*),2)  AS bad_experience_pct
FROM 
        customers C
INNER JOIN 
        orders O 
ON 
        o.customer_id = c.customer_id
WHERE 
        o.order_timestamp < date_add(STR_TO_date(signup_timestamp, '%m/%d/%Y'), INTERVAL 14 DAY) 
        AND 
        MONTH(STR_TO_date(signup_timestamp, '%m/%d/%Y')) = 06 
        AND 
        YEAR(STR_TO_date(signup_timestamp, '%m/%d/%Y')) = 2022;




 Q.88 Write an SQL Query to find the total score for each gender on each day.
 Return the result table ordered by gender and day in ascending order.


CREATE TABLE scores(
        player_name VARCHAR(20),
        gender VARCHAR(20),
        day DATE,
        score_points INT,
        CONSTRAINT prime_key PRIMARY KEY(gender,day)
    );


INSERT INTO scores VALUES
        ('ARON','F','2020-01-01',17),
        ('ALICE','F','2020-01-07',23),
        ('BAJRANG','M','2020-01-07',7),
        ('KHALI','M','2019-12-25',11),
        ('SLAMAN','M','2019-12-30',13),
        ('JOE','M','2019-12-31',3),
        ('JOSE','M','2019-12-18',2),
        ('PRIYA','F','2019-12-31',23),
        ('PRIYANKA','F','2019-12-30',17);

->

SELECT 
        gender, 
        day, 
        SUM(score_points) OVER(PARTITION BY gender ORDER BY day 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_points 
FROM 
        scores
order by 
	gender,
        day;



 Q.89  Write an SQL Query to find the countries where this company can invest .
 Return the result table in any order .


CREATE TABLE person(
        id INT,
        name VARCHAR(20),
        phone_number VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(id)
    );


CREATE TABLE country(
        name VARCHAR(20),
        country_code VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(country_code)
    );


CREATE TABLE calls(
        caller_id INT,
        callee_id INT,
        duration INT
    );


INSERT INTO person VALUES 
        (3,'JONATHON','051-1234567'),
        (21,'ELVIS','051-7654321'),
        (1,'MONCEF','212-1234567'),
        (2,'MAROUA','212-6523651'),
        (7,'MEIR','972-1234567'),
        (9,'RACHEL','972-0011100');


INSERT INTO calls VALUES 
        (1,9,33),
        (1,2,59),
        (3,12,102),
        (3,12,330),
        (12,3,5),
        (7,9,13),
        (7,1,3),
        (9,7,1),
        (1,7,7),
        (2,9,4);


INSERT INTO country VALUES 
        ('PERU','51'),
        ('ISRAEL','972'),
        ('MOROCCO','212'),
        ('GERMANY','49'),
        ('ETHIOPIA','251');

->

SELECT 
name AS country
FROM 	(
	SELECT 
	c.name, 
	SUM(ca.duration) AS call_duration, 
	COUNT(c.country_code) AS number_of_calls
	FROM (
	      SELECT 
				id, 
				name,
				CASE
				WHEN LEFT(SUBSTR(phone_number, 1,3),1) = '0' THEN RIGHT(SUBSTR(phone_number, 1,3), (LENGTH(SUBSTR(phone_number, 1,3))-1)) 
				ELSE SUBSTR(phone_number, 1,3) END AS country_code 
	      FROM 
	      person
		    ) temp_person
JOIN 
country c
ON 
temp_person.country_code = c.country_code
JOIN 
calls ca
ON 
temp_person.id = caller_id
GROUP BY 
c.name


UNION ALL



SELECT 
	c.name,
        SUM(ca.duration) AS call_duration, 
        COUNT(c.country_code) AS number_of_calls
FROM 	(
		SELECT 
			id, 
			name,
			CASE
			WHEN LEFT(SUBSTR(phone_number, 1,3),1) = '0' THEN RIGHT(SUBSTR(phone_number, 1,3), (length(SUBSTR(phone_number, 1,3))-1)) 
			ELSE SUBSTR(phone_number, 1,3) END AS country_code 
		FROM 
		person
	) 	temp_person
JOIN 
country c
ON 
temp_person.country_code = c.country_code
JOIN 
calls ca
ON 
temp_person.id = ca.callee_id
GROUP BY 
c.name 
        
	) temp

GROUP BY 
name 
HAVING 
SUM(call_duration)/SUM(number_of_calls) >  (SELECT AVG(duration) FROM calls);






 Q.90 Write an SQL Query to report the median of all the numbers in the database 
 after decompressing the numbers table. Round the median to one decimal point.


CREATE TABLE numbers(
        num INT,
        frequency INT
    );


INSERT INTO numbers VALUES  
        (0,7),
        (1,1),
        (2,3),
        (3,1);


->

WITH RECURSIVE num_frequency (num,frequency, i) AS 
			(
				SELECT  
                                        num,
					frequency,1
				FROM   
					numbers

				UNION ALL
						
                                SELECT   
                                        num,
				        frequency,
					i+1
				FROM    
					num_frequency
				WHERE   
					num_frequency.i < num_frequency.frequency
			),
        
	num_frequency2 AS (
				SELECT 
					num, 
					frequency, 
					row_number() OVER(ORDER BY num, frequency) AS row_num,
					COUNT(*) OVER(ORDER BY num, frequency ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS total_records
				FROM    
					num_frequency
			)


SELECT	
	DISTINCT CASE
		        WHEN total_records % 2 <>  0 THEN (
                                SELECT 
                                        DISTINCT ROUND(SUM(num) OVER w /
                                        COUNT(*) OVER  w, 1)
				FROM 
                                        num_frequency2 
                                WHERE 
                                        row_num = ROUND((total_records + 1) / 2, 0)
				WINDOW
					w as (ORDER BY  num, frequency ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING))
                        
                    WHEN total_records % 2 = 0 THEN (
                                SELECT 
                                        DISTINCT ROUND(SUM(num) OVER w /
                                        COUNT(*) OVER w, 1)
				FROM 
                                        num_frequency2 
                                WHERE 
                                        row_num IN (total_records/2,(total_records/2)+1)
				WINDOW
				        w as (ORDER BY  num, frequency ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING))       
                    END AS median
FROM 
        num_frequency2;



 Q.91 Write an SQL Query to report the comparison result (higher/lower/same) of the average salary of 
 employees in a department to the companys average salary. Return the result table in any order.


CREATE TABLE salary(
        id INT,
        employee_id INT,
        amount INT,
        paydate DATE,
        CONSTRAINT prime_key PRIMARY KEY(id)
    );


CREATE TABLE employee(
        employee_id INT,
        department_id INT,
        CONSTRAINT prime_key PRIMARY KEY(employee_id)
    );


INSERT INTO salary VALUES
        (1,1,9000,'2017/03/31'),
        (2,2,6000,'2017/03/31'),
        (3,3,10000,'2017/03/31'),
        (4,1,7000,'2017/02/28'),
        (5,2,6000,'2017/02/28'),
        (6,3,8000,'2017/02/28');


INSERT INTO employee VALUES
        (1,1),
        (2,2),
        (3,2);
        
->

WITH temp_comparison AS (
			        SELECT 
					s.employee_id, 
					e.department_id,
					s.amount, 
					s.paydate,
					avg(amount) OVER (PARTITION BY MONTH(paydate) ORDER BY month(paydate), employee_id 
							        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) company_avg_salary,
					avg(amount) OVER (PARTITION BY MONTH(paydate), department_id order by month(paydate) 
								ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) department_avg 
				FROM
					salary s
				INNER JOIN 
					employee e
				ON 
					e.employee_id = s.employee_id
                        )
 
 SELECT 
        DISTINCT DATE_FORMAT(paydate, '%Y-%m') AS pay_month, 
        department_id,
        CASE
            WHEN company_avg_salary = department_avg THEN 'same'
            WHEN company_avg_salary > department_avg THEN 'lower'
            WHEN company_avg_salary < department_avg THEN 'higher'
            END AS comparison
 FROM 
        temp_comparison;



 Q.92 Write an SQL Query to report for each install date, the number of players 
 that installed the game on that day, and the day one retention.


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
        (3,1,'2016-03-01',0),
        (3,4,'2018-07-03',5);


->


SELECT 
        a.event_date AS install_date, 
        COUNT(a.player_id) AS installs, 
        ROUND(COUNT(b.player_id) / COUNT(a.player_id), 2) AS day1_retention
FROM
        (
                SELECT 
                        player_id, 
                        MIN(event_date) AS event_date
                FROM 
                        activity 
                GROUP BY 
                        player_id
	) a
LEFT JOIN 
        activity b
ON 
        a.player_id = b.player_id 
        AND 
        a.event_date + 1 = b.event_date
GROUP BY 
        a.event_date;






 Q.93 SAME AS 50



 Q.94 Write an SQL Query to report the students (student_id, student_name) being -- Quiet in all exams. 
-- Do not return the student who has never taken any exam.


CREATE TABLE student(
        student_id INT,
        student_name VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(student_id)
    );


CREATE TABLE exam(
        exam_id INT,
        student_id INT,
        score INT,
        CONSTRAINT prime_key PRIMARY KEY(exam_id,student_id)
    );


INSERT INTO student VALUES 
        (1,'DANIEL'),
        (2,'JADE'),
        (3,'STELLA'),
        (4,'JONATHAN'),
        (5,'WILL');


INSERT INTO exam VALUES
        (10,1,70),
        (10,2,80),
        (10,3,90),
        (20,1,80),
        (30,1,70),
        (30,3,80),
        (30,4,90),
        (40,1,60),
        (40,2,70),
        (40,4,80);


->

WITH temp_examination AS (
				SELECT 
					exam_id,
					student_id,
					score,
					max(score) OVER w AS highest,
					min(score) OVER w AS lowest
				FROM
					exam
				WINDOW 
                                        w AS (PARTITION BY exam_id)
			),
    
     temp_examination1 AS (
				SELECT 
					DISTINCT student_id 
				FROM 
					temp_examination 
				WHERE 
					score IN (lowest, highest)
						)

    SELECT 
            DISTINCT s.student_id,
            s.student_name
    FROM 
            temp_examination 
    INNER JOIN 
            student s 
    ON 
            s.student_id = temp_examination.student_id
    WHERE 
            s.student_id NOT IN (SELECT student_id FROM temp_examination1);





 Q.95 SAME AS 94



 Q.96 Write a query to output the user id, song id, and cumulative count of song plays as of 4 August 2022 
 sorted in descending order.


CREATE TABLE songs_history(
	history_id INT,
	user_id INT,
	song_id INT,
	song_plays INT
	);


INSERT INTO songs_history VALUES
	(10011,777,1238,11),
	(12452,695,4520,1);


CREATE TABLE songs_weekly(
	user_id INT,
	song_id INT,
	listen_time VARCHAR(25)
	);


INSERT INTO songs_weekly VALUES
        (777,1238,'08/01/2022 12:00:00'),
	(695,4520,'08/04/2022 08:00:00'),
	(125,9630,'08/04/2022 16:00:00'),
	(695,9852,'08/07/2022 12:00:00');

->

WITH streaming AS (
                        SELECT 
                                user_id, 
                                song_id, 
                                song_plays
                        FROM 
                                songs_history

                        UNION ALL

                        SELECT 
                                user_id, 
                                song_id, 
                                count(*) AS song_plays
                        FROM 
                                songs_weekly
                         WHERE 
			        listen_time <= '08/04/2022 23:59:59'
                        GROUP by 
                                user_id, 
                                song_id
                )

SELECT 
        user_id, 
        song_id, 
        SUM(song_plays) as song_plays
FROM 
        streaming
GROUP BY 
        user_id, 
        song_id
ORDER BY 
        song_plays DESC;



 Q.97 Write a query to find the confirmation rate of users who confirmed their signups with text messages. 
 Round the result to 2 decimal places.


CREATE TABLE emails(
	email_id INT,
	user_id INT,
	signup_date DATETIME
	);


INSERT INTO emails VALUES
	(125,7771,'2022-06-14 00:00:00'),
	(236,6950,'2022-07-01 00:00:00'),
	(433,1052,'2022-07-09 00:00:00');


CREATE TABLE texts(
	text_id INT,
	email_id INT,
	signup_action VARCHAR(20)
	);


INSERT INTO texts VALUES
	(6878,125,'CONFIRMED'),
	(6920,236,'NOT CONFIRMED'),
	(6994,236,'CONFIRMED');


->

WITH temp_confirmation AS (
				SELECT 
					e.email_id,
					CASE
					WHEN signup_action = 'Confirmed' THEN 1
					END 
					AS confirmed_users
			        FROM 
					emails e
				LEFT JOIN 
					texts t
				ON 
					e.email_id = t.email_id 
					AND 
					t.signup_action = 'Confirmed'
		)


SELECT 
        ROUND(SUM(confirmed_users)/COUNT(email_id),2) AS confirm_rate
FROM 
        temp_confirmation;



 Q.98 Calculate the 3-day rolling average of tweets published by each user for each date 
 that a tweet was posted. Output the user id, tweet date, and rolling averages rounded to 2 decimal places.


CREATE TABLE tweets(
	tweet_id INT,
	user_id INT,
	tweet_date DATETIME
	);


INSERT INTO TWEETS VALUES
	(214252,111,'2022-06-01 12:00:00'),
	(739252,111,'2022-06-01 12:00:00'),
	(846402,111,'2022-06-02 12:00:00'),
	(241425,254,'2022-06-02 12:00:00'),
	(137374,111,'2022-06-04 12:00:00');


WITH temp_tweets AS (
                        SELECT 
                                user_id, 
                                tweet_date, 
                                COUNT(tweet_id) AS tweets_count
                        FROM 
                                tweets
                        GROUP BY 
                                user_id, 
                                tweet_date
                        ORDER BY 
                                user_id, 
                                tweet_date
            )

SELECT 
        user_id, 
        tweet_date,
        ROUND(avg(tweets_count) 
        OVER(PARTITION BY user_id ORDER BY tweet_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3days
FROM
        temp_tweets;



 Q.99 Write a query to obtain a breakdown of the time spent sending vs. opening snaps 
 (as a percentage of total time spent on these activities) for each age group.


CREATE TABLE activities(
	activity_id INT,
	user_id INT,
	activity_type ENUM('SEND','OPEN','CHAT'),
	time_spent FLOAT,
	activity_date varchar(25)
	);


INSERT INTO activities VALUES
	(7274,123,'OPEN',4.50,'06/22/2022 12:00:00'),
	(2425,123,'SEND',3.50,'06/22/2022 12:00:00'),
	(1413,456,'SEND',5.67,'06/23/2022 12:00:00'),
	(1414,789,'CHAT',11.00,'06/25/2022 12:00:00'),
	(2536,456,'OPEN',3.00,'06/25/2022 12:00:00');


CREATE TABLE age_breakdown(
        user_id INT,
        age_bucket ENUM('21-25','26-30','31-35')
	);


INSERT INTO age_breakdown VALUES
        (123,'31-35'),
        (456,'26-30'),
        (789,'21-25');
        
->
        
WITH temp_activities AS (
				SELECT 
			        user_id, 
				activity_type,
				sum(time_spent) time_spent,
				CASE
					WHEN activity_type = 'open' THEN sum(time_spent)
					ELSE 0
					END opening_snap,
				CASE
					WHEN activity_type = 'send' THEN sum(time_spent)
					ELSE 0
					END sending_snap
				FROM 
					activities
				WHERE 
					activity_type in ('open','send')
				GROUP BY 
					user_id, 
					activity_type
				ORDER BY 
					user_id
					),

    temp_activities2 AS (
				SELECT 
					user_id, 
					SUM(opening_snap) time_sending,
					SUM(sending_snap) time_opening
				FROM 
					temp_activities
				GROUP BY 
					user_id
			)

SELECT 
        ab.age_bucket, 
        ROUND(time_opening * 100.0 /(time_sending+time_opening), 2) AS send_perc,
        ROUND(time_sending * 100.0 /(time_sending+time_opening), 2) AS open_perc
FROM 
        temp_activities2
INNER JOIN 
        age_breakdown ab 
ON 
        ab.user_id = temp_activities2.user_id
ORDER BY 
        ab.age_bucket;



 Q.100 Write a query to return the IDs of these LinkedIn power creators in ascending order.


CREATE TABLE personal_profiles(
	profile_id INT,
	name VARCHAR(20),
	followers INT
	);


INSERT INTO personal_profiles VALUES
	(1,'NICK SINGH',92000),
	(2,'ZACH WILSON',199000),
	(3,'DALIANA LIU',171000),
	(4,'RAVIT JAIN',107000),
	(5,'VIN VASHISHTA',139000),
	(6,'SUSAN WOJCICKI',39000);


CREATE TABLE employee_company(
	personal_profile_id INT,
	company_id INT
	);


INSERT INTO employee_company VALUES
	(1,4),
	(1,9),
	(2,2),
	(3,1),
	(4,3),
	(5,6),
	(6,5);


CREATE TABLE company_pages(
	company_id INT,
	name VARCHAR(30),
	followers INT
	);


INSERT INTO company_pages VALUES
	(1,'THE DATA SCIENCE PODCAST',8000),
        (2,'AIRBNB',700000),
	(3,'THE RAVIT SHOW',6000),
	(4,'DATA LEMUR',200),
	(5,'YOUTUBE',16000000),
	(6,'DATASCIENCE.VIN',4500),
	(9,'ACE THE DATA SCIENCE INTERVIEW',4479);

->

SELECT 
        DISTINCT p.profile_id 
FROM 
        personal_profiles p 
INNER JOIN 
	employee_company ec
ON
	p.profile_id = ec.personal_profile_id
INNER JOIN 
        company_pages c 
ON 
        ec.company_id = c.company_id
WHERE 
        p.followers > c.followers
ORDER BY 
        p.profile_id;



