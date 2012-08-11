A Todo List Manager as a MySQL Database
=======================================

Are you a MySQL DBA or have the mysql client open all the time? Do you want a cross 
platform todo list manager?  This (waste of time?) may be for you. I have created a few 
stored procedures to do the work.

Installation
------------

	mysql -u username -p -h localhost < todo.my.sql

Usage
-----

Start MySQL client

	mysql -u username -p
	
	use todo;

To add a new todo
	
	 call new('buy milk',1,'errand','');

To list todos by priority
	
	call list;
	+----+-------------------------------+----------+----------+---------+---------------------+
	| id | todo                          | priority | context  | project | date_created        |
	+----+-------------------------------+----------+----------+---------+---------------------+
	|  1 | get sql queries from backup   |        1 | computer | NULL    | 2012-08-04 06:27:18 |
	|  3 | order good to go card         |        1 | computer | NULL    | 2012-08-04 06:27:18 |
	|  4 | write thankyou                |        1 | home     | NULL    | 2012-08-04 06:27:18 |
	|  5 | sched eye exam for frankie    |        2 | call     | NULL    | 2012-08-09 15:03:59 |
	|  6 | buy Scott gift card thank you |        2 | errand   | NULL    | 2012-08-09 15:09:36 |
	|  9 | organized DVD collection      |        4 | home     | NULL    | 2012-08-09 16:29:27 |
	| 10 | scan notebook in to pdf       |        4 | home     | NULL    | 2012-08-09 16:30:37 |
	+----+-------------------------------+----------+----------+---------+---------------------+
	
To list all todos with a specific context
	
	call context('errand');
	+----+-------------------------------+----------+----------+---------+---------------------+
	| id | todo                          | priority | context  | project | date_created        |
	+----+-------------------------------+----------+----------+---------+---------------------+
	|  6 | buy Scott gift card thank you |        2 | errand   | NULL    | 2012-08-09 15:09:36 |
	+----+-------------------------------+----------+----------+---------+---------------------+


To list all todos for a specific project
	
	call project('launch');
	
To mark complete, removes from list, and copies to done table for archiving	
	
	call do(14);

To list the last 20 completed todos in descending order

	call done;
	
Fork and pull to contrubute. Thanks!


