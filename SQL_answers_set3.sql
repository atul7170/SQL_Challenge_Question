 Q.101 Write an SQL query to show the second most recent activity of each user.
 If the user only hAS one activity, return that one. A user cannot perform more than one activity at the same time.
 Return the result table in any order.


CREATE TABLE user_activity(
		username VARCHAR(20),
		activity VARCHAR(20),
		start_date DATE,
		end_date DATE
	);


INSERT INTO user_activity VALUES
		('ALICE','TRAVEL','2020-02-12','2020-02-20'),
		('ALICE','DANCING','2020-02-21','2020-02-23'),
		('ALICE','TRAVEL','2020-02-24','2020-02-28'),
		('BOB','TRAVEL','2020-02-11','2020-02-18'); 

->
        
WITH temp_activity AS (
                        SELECT 
                                username, 
                                activity, 
                                start_date, 
                                end_date,
                                ROW_NUMBER() OVER(PARTITION BY username ORDER BY start_date, end_date) row_num,
                                COUNT(*) OVER(PARTITION BY username ORDER BY start_date, end_date
                                                rows between unbounded preceding and unbounded following) total_activities
                        FROM 
                                user_activity
                     ),
    temp_activity2 AS (
                        SELECT 
                                username, 
                                activity, 
                                start_date, 
                                end_date,
                                IF(total_activities = 1 and row_num = 1, 2, row_num) AS ranking
                        FROM 
                                temp_activity
                     )
 
SELECT 
        username, 
        activity, 
        start_date, 
        end_date 
FROM 
        temp_activity2
WHERE 
        ranking = 2;


 Q.102 SAME AS 101


 Q.103 Query the name of any student in students who scored higher than 75 Marks. Order your output 
 by the last three characters of each name. If two or more students both have names ending in the same 
 last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending id.


CREATE TABLE students(
		id INT,
		name VARCHAR(20),
		marks INT
	);


INSERT INTO students VALUES
		(1,'ASHLEY',81),
		(2,'SAMANTHA',75),
		(3,'JULIA',76),
		(4,'BELVET',84);

->

SELECT 
name 
FROM 
students 
WHERE 
marks > 75 
ORDER BY 
        RIGHT(name,3),
        id;


 Q.104 Write a Query that prints a list of employee names (i.e.: the name attribute) 
 for employees in employee HAVING a salary greater than $2000 per month who have 
 been employees for less than 10 months. Sort your result by ascending employee_id.


CREATE TABLE employee(
		employee_id INT,
		name VARCHAR(20),
		month INT,
		salary INT
	);


INSERT INTO employee VALUES
		(12228,'ROSE',15,1968),
		(33645,'ANGELA',1,3443),
		(45692,'FRANK',17,1608),
		(56118,'PATRICK',7,1345),
		(59725,'LISA',11,2330),
		(74197,'KIMBERLY',16,4372),
		(78454,'BONNIE',8,1771),
		(83565,'MICHAEL',6,2017),
		(98607,"TODD",5,3396),
		(99989,'JOE',9,3573);

->

SELECT 
name 
FROM 
employee 
WHERE 
      salary > 2000 
      AND 
      months < 10 
ORDER BY 
      employee_id;



 Q.105 Write a Query identifying the type of each record in the TRIANGLES table using its three side lengths.


CREATE TABLE triangles(
		a INT,
		b INT,
		c INT
	);


INSERT INTO triangles VALUES
		(20,20,23),
		(20,20,20),
		(20,21,22),
		(13,14,30);

->

SELECT 
a,
b,
c, 
      CASE
	WHEN a + b <= c OR b + c <= a OR a + c <= b THEN 'NOT A TRIANGLE'
	WHEN a = b AND b = c THEN 'EQUILATERAL' 
	WHEN a = b OR b = c OR c = a THEN 'ISSOCELES' 
        WHEN a <> b AND b <> c THEN 'SCALEAN'
        END AS type_of_triangle
FROM 
	triangles;



 Q.106 Write a query calculating the amount of error (i.e.: actual - miscalculated average monthly salaries), 
 and round it up to the next integer.


CREATE TABLE employees(
		id INT,
		name VARCHAR(20),
		salary INT
	);

INSERT INTO employees VALUES
		(1,'KRISTEEN',1420),
		(2,'ASHLEY',2006),
		(3,'JULIA',2210),
		(4,'MARIA',3000);

->

SELECT 
        ceil(avg(salary) - avg(replace(salary, '0', ''))) AS error
FROM 
        employees;


 Q.107 Write a query to find the maximum total earnings for all employees as
 well as the total number of employees who have maximum total earnings. 
 Then print these values as 2 space-separated integers.


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
		(56118,'PATRICK',7,1345),
		(59725,'LISA',11,2330),
		(74197,'KIMBERLY',16,4372),
		(78454,'BONNIE',8,1771),
		(83565,'MICHAEL',6,2017),
		(98607,"TODD",5,3396),
		(99989,'JOE',9,3573);

->

SELECT 
        MAX(salary*months) as total_earnings,
        COUNT(*) 
FROM 
        employee
WHERE 
        (salary*months) in (
                            SELECT 
                                    MAX(months * salary) 
                            FROM 
                                    employee
                            );



Q.108 a. Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed 
 by the first letter of each profession AS a parenthetical (i.e.: enclosed in parentheses). 


 b. WHERE [occupation_COUNT] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] 
 is the lowerCASE occupation name. If more than one Occupation hAS the same [occupation_COUNT], 
 they should be ordered alphabetically.


CREATE TABLE occupations(
		name VARCHAR(20),
		occupation VARCHAR(20)
	);


INSERT INTO occupations VALUES
		('SAMNATHA','DOCTOR'),
		('JULIA','ACTOR'),
		('MARIA','ACTOR'),
		('MEERA','SINGER'),
		('ASHLEY','PROFESSOR'),
		('KETTY','PROFESSOR'),
		('CHRISTEEN','PROFESSOR'),
		('JANE','ACTOR'),
		('JENNY','DOCTOR'),
		('PRIYA','SINGER');

->

 a. 

SELECT 
        CONCAT(name, '(',substring(occupation, 1, 1),')') as `name(occupation)`
FROM 
        occupations 
ORDER BY 
        name;



 b. 
->


SELECT 
        CONCAT("There are a total of ", 
        COUNT(*),' ', lower(occupation), 's.')  AS info
FROM 
        occupations 
GROUP BY 
        occupation 
ORDER BY 
        COUNT(occupation), 
        occupation;



 Q.109 Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically 
 and displayed underneath its corresponding Occupation. The output column headers should be 
 Doctor, Professor, Singer, and Actor, respectively.


CREATE TABLE occupations(
		name VARCHAR(20),
		occupation VARCHAR(20)
	);


INSERT INTO occupations VALUES
		('SAMNATHA','DOCTOR'),
		('JULIA','ACTOR'),
		('MARIA','ACTOR'),
		('MEERA','SINGER'),
		('ASHLEY','PROFESSOR'),
		('KETTY','PROFESSOR'),
		('CHRISTEEN','PROFESSOR'),
		('JANE','ACTOR'),
		('JENNY','DOCTOR'),
		('PRIYA','SINGER');

->

SELECT 
        MAX(CASE WHEN occupation = 'Doctor' then name END) AS Doctor,
        MAX(CASE WHEN occupation = 'Professor' then name END) AS Professor,
        MAX(CASE WHEN occupation = 'Singer' then name END) AS Singer,
        MAX(CASE WHEN occupation = 'Actor' then name END) AS Actor
FROM 
        (
            SELECT 
                    name,
                    occupation,
                    row_number() over(partition by occupation order by name) AS row_num 
            FROM 
                    occupations
        ) AS base 
GROUP BY 
        row_num;



 Q.110 Write a query to find the node type of Binary Tree ordered by the value of the node. 
 Output one of the following for each node:
 ● Root: If node is root node.
 ● Leaf: If node is leaf node.
 ● Inner: If node is neither root nor leaf node.


CREATE TABLE bst(
		n INT,
		p INT
	);


INSERT INTO bst VALUES
		(1,2),
		(3,2),
		(6,8),
		(9,8),
		(2,5),
		(8,5),
		(5,NULL);

->

SELECT 
        n, 
        CASE 
            WHEN n NOT IN (SELECT DISTINCT p FROM bst WHERE p IS NOT NULL)  THEN 'Leaf'
            WHEN p IS NULL THEN 'Root'
            ELSE 'Inner'
            END AS type
FROM 
        bst
ORDER BY
         n;



 Q.111 Given the table schemas below, write a query to print the company_code, 
 founder name, total number of lead managers, total number of senior managers, 
 total number of managers, and total number of employees. Order your output by 
 ascending company_code.


CREATE TABLE company(
		company_code VARCHAR(20),
		founder VARCHAR(20)
	);


CREATE TABLE lead_manager(
		lead_manager_code VARCHAR(20),
		company_code VARCHAR(20)
	);


CREATE TABLE senior_manager(
		senior_manager_code VARCHAR(20),
		lead_manager_code VARCHAR(20),
		company_code VARCHAR(20)
	);


CREATE TABLE manager(
		manager_code VARCHAR(20),
		senior_manager_code VARCHAR(20),
		lead_manager_code VARCHAR(20),
		company_code VARCHAR(20)
	);


CREATE TABLE employee(
		employee_code VARCHAR(20),
		manager_code VARCHAR(20),
		senior_manager_code VARCHAR(20),
		lead_manager_code VARCHAR(20),
		company_code VARCHAR(20)
	);


INSERT INTO company VALUES
		('C1','MONIKA'),
		('C2','SAMANTHA');


INSERT INTO lead_manager VALUES
		('LM1','C1'),
		('LM2','C2');


INSERT INTO senior_manager VALUES
		('SM1','LM1','C1'),
		('SM2','LM1','C1'),
		('SM3','LM2','C2');    


INSERT INTO manager VALUES
		('M1','SM1','LM1','C1'),
		('M2','SM3','LM2','C2'),
		('M3','SM3','LM2','C2');  


INSERT INTO employee VALUES
		('E1','M1','SM1','LM1','C1'),
		('E2','M1','SM1','LM1','C1'),
		('E3','M2','SM3','LM2','C2'),
		('E4','M3','SM3','LM2','C2');

->

SELECT 
        c.company_code, 
        c.founder, 
        COUNT(DISTINCT lm.lead_manager_code), 
        COUNT(DISTINCT sm.senior_manager_code),
        COUNT(DISTINCT m.manager_code),
        COUNT(DISTINCT e.employee_code)
FROM 
        company c
INNER JOIN 
        lead_manager lm
ON 
        c.company_code = lm.company_code
INNER JOIN 
        senior_manager sm
ON 
        sm.lead_manager_code = lm.lead_manager_code
INNER JOIN  
        manager m
ON 
        m.senior_manager_code = sm.senior_manager_code
INNER JOIN  
        employee e
ON 
        e.manager_code = m.manager_code
GROUP BY 
        c.company_code, c.founder
ORDER BY 
        c.company_code;



 Q.112 Write a query to print all prime numbers less than or equal to 1000. 
 Print your result on a single line, and use the ampersand () character as 
 your separator (instead of a space).

->

WITH RECURSIVE number_generation AS (
                                        SELECT 
                                                1 num

                                        UNION ALL

                                        SELECT 
                                                num + 1 
                                        FROM 
                                                number_generation 
                                        WHERE 
                                                num<1000
                    ),
                number_generation2 AS (
                                        SELECT 
                                                n1.num AS numm 
                                        FROM 
                                                number_generation n1
                                        INNER JOIN 
                                                number_generation n2
                                        WHERE 
                                                n1.num % n2.num = 0
                                        GROUP BY 
                                                n1.num
                                        HAVING 
                                                COUNT(n1.num) = 2
                    )


SELECT 
        group_concat(numm ORDER BY numm SEPARATOR '&') AS prime_numbers 
FROM 
        number_generation2;



 Q.113 Write a query to print the pattern P(20).

->

WITH RECURSIVE generate_numbers AS   
                                    (
                                        SELECT 
                                                1 AS n

                                        UNION 

                                        SELECT 
                                                n+1 
                                        FROM 
                                                generate_numbers 
                                        WHERE 
                                                n<20
                                    ) 

SELECT 
        repeat('*',n) 
FROM 
        generate_numbers;



 Q.114 Write a query to print the pattern P(20).
->


WITH RECURSIVE generate_numbers AS   
                                    (
                                        SELECT 
                                                20 AS n

                                        UNION 

                                        SELECT 
                                                n-1 
                                        FROM 
                                                generate_numbers 
                                        WHERE 
                                                n>1
                                    ) 

SELECT 
        repeat('*',n) 
FROM 
        generate_numbers;



 Q.115  Query the name of any student in students who scored higher than 75 Marks. Order your output 
 by the last three characters of each name. If two or more students both have names ending in the same 
 last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending id.


CREATE TABLE students(
		id INT,
		name VARCHAR(20),
		marks INT
	);


INSERT INTO students VALUES
		(1,'ASHLEY',81),
		(2,'SAMANTHA',75),
		(3,'JULIA',76),
		(4,'BELVET',84);

->

SELECT 
name 
FROM 
students 
WHERE 
marks > 75 
ORDER BY 
        RIGHT(name,3),
        id;



 Q.116  Write a Query that prints a list of employee names (i.e.: the name attribute) 
 from the employee table in alphabetical order.

->

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


SELECT 
        name 
FROM 
        employee 
ORDER BY 
        name;




 Q.117 SAME AS Q.104

->CREATE TABLE employee(
		employee_id INT,
		name VARCHAR(20),
		month INT,
		salary INT
	);


INSERT INTO employee VALUES
		(12228,'ROSE',15,1968),
		(33645,'ANGELA',1,3443),
		(45692,'FRANK',17,1608),
		(56118,'PATRICK',7,1345),
		(59725,'LISA',11,2330),
		(74197,'KIMBERLY',16,4372),
		(78454,'BONNIE',8,1771),
		(83565,'MICHAEL',6,2017),
		(98607,"TODD",5,3396),
		(99989,'JOE',9,3573);

->

SELECT 
name 
FROM 
employee 
WHERE 
      salary > 2000 
      AND 
      months < 10 
ORDER BY 
      employee_id;


 Q.118 SAME AS Q.105
->
CREATE TABLE triangles(
		a INT,
		b INT,
		c INT
	);


INSERT INTO triangles VALUES
		(20,20,23),
		(20,20,20),
		(20,21,22),
		(13,14,30);

->

SELECT 
a,
b,
c, 
      CASE
	WHEN a + b <= c OR b + c <= a OR a + c <= b THEN 'NOT A TRIANGLE'
	WHEN a = b AND b = c THEN 'EQUILATERAL' 
	WHEN a = b OR b = c OR c = a THEN 'ISSOCELES' 
        WHEN a <> b AND b <> c THEN 'SCALEAN'
        END AS type_of_triangle
FROM 
	triangles;


 Q.119 Write a Query to obtain the year-on-year growth rate for the total spend of each product for each year.


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
        



 Q.120  Write a SQL Query to find the number of prime and non-prime items that can be stored 
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




 Q.121 Write a Query to obtain the active user retention in July 2022. 
-- Output the month (in numerical format 1, 2, 3) and the number of monthly active users (MAUs).


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




 Q.122 Write a Query to report the median of searches made by a user. 
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






 Q.123 Write a Query to update the Facebook advertisers status using the daily_pay table. 
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




 Q.124 Write a SQL Query that calculates the total time that the fleet of 
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
				        )       AS stop_time
			FROM
					server_utilization
        ) temp_server_utilization;




 Q.125 Sometimes, payment transactions are repeated by accident; it could be due to user error, 
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




 Q.126 Write a SQL Query to find the bad experience rate in the first 14 days for new users who signed 
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




 Q.127 Write an SQL Query to find the total score for each gender on each day.
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




 Q.128  Write an SQL Query to find the countries where this company can invest .
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




 Q.129 Write an SQL Query to report the median of all the numbers in the database 
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




 Q.130  Write an SQL Query to report the comparison result (higher/lower/same) of the average salary of 
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




 Q.131 Write an SQL Query to report for each install date, the number of players 
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




 Q.132  Write an SQL query to find the winner in each group. Return the result table in any order.


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

->

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



 Q.133 Write an SQL Query to report for each install date, the number of players 
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




 Q.134 SAME AS Q.94



 Q.135  Write an SQL query to show the second most recent activity of each user.
 If the user only hAS one activity, return that one. A user cannot perform more than one activity at the same time.
 Return the result table in any order.


CREATE TABLE user_activity(
		username VARCHAR(20),
		activity VARCHAR(20),
		start_date DATE,
		end_date DATE
	);


INSERT INTO user_activity VALUES
		('ALICE','TRAVEL','2020-02-12','2020-02-20'),
		('ALICE','DANCING','2020-02-21','2020-02-23'),
		('ALICE','TRAVEL','2020-02-24','2020-02-28'),
		('BOB','TRAVEL','2020-02-11','2020-02-18'); 

->
        
WITH temp_activity AS (
                        SELECT 
                                username, 
                                activity, 
                                start_date, 
                                end_date,
                                ROW_NUMBER() OVER(PARTITION BY username ORDER BY start_date, end_date) row_num,
                                COUNT(*) OVER(PARTITION BY username ORDER BY start_date, end_date
                                                rows between unbounded preceding and unbounded following) total_activities
                        FROM 
                                user_activity
            ),
    temp_activity2 AS (
                        SELECT 
                                username, 
                                activity, 
                                start_date, 
                                end_date,
                                IF(total_activities = 1 and row_num = 1, 2, row_num) AS ranking
                        FROM 
                                temp_activity
            )
 
SELECT 
        username, 
        activity, 
        start_date, 
        end_date 
FROM 
        temp_activity2
WHERE 
        ranking = 2;




 Q.136 SAME AS Q.101



 Q.137 Write a query calculating the amount of error (i.e.: actual - miscalculated average monthly salaries), 
 and round it up to the next integer.


CREATE TABLE employees(
		id INT,
		name VARCHAR(20),
		salary INT
	);

INSERT INTO employees VALUES
		(1,'KRISTEEN',1420),
		(2,'ASHLEY',2006),
		(3,'JULIA',2210),
		(4,'MARIA',3000);
->

SELECT 
        ceil(avg(salary) - avg(replace(salary, '0', ''))) AS error
FROM 
        employees;







 Q.138 Write a Query identifying the type of each record in the TRIANGLES table using its three side lengths.


CREATE TABLE triangles(
		a INT,
		b INT,
		c INT
	);


INSERT INTO triangles VALUES
		(20,20,23),
		(20,20,20),
		(20,21,22),
		(13,14,30);



SELECT 
		a,
		b,
        c, 
        CASE
			WHEN a + b <= c OR b + c <= a OR a + c <= b THEN 'NOT A TRIANGLE'
			WHEN a = b AND b = c THEN 'EQUILATERAL' 
			WHEN a = b OR b = c OR c = a THEN 'ISSOCELES' 
            WHEN a <> b AND b <> c THEN 'SCALEAN'
            END AS type_of_triangle
FROM 
		triangles;




 Q.139 
->
CREATE TABLE occupations
(
  name VARCHAR(25),
  occupation VARCHAR(25)
);

INSERT INTO occupations VALUES('Samantha', 'Doctor');
INSERT INTO occupations VALUES('Julia', 'Actor');
INSERT INTO occupations VALUES('Maria', 'Actor');
INSERT INTO occupations VALUES('Meera', 'Singer');
INSERT INTO occupations VALUES('Ashely', 'Professor');
INSERT INTO occupations VALUES('Ketty', 'Professor');
INSERT INTO occupations VALUES('Christeen', 'Professor');
INSERT INTO occupations VALUES('Jane', 'Actor');
INSERT INTO occupations VALUES('Jenny', 'Doctor');
INSERT INTO occupations VALUES('Priya', 'Singer');

WITH serialized_ocp AS(
  SELECT
      name,
      occupation,
      row_number() over(partition by occupation order by name) as serial
  FROM
    occupations
)
SELECT
  MAX(CASE
    WHEN occupation = 'Doctor'
      THEN
        name
  END) AS Doctor,
  MAX(CASE
    WHEN occupation = 'Professor'
      THEN
        name
  END) AS Professor,
  MAX(CASE
    WHEN occupation = 'Singer'
      THEN
        name
  END) AS Singer,
  MAX(CASE
    WHEN occupation = 'Actor'
      THEN
        name
  END) AS Actor
FROM
  serialized_ocp
GROUP BY
  serial;


 Q.141  Write a query to find the node type of Binary Tree ordered by the value of the node. 
 Output one of the following for each node:
 ● Root: If node is root node.
 ● Leaf: If node is leaf node.
 ● Inner: If node is neither root nor leaf node.


CREATE TABLE bst(
		n INT,
		p INT
	);


INSERT INTO bst VALUES
		(1,2),
		(3,2),
		(6,8),
		(9,8),
		(2,5),
		(8,5),
		(5,NULL);

->

SELECT 
        n, 
        CASE 
            WHEN n NOT IN (SELECT DISTINCT p FROM bst WHERE p IS NOT NULL)  THEN 'Leaf'
            WHEN p IS NULL THEN 'Root'
            ELSE 'Inner'
            END AS type
FROM 
        bst
ORDER BY
         n;




 Q.142 Given the table schemas below, write a query to print the company_code, 
 founder name, total number of lead managers, total number of senior managers, 
 total number of managers, and total number of employees. Order your output by 
 ascending company_code.


CREATE TABLE company(
		company_code VARCHAR(20),
		founder VARCHAR(20)
	);


CREATE TABLE lead_manager(
		lead_manager_code VARCHAR(20),
		company_code VARCHAR(20)
	);


CREATE TABLE senior_manager(
		senior_manager_code VARCHAR(20),
		lead_manager_code VARCHAR(20),
		company_code VARCHAR(20)
	);


CREATE TABLE manager(
		manager_code VARCHAR(20),
		senior_manager_code VARCHAR(20),
		lead_manager_code VARCHAR(20),
		company_code VARCHAR(20)
	);


CREATE TABLE employee(
		employee_code VARCHAR(20),
		manager_code VARCHAR(20),
		senior_manager_code VARCHAR(20),
		lead_manager_code VARCHAR(20),
		company_code VARCHAR(20)
	);


INSERT INTO company VALUES
		('C1','MONIKA'),
		('C2','SAMANTHA');


INSERT INTO lead_manager VALUES
		('LM1','C1'),
		('LM2','C2');


INSERT INTO senior_manager VALUES
		('SM1','LM1','C1'),
		('SM2','LM1','C1'),
		('SM3','LM2','C2');    


INSERT INTO manager VALUES
		('M1','SM1','LM1','C1'),
		('M2','SM3','LM2','C2'),
		('M3','SM3','LM2','C2');  


INSERT INTO employee VALUES
		('E1','M1','SM1','LM1','C1'),
		('E2','M1','SM1','LM1','C1'),
		('E3','M2','SM3','LM2','C2'),
		('E4','M3','SM3','LM2','C2');
->


SELECT 
        c.company_code, 
        c.founder, 
        COUNT(DISTINCT lm.lead_manager_code), 
        COUNT(DISTINCT sm.senior_manager_code),
        COUNT(DISTINCT m.manager_code),
        COUNT(DISTINCT e.employee_code)
FROM 
        company c
INNER JOIN 
        lead_manager lm
ON 
        c.company_code = lm.company_code
INNER JOIN 
        senior_manager sm
ON 
        sm.lead_manager_code = lm.lead_manager_code
INNER JOIN  
        manager m
ON 
        m.senior_manager_code = sm.senior_manager_code
INNER JOIN  
        employee e
ON 
        e.manager_code = m.manager_code
GROUP BY 
        c.company_code, c.founder
ORDER BY 
        c.company_code;




 Q.143 Write a query to output all such symmetric pairs in ascENDing order by the value of X. 
 List the rows such that X1 ≤ Y1.


CREATE TABLE functions(
		x INT,
		y INT
	);


INSERT INTO functions VALUES
		(20,20),
		(20,20),
		(20,21),
		(23,22),
		(22,23),
		(21,20);

->

WITH temp_functions AS (
                        SELECT 
                                x,
                                y, 
                                ROW_NUMBER() OVER (ORDER BY x, y) AS row_num
                        FROM 
                                functions
                )

SELECT 
        DISTINCT f1.x, 
        f1.y
FROM 
        temp_functions f1
INNER JOIN 
        temp_functions f2 
ON 
        f1.x = f2.y 
AND 
        f1.y = f2.x 
AND 
        f1.row_num <> f2.row_num
WHERE 
        f1.x <= f1.y
ORDER BY 
        f1.x;



 Q.144 Write a query to output the names of those students whose best friENDs got offered a higher 
 salary than them. Names must be ordered by the salary amount offered to the best friENDs. 
 It is guaranteed that no two students get the same salary offer.


CREATE TABLE students(
		id INT,
		name VARCHAR(20)
	);


CREATE TABLE friends(
		id INT,
		friend_id INT
	);


CREATE TABLE packages(
		id INT,
		salary FLOAT
	);


INSERT INTO students VALUES
		(1,'ASHLEY'),
		(2,'SAMANTHA'),
		(3,'JULIA'),
		(4,'SCARLET');


INSERT INTO friends VALUES
		(1,2),
		(2,3),
		(3,4),
		(4,1);


INSERT INTO packages VALUES
		(1,15.20),
		(2,10.06),
		(3,11.55),
		(4,12.12);

->

SELECT 
        s1.name 
FROM 
        friends f1
INNER JOIN 
        students s1
ON 
        f1.id = s1.id
INNER JOIN 
        students s2
ON 
        f1.friend_id = s2.id
INNER JOIN 
        packages p1
ON 
        f1.id = p1.id
INNER JOIN 
        packages p2
ON 
        f1.friend_id = p2.id
WHERE 
        p1.salary < p2.salary
ORDER BY 
        p2.salary;



 Q.145 Write a query to print the respective hacker_id and name of hackers who achieved full scores for 
 more than one challenge. Order your output in descENDing order by the total number of challenges in 
 which the hacker earned a full score. If more than one hacker received full scores in the same number 
 of challenges, then sort them by ascending hacker_id.


CREATE TABLE hackers(
		hacker_id INT,
		name VARCHAR(20)
	);


CREATE TABLE difficulty(
		difficulty_level INT,
		score INT
	);


CREATE TABLE challenges(
		challenge_id INT,
		hacker_id INT,
		difficulty_level INT
	);


CREATE TABLE submissions(
		submission_id INT,
		hacker_id INT,
		challenge_id INT,
		score INT
	);


INSERT INTO hackers VALUES
		(5580,'ROSE'),
		(8439,'ANGELA'),
		(27205,'FRANK'),
		(52243,'PATRICK'),
		(52348,'LISA'),
		(57645,'KIMBERLY'),
		(77726,'BONNIE'),
		(83082,'MICHAEL'),
		(86870,'TODD'),
		(90411,'JOE');


INSERT INTO difficulty VALUES
		(1,20),
		(2,30),
		(3,40),
		(4,60),
		(5,80),
		(6,100),
		(7,120);


INSERT INTO challenges VALUES
		(4810,77726,4),
		(21089,27205,1),
		(26566,5580,7),
		(66730,52243,6),
		(71055,52243,2);
 
->

SELECT 
        h.hacker_id, 
        h.name 
FROM 
        hackers h
INNER JOIN  
        submissions s
ON 
        h.hacker_id = s.hacker_id
INNER JOIN 
        challenges c
ON 
        s.challenge_id = c.challenge_id
INNER JOIN 
        difficulty d
ON 
        c.difficulty_level = d.difficulty_level
WHERE 
        s.score = d.score
GROUP BY 
        h.name, h.hacker_id
HAVING 
        COUNT(s.score) > 1
ORDER BY 
        COUNT(s.challenge_id) desc,
        h.hacker_id;



 Q.146 Write a query to output the start and END dates of projects listed by the number of days it took 
 to complete the project in ascending order. If there is more than one project that have the same number 
 of completion days, then order by the start date of the project.



CREATE TABLE projects(
		task_id INT,
		start_date DATE,
		end_date DATE
	);


INSERT INTO projects VALUES
		(1,'2015-10-01','2015-10-02'),
		(2,'2015-10-02','2015-10-03'),
		(3,'2015-10-03','2015-10-04'),
		(4,'2015-10-13','2015-10-14'),
		(5,'2015-10-14','2015-10-15'),
		(6,'2015-10-28','2015-10-29'),
		(7,'2015-10-30','2015-10-31');



->


WITH project_start AS 
                    (
                        SELECT 
                                start_date, 
                                ROW_NUMBER() OVER() AS ps_rownum
                        FROM 
                                projects
                        WHERE start_date not in (
                                                    SELECT 
                                                            end_date 
                                                    FROM 
                                                            projects
                                                )
                    ),
    project_end AS 
                 (
                        SELECT 
                                end_date, 
                                ROW_NUMBER() OVER() AS pe_rownum
                        FROM 
                                projects
                        WHERE 
                                END_date not in (
                                                    SELECT 
                                                            start_date 
                                                    FROM 
                                                            projects
                                                )
                )

SELECT 
        project_start.start_date, 
        project_end.end_date
FROM 
        project_start
INNER JOIN 
        project_end
on 
        project_end.pe_rownum = project_start.ps_rownum
ORDER BY 
        DATEDIFF(project_start.start_date, project_end.end_date) desc, 
        project_start.start_date;




 Q.147 In an effort to identify high-value customers, Amazon asked for your help to obtain data 
 about users who go on shopping sprees. A shopping spree occurs when a user makes purchASes on 3 
 or more consecutive days. List the user IDs who have gone on at leASt 1 shopping spree in ascending order.


CREATE TABLE transactions(
		user_id INT,
		amount FLOAT,
		transaction_date DATETIME
	);


INSERT INTO transactions VALUES
		(1,9.99,'08/01/2022 10:00:00'),
		(1,55,'08/17/2022 10:00:00'),
		(2,149.5,'08/05/2022 10:00:00'),
		(2,4.89,'08/06/2022 10:00:00'),
		(2,34,'08/07/2022 10:00:00');

->

SELECT 
        DISTINCT user_id 
FROM 
    (
        SELECT 
                user_id, 
                transaction_date,
                rn,
                transaction_date :: date - rn::integer,
                COUNT(transaction_date :: date - rn::integer) OVER(PARTITION BY user_id) AS cn
        FROM
                (
                    SELECT 
                            user_id, 
                            transaction_date,
                            ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rn
                    FROM 
                            transactions
                ) temp
    )temp1

WHERE cn >=3;



 Q.148 You are given a table of PayPal payments showing the payer, the recipient, and the amount paid. 
 A two-way unique relationship is established WHEN two people sEND money back and forth. Write a query 
 to find the number of two-way unique relationships in this data.


CREATE TABLE payments(
		payer_id INT,
		recipient_id INT,
		amount INT
	);


INSERT INTO payments VALUES
		(101,201,30),
		(201,101,10),
		(101,301,20),
		(301,101,80),
		(201,301,70);
->

WITH temp_payments AS (
                        SELECT 
                                DISTINCT p1.payer_id, 
                                p1.recipient_id
                        FROM 
                                payments p1 
                        INNER JOIN 
                                payments p2
                        ON 
                                p1.payer_id = p2.recipient_id
                        AND 
                                p2.payer_id = p1.recipient_id
                        AND 
                                p1.payer_id < p2.payer_id
        )

SELECT 
        COUNT(*) unique_relationships
FROM 
        temp_payments;



 Q.149 Write a query to obtain the list of customers whose first transaction was valued at $50 or more.
 Output the number of users.


CREATE TABLE user_transactions(
		transaction_id INT,
		user_id INT,
		spend FLOAT,
		transaction_date VARCHAR(30)
	);


INSERT INTO user_transactions VALUES
		(759274,111,49.50,'02/03/2022 00:00:00'),
		(850371,111,51.00,'03/15/2022 00:00:00'),
		(615348,145,36.30,'03/22/2022 00:00:00'),
		(137424,156,151.00,'04/04/2022 00:00:00'),
		(248475,156,87.00,'04/16/2022 00:00:00');

->

WITH temp_transactions AS (
                            SELECT 
                                    user_id, 
                                    transaction_date, 
                                    spend,
                                    ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) row_num 
                            FROM 
                                    user_transactions
                    )

SELECT 
        COUNT(DISTINCT user_id) as users
FROM 
        temp_transactions
WHERE 
        row_num = 1 
        and 
        spend >= 50;



 Q.150 Write a query to obtain the SUM of the odd-numbered and even-numbered meASurements on a particular day, 
 in two different columns.


CREATE TABLE measurments(
		measurment_id INT,
		measurment_value FLOAT,
		measurment_time DATETIME
	);


INSERT INTO measurments VALUES
		(131233,1109.51,'07/10/2022 09:00:00'),
		(135211,1662.74,'07/10/2022 11:00:00'),
		(523542,1246.24,'07/10/2022 13:15:00'),
		(143562,1124.50,'07/11/2022 15:00:00'),
		(346462,1234.14,'07/11/2022 16:45:00');

->

WITH temp_measurments AS (
                            SELECT
                                    measurement_value,
                                    measurement_time,
                                    ROW_NUMBER() OVER(PARTITION BY measurement_time::DATE ORDER BY measurement_time) row_num
                            FROM 
                                    measurments
                )

SELECT 
        measurement_time::DATE,,
        ROUND(SUM(
            CASE
                WHEN row_num % 2 <> 0 THEN measurment_value
                END),2) AS odd_value,
        ROUND(SUM(
            CASE
                WHEN row_num % 2 = 0 THEN measurment_value
                END),2) AS even_value
FROM 
        temp_measurments
GROUP BY 
        measurement_time::DATE,
ORDER BY 
        measurement_time;





 Q.151 In an effort to identify high-value customers, Amazon asked for your help to obtain data 
 about users who go on shopping sprees. A shopping spree occurs when a user makes purchASes on 3 
 or more consecutive days. List the user IDs who have gone on at leASt 1 shopping spree in ascending order.


CREATE TABLE transactions(
		user_id INT,
		amount FLOAT,
		transaction_date DATETIME
	);


INSERT INTO transactions VALUES
		(1,9.99,'08/01/2022 10:00:00'),
		(1,55,'08/17/2022 10:00:00'),
		(2,149.5,'08/05/2022 10:00:00'),
		(2,4.89,'08/06/2022 10:00:00'),
		(2,34,'08/07/2022 10:00:00');

->

SELECT 
        DISTINCT user_id 
FROM 
    (
        SELECT 
                user_id, 
                transaction_date,
                rn,
                transaction_date :: date - rn::integer,
                COUNT(transaction_date :: date - rn::integer) OVER(PARTITION BY user_id) AS cn
        FROM
                (
                    SELECT 
                            user_id, 
                            transaction_date,
                            ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rn
                    FROM 
                            transactions
                ) temp
    )temp1

WHERE cn >=3;




 Q.152 The Airbnb Booking RecommENDations team is trying to understand the "substitutability" of two rentals 
 and whether one rental is a good substitute for another. They want you to write a query to find the unique 
 combination of two Airbnb rentals WITH the same exact amenities offered. Output the COUNT of the unique 
 combination of Airbnb rentals.


CREATE TABLE rental_amenities(
		rental_id INT,
		amenity VARCHAR(20)
	);


INSERT INTO rental_amenities VALUES
		(123,'POOL'),
		(123,'KITCHEN'),
		(234,'HOT TUB'),
		(234,'FIREPLACE'),
		(345,'KITCHEN'),
		(345,'POOL'),
		(456,'POOL');

->

WITH temp_amenities AS (
                        SELECT 
                                rental_id, 
                                amenity, 
                                COUNT(amenity) over(partition by rental_id) AS no_of_amenities 
                        FROM 
                                rental_amenities
            ),

temp_amenities2 AS (
                        SELECT 
                                COUNT(*) 
                        FROM 
                                temp_amenities a
                        inner join 
                                temp_amenities b 
                        on 
                                a.no_of_amenities = b.no_of_amenities
                        AND 
                                a.amenity = b.amenity
                        AND 
                                a.rental_id<>b.rental_id
                        GROUP BY 
                                a.rental_id,
                                b.rental_id, 
                                a.no_of_amenities
                        HAVING 
                                COUNT(*) = a.no_of_amenities
            )


SELECT 
        CEIL(COUNT(*)/2) as matching_airbnb
FROM 
        temp_amenities2;




 Q.153 Write a query to calculate the return on ad spend (ROAS) for each advertiser 
 across all ad campaigns. Round your answer to 2 decimal places, and order your 
 output by the advertiser_id.


CREATE TABLE ad_campaigns(
		campaign_id INT,
		spend INT,
		revenue FLOAT,
		advertiser_id INT
	);


INSERT INTO ad_campaigns VALUES
		(1,5000,7500,3),
		(2,1000,900,1),
		(3,3000,12000,2),
		(4,500,200,4),
		(5,100,400,4);
->

SELECT 
        advertiser_id, 
        CAST(SUM(revenue) / SUM(spend) AS Decimal(8,2)) AS ROAS
FROM 
        ad_campaigns
GROUP BY 
        advertiser_id
ORDER BY 
        advertiser_id;



 Q.154 Write a query that shows the following data for each compensation outlier: 
 employee ID, salary, and whether they are potentially overpaid or potentially underpaid


CREATE TABLE employee_pay(
		employee_id INT,
		salary INT,
		title VARCHAR(20)
	);


INSERT INTO employee_pay VALUES
		(101,80000,'DATA ANALYST'),
		(102,90000,'DATA ANALYST'),
		(103,100000,'DATA ANALYST'),
		(104,30000,'DATA ANALYST'),
		(105,120000,'DATA SCIENTIST'),
		(106,100000,'DATA SCIENTIST'),
		(107,80000,'DATA SCIENTIST'),
		(108,310000,'DATA SCIENTIST');

->

WITH temp_compensation AS (
                            SELECT 
                                    employee_id,
                                    salary,
                                    title,
                                    ROUND(AVG(salary) over(PARTITION BY title),2) AS avg_salary 
                            FROM 
                                    employee_pay
                          ),
    temp_compensation2 AS (
                            SELECT
                                    employee_id, 
                                    salary,
                                    CASE
                                        WHEN salary > 2 * avg_salary THEN 'Overpaid'
                                        WHEN salary < avg_salary/2 THEN 'Underpaid'
                                        END AS status
                            FROM 
                                    temp_compensation
                )

SELECT 
        employee_id, 
		salary, 
		status
FROM 
        temp_compensation2 
WHERE 
        status is not null;



 Q.155 
->

CREATE TABLE payments
(
  payer_id INT,
  recipient_id INT,
  amount INT
);

INSERT INTO payments VALUES(101, 201, 30);
INSERT INTO payments VALUES(201, 101, 10);
INSERT INTO payments VALUES(101, 301, 20);
INSERT INTO payments VALUES(301, 101, 80);
INSERT INTO payments VALUES(201, 301, 70);

SELECT
  ROUND(COUNT(
    distinct p1.payer_id,
    p1.recipient_id
  )/2) AS unique_relationships
FROM
  payments p1
  JOIN payments p2 ON p1. payer_id = p2.recipient_id
    AND p1.recipient_id = p2.payer_id;



 Q.156 Assume you are given the table below containing information on user
 purchASes. Write a query to obtain the number of users who purchASed the 
 same product on two or more different days. Output the number of unique users.


CREATE TABLE purchases(
		user_id INT,
		product_id INT,
		quantity INT,
		purchase_date DATETIME
	);


INSERT INTO purchases VALUES
		(536,3223,6,'2022-01-11 12:33:44'),
		(827,3585,35,'2022-02-20 14:05:26'),
		(536,3223,5,'2022-03-02 09:33:28'),
		(536,1435,10,'2022-03-02 08:40:00'),
		(827,2452,45,'2022-04-09 00:00:00');

->

SELECT 
        COUNT(DISTINCT user_id) AS repeat_purchasers
FROM (
        SELECT 
                user_id 
        FROM 
                purchases
        GROUP BY 
                user_id, 
                product_id
        HAVING 
                COUNT(DISTINCT purchase_date) > 1
    ) temp;



 Q.157 Say you have access to all the transactions for a given merchant acCOUNT. 
 Write a query to print the cumulative balance of the merchant acCOUNT at the END 
 of each day, WITH the total balance reset back to zero at the END of the month. 
 Output the transaction date and cumulative balance.


CREATE TABLE transactions(
		transaction_id INT,
		type ENUM('DEPOSIT','WITHDRAWL'),
		amount FLOAT,
		transaction_date DATETIME
	);


INSERT INTO transactions VALUES
		(19153,'DEPOSIT',65.90,'07/10/2022 10:00:00'),
		(53151,'DEPOSIT',178.55,'07/08/2022 10:00:00'),
		(29776,'WITHDRAWL',25.90,'07/08/2022 10:00:00'),
		(16461,'WITHDRAWL',45.99,'07/08/2022 10:00:00'),
		(77134,'DEPOSIT',32.60,'07/10/2022 10:00:00');

->

SELECT 
        DISTINCT date(transaction_date),
        SUM(
            CASE 
                WHEN type = 'deposit' THEN amount
                ELSE -amount
                END
            ) OVER(PARTITION BY EXTRACT(MONTH FROM transaction_date) ORDER BY DATE(transaction_date)) AS balance
FROM 
        transactions;




 Q.158 Assume you are given the table below containing information on 
 Amazon customers and their spend on products belonging to various 
 categories. Identify the top two highest-grossing products within each 
 category in 2022. Output the category, product, and total spend.


CREATE TABLE product_spend(
		category VARCHAR(20),
		product VARCHAR(20),
		user_id INT,
		spend FLOAT,
		transaction_date DATETIME
	);


INSERT INTO product_spend VALUES
		('APPLIANCE','REFRIGERATOR',165,246.00,'12/26/2021 12:00:00'),
		('APPLIANCE','REFRIGERATOR',123,299.99,'03/02/2022 12:00:00'),
		('APPLIANCE','WASHING MACHINE',123,219.80,'03/02/2022 12:00:00'),
		('ELECTRONICS','VACUUM',178,152.00,'04/05/2022 12:00:00'),
		('ELECTRONICS','WIRELESS HEADSET',156,249.90,'07/08/2022 12:00:00'),
		('ELECTRONICS','REFRIGERATOR',145,189.00,'07/15/2022 12:00:00');
->

WITH temp_product_details AS (
                                SELECT 
                                        category, 
                                        product,
                                        spend,
                                        SUM(spend) OVER(PARTITION BY category, product) total_spend
                                FROM 
                                        product_spend
                                WHERE 
                                        EXTRACT(YEAR FROM transaction_date) = 2022
                 ),

    temp_product_details1 AS (
                                SELECT 
                                        DISTINCT category, 
                                        product, 
                                        total_spend ,
                                        DENSE_RANK() OVER(PARTITION BY category order by total_spend desc) row_num
                                FROM 
                                        temp_product_details
               )


SELECT 
        DISTINCT category, 
        product, 
        total_spend 
FROM 
        temp_product_details1 
WHERE 
        row_num <=2
ORDER BY 
        category, 
        total_spend DESC;



 Q.159 Facebook is analysing its user signup data for June 2022. 
 Write a query to generate the churn rate by week in June 2022. 
 Output the week number (1, 2, 3, 4, ...) and the corresponding 
 churn rate rounded to 2 decimal places.


CREATE TABLE users(
		user_id INT,
		signup_date DATETIME,
		last_login DATETIME
	);


INSERT INTO users VALUES
		(1001,'2022-06-01 12:00:00','2022-07-05 12:00:00'),
		(1002,'2022-06-03 12:00:00','2022-06-15 12:00:00'),
		(1004,'2022-06-02 12:00:00','2022-06-15 12:00:00'),
		(1006,'2022-06-15 12:00:00','2022-06-27 12:00:00'),
		(1012,'2022-06-16 12:00:00','2022-07-22 12:00:00');



-- Approach 1



WITH temp_churn_rate AS (
                        SELECT 
                                user_id, 
                                signup_date, 
                                last_login,
                                DATEDIFF(last_login, signup_date) diff, 
                                EXTRACT(WEEK FROM signup_date) AS week_no,
                                WEEK(signup_date,5) -  WEEK(DATE_SUB(signup_date, INTERVAL DAYOFMONTH(signup_date)-1 DAY),5)+1 AS ranking
                        FROM 
                                users
                        WHERE 
                                EXTRACT(MONTH FROM signup_date) = 6 
                                AND
                                EXTRACT(YEAR FROM signup_date) = 2022
),
temp_churn_rate2 AS (
                        SELECT 
                                ranking, 
                                COUNT(ranking) AS total_users,
                                COUNT(
                                CASE 
                                    WHEN diff <= 28 THEN 1
                                    END 
                                    ) AS total_churns 
                        FROM 
                                temp_churn_rate
                        GROUP BY 
                                ranking
)

SELECT 
        ranking AS week, 
        ROUND((total_churns/total_users) * 100 ,2) AS churn_rate
FROM 
        temp_churn_rate2
ORDER BY 
        ranking;
        
