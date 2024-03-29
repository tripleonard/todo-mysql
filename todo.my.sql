/* a personal mysql todo */

DROP database IF EXISTS todo;
CREATE database todo;

USE todo;

DROP TABLE IF EXISTS list;
CREATE TABLE list(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	priority smallint,
	todo text,
	date_created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FULLTEXT KEY(todo)
	)ENGINE=MyISAM;

DROP TABLE IF EXISTS done;
CREATE TABLE done(
	id int,
	priority smallint,
	todo text,
	date_created datetime,
	date_completed timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FULLTEXT KEY(todo)
	)ENGINE=MyISAM;

DROP TABLE IF EXISTS help;
CREATE TABLE help(
	command text,
	purpose text,
  example text
	)ENGINE=MyISAM;

INSERT INTO help(command,purpose,example)
VALUES
  ('new','add a new todo','mysql> call new(1,\'buy milk @errand #home\')\;'),
  ('list','list all open todos by by priority','mysql> call list\;'),
  ('filter','list all todos with a specific context, project, or person','mysql> call filter(\'@errand\')\;'),
  ('do','mark todo complete, remove from active todo list and insert into done table with completion date','mysql> call do(14)\;'),
  ('done','list the most recent 20 items from done list','mysql> call done\;'),
  ('pri','change priority of an item (id,priority level)','mysql> call pri(1,2)\;'),
  ('append','add text to the end of a todo item (make sure it starts with a space)','mysql> call append(23,\' something at the end\')\;'),
  ('prepend','add text to the beginnng of an item','mysql> call prepend(23,\'something at the beginning \')\;'),
  ('onedrive','export task list to local file system (caveat, see README.md','mysql> call onedrive\;'),
  ('find','full text search enabled by MYISAM engine (caveat, see README.md)','mysql> call find(\'apple\')\;');

/* create a new todo */

DROP PROCEDURE IF EXISTS new;

DELIMITER $$

CREATE PROCEDURE new(
	priority_in smallint,
	todo_in text)
BEGIN

	INSERT INTO list(priority,todo)
	VALUES(priority_in,todo_in);

END;

$$

DELIMITER ;

/* list todos order by project then priority */

DROP PROCEDURE IF EXISTS list;

DELIMITER $$

CREATE PROCEDURE list()
BEGIN
	SELECT priority,id,todo
	FROM list
	ORDER BY priority,date_created DESC;

END;

$$

DELIMITER ;

/* filter todos with a particular context or of a particular project */

DROP PROCEDURE IF EXISTS filter;

DELIMITER $$

CREATE PROCEDURE filter(filter_in varchar(30))
BEGIN
	SELECT priority,id,todo
	FROM list
	WHERE MATCH todo AGAINST (filter_in IN BOOLEAN MODE)
	ORDER BY priority;

END;

$$

DELIMITER ;

/* move completed task to done table and delete from list table */

DROP PROCEDURE IF EXISTS do;

DELIMITER $$

CREATE PROCEDURE do(id_in int)
BEGIN
	DECLARE ListId_v int;
	DECLARE Priority_v smallint;
	DECLARE Todo_v text;
	DECLARE DateCreated_v datetime;

	SELECT id,priority,todo,date_created INTO ListId_v,Priority_v,Todo_v,DateCreated_v
	FROM todo.list
	WHERE id_in=id;

	INSERT INTO done(id,priority,todo,date_created)
	VALUES (ListId_v,Priority_v,Todo_v,DateCreated_v);

	DELETE FROM list
	WHERE id_in=list.id;

END;

$$

DELIMITER ;

/* change the priority level of a task 'call pri(ID_Number,New_Priority);' */

DROP PROCEDURE IF EXISTS priority;

DELIMITER $$

CREATE PROCEDURE pri(
	id_in smallint,
	priority_in smallint)
BEGIN
	UPDATE list SET priority=priority_in
	WHERE id_in=list.id;

END;

$$

DELIMITER ;

/* append text to a task a task */

DROP PROCEDURE IF EXISTS append;

DELIMITER $$

CREATE PROCEDURE append(
	id_in smallint,
	append_in text)
BEGIN
	DECLARE OldText_v text;
	DECLARE NewText_v text;

	SELECT todo INTO OldText_v
	FROM list
	WHERE id_in=list.id;

	SELECT CONCAT(OldText_v, append_in) INTO NewText_v;

	UPDATE list SET todo=NewText_v
	WHERE id_in=list.id;

END;

$$

DELIMITER ;

/* prepend text to a task a task */

DROP PROCEDURE IF EXISTS prepend;

DELIMITER $$

CREATE PROCEDURE prepend(
	id_in smallint,
	prepend_in text)
BEGIN
	DECLARE OldText_v text;
	DECLARE NewText_v text;

	SELECT todo INTO OldText_v
	FROM list
	WHERE id_in=list.id;

	SELECT CONCAT(prepend_in, OldText_v) INTO NewText_v;

	UPDATE list SET todo=NewText_v
	WHERE id_in=list.id;

END;

$$

DELIMITER ;

/* export list to onedrive (or dropbox) - you will need to add folder permissions to mysql, and delete todo.txt before running a second time */

DROP PROCEDURE IF EXISTS onedrive;

DELIMITER $$

CREATE PROCEDURE onedrive()
BEGIN

	SELECT priority,todo
	INTO OUTFILE '/Users/trip/onedrive/todo/todo.txt'
	LINES TERMINATED BY '\n'
	FROM list
	ORDER BY priority;

END;

$$

DELIMITER ;

/* list last 20 completed todos ascending */

DROP PROCEDURE IF EXISTS done;

DELIMITER $$

CREATE PROCEDURE done()
BEGIN
	SELECT id,priority,todo,date_completed
	FROM done
	ORDER BY date_completed DESC
	LIMIT 20;

END;

$$

DELIMITER ;

/* text search for completed tasks in done table */

DROP PROCEDURE IF EXISTS find;

DELIMITER $$

CREATE PROCEDURE find(find_in text)
BEGIN
	SELECT id,priority,todo,date_completed
	FROM done
	WHERE MATCH todo AGAINST (find_in IN BOOLEAN MODE)
	ORDER BY date_completed;

END;

$$

DELIMITER ;

/* show help */

DROP PROCEDURE IF EXISTS help;

DELIMITER $$

CREATE PROCEDURE help()
BEGIN
	SELECT command,purpose,example
	FROM help;

END;

$$

DELIMITER ;
