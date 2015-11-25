A Todo List Manager as a MySQL Database
=======================================

Are you a MySQL DBA or have the mysql client open all the time? Do you want a cross
platform todo list manager?  This (ridiculous waste of time?) may be for you. I have created a few
stored procedures to do the work. Inspired by Gina Trapani's [todo.txt](https://github.com/ginatrapani/todo.txt-cli). ver 0.3

Installation
------------

	mysql -u username -p -h localhost < todo.my.sql

Usage
-----

Start MySQL client

	mysql -u username -p

	mysql> use todo;

Suggested operators are used for filtering

	@ - Context
	# - Project
	\ - People

To add a new todo, (priority level,'task with @context')

	 mysql> call new(1,'buy milk @errand #home');

To list todos by priority then project

	mysql> call list;
	+----+----------+------------------------------------------------------+
	| id | priority | todo                                                 |
	+----+----------+------------------------------------------------------+
	| 12 |        1 | create inbox process for kiddos school forms @desk   |
	| 10 |        1 | create perl todo list manager @computer              |
	|  3 |        2 | order good to go card @computer                      |
	|  5 |        2 | buy \beth 1/2 violin @errand #home                   |
	| 11 |        2 | glue camera lens cap to strap @desk                  |
	|  4 |        3 | sched eye exam for scott @call #home                 |
	|  6 |        3 | call doc to schedule ingrown tow fix @call           |
	|  8 |        4 | organized DVD collection @desk                       |
	|  9 |        4 | scan notebook in to pdf @computer                    |
	|  7 |        4 | create wordpress.com acct for @computer              |
	+----+----------+------------------------------------------------------+

To list all todos with a specific context, project or person

	mysql> call filter('@errand');
	+----+----------+-----------------------------+
	| id | priority | todo                        |
	+----+----------+-----------------------------+
	|  5 |        2 | buy beth 1/2 violin @errand |
	+----+----------+-----------------------------+

To mark complete, remove from list, and copy to done table for archiving

	mysql> call do(14);

To list the last 20 completed todos in descending completion order

	mysql> call done;

To change a priority level, first input is id of task and second is new priority

	mysql> call pri(1,2);

To append text to the end of a task (make sure there is a preceding space if desired)

	mysql> call append(23,' something at the end');

To prepend text to the beginning of a task (make sure there is a trailing space if desired)

	mysql> call prepend(23,'something at the beginning ');

To export list to onedrive (or dropbox) - this is a work in progress as you have to add mysql user permissions to folder and mysql cannot overwrite an existing file for security reasons.  So, you need to delete the exported file (todo.txt) to run this again. It's a kludge.

	mysql> call onedrive;

To search _completed_ tasks - this feature is not working as I would like.  It will only match on whole words and exact phrases of four(4) characters or more right now.

	mysql> call find('apple');

To display help.

	mysql> call help;
