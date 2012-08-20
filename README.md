A Todo List Manager as a MySQL Database
=======================================

Are you a MySQL DBA or have the mysql client open all the time? Do you want a cross 
platform todo list manager?  This (ridiculous waste of time?) may be for you. I have created a few 
stored procedures to do the work. Inspired by Gina Trapani's [todo.txt](https://github.com/ginatrapani/todo.txt-cli).

Installation
------------

	mysql -u username -p -h localhost < todo.my.sql

Usage
-----

Start MySQL client

	mysql -u username -p
	
	mysql> use todo;

To add a new todo, ('task',priority level,'context','project')
	
	 mysql> call new('buy milk',1,'errand','');

To list todos by project then priority
	
	mysql> call list;
	+----+-------------------------------+----------+----------+---------+---------------------+
	| id | todo                          | priority | context  | project | date_created        |
	+----+-------------------------------+----------+----------+---------+---------------------+
	|  1 | get sql queries from backup   |        1 | computer | NULL    | 2012-08-04 06:27:18 |
	|  3 | order good to go card         |        1 | computer | NULL    | 2012-08-04 06:27:18 |
	|  4 | write thankyou note           |        1 | home     | NULL    | 2012-08-04 06:27:18 |
	|  5 | sched eye exam for son        |        2 | call     | NULL    | 2012-08-09 15:03:59 |
	|  6 | buy Scott gift card thank you |        2 | errand   | NULL    | 2012-08-09 15:09:36 |
	|  9 | organized DVD collection      |        4 | home     | NULL    | 2012-08-09 16:29:27 |
	| 10 | scan notebook in to pdf       |        4 | home     | NULL    | 2012-08-09 16:30:37 |
	+----+-------------------------------+----------+----------+---------+---------------------+
	
To list all todos with a specific context
	
	mysql> call context('errand');
	+----+-------------------------------+----------+----------+---------+---------------------+
	| id | todo                          | priority | context  | project | date_created        |
	+----+-------------------------------+----------+----------+---------+---------------------+
	|  6 | buy Scott gift card thank you |        2 | errand   | NULL    | 2012-08-09 15:09:36 |
	+----+-------------------------------+----------+----------+---------+---------------------+


To list all todos for a specific project
	
	mysql> call project('launch');
	
To mark complete, remove from list, and copy to done table for archiving	
	
	mysql> call do(14);

To list the last 20 completed todos in descending order

	mysql> call done;
	
To change a priority level, first input is id of task and second is new priority

	mysql> call priority(1,2);
	
To export list to skydrive (or dropbox) - this is a work in progress as you have to add mysql user permissions to folder and mysql cannot overwrite an existing file for security reasons.  So, you need to delete the exported file (todo.txt) to run this again. It's a kludge.

	mysql> call skydrive;
	




