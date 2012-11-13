/* a personal mysql todo */

DROP database IF EXISTS todo;
CREATE database todo;

USE todo;

DROP TABLE IF EXISTS list;
CREATE TABLE list(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	priority smallint,
	todo text,
	project varchar(30),
	date_created timestamp NOT NULL,
	FULLTEXT KEY(todo)
	)ENGINE=MyISAM;
	
DROP TABLE IF EXISTS done;
CREATE TABLE done(
	id int,
	priority smallint,
	todo text,
	project varchar(30),
	date_created datetime,
	date_completed timestamp NOT NULL,
	FULLTEXT KEY(todo)
	)ENGINE=MyISAM;

/* create a new todo */

DROP PROCEDURE IF EXISTS new;

DELIMITER $$

CREATE PROCEDURE new(
	priority_in smallint,
	todo_in varchar(100),
	project_in varchar(30))
BEGIN
	
	INSERT INTO list(priority,todo,project)
	VALUES(priority_in,todo_in,project_in);

END;

$$

DELIMITER ;
	
/* list todos order by project then priority */

DROP PROCEDURE IF EXISTS list;

DELIMITER $$

CREATE PROCEDURE list()
BEGIN
	SELECT priority,id,todo,project
	FROM list
	ORDER BY priority,project,date_created DESC;

END;

$$

DELIMITER ;

/* list todos with a particular context */

DROP PROCEDURE IF EXISTS context;

DELIMITER $$

CREATE PROCEDURE context(context_in varchar(30))
BEGIN
	SELECT id,priority,todo,project
	FROM list
	WHERE MATCH todo AGAINST (context_in IN BOOLEAN MODE)
	ORDER BY priority;

END;

$$

DELIMITER ;

/* list todos for a particular project */

DROP PROCEDURE IF EXISTS project;

DELIMITER $$

CREATE PROCEDURE project(project_in varchar(30))
BEGIN
	SELECT id,priority,todo,project
	FROM list
	WHERE project=project_in
	ORDER BY priority;

END;

$$

DELIMITER ;
	
/* move completed task to done table and delete from list */

DROP PROCEDURE IF EXISTS do;

DELIMITER $$

CREATE PROCEDURE do(id_in int)
BEGIN
	DECLARE ListId_v int;
	DECLARE Priority_v smallint;
	DECLARE Todo_v text;
	DECLARE Project_v varchar(30);
	DECLARE DateCreated_v datetime;
	
	SELECT id,priority,todo,project,date_created INTO ListId_v,Priority_v,Todo_v,Project_v,DateCreated_v
	FROM todo.list
	WHERE id_in=id;

	INSERT INTO done(id,priority,todo,project,date_created)
	VALUES (ListId_v,Priority_v,Todo_v,Project_v,DateCreated_v);
	
	DELETE FROM list
	WHERE id_in=list.id;

END;

$$

DELIMITER ;

/* change the priority level of a task */

DROP PROCEDURE IF EXISTS priority;

DELIMITER $$

CREATE PROCEDURE priority(
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

/* export list to skydrive (or dropbox) - you will need to add permissions to mysql, and delete todo.txt before running a second time */

DROP PROCEDURE IF EXISTS skydrive;

DELIMITER $$

CREATE PROCEDURE skydrive()
BEGIN
	
	SELECT id,priority,todo,project 
	INTO OUTFILE '/Users/trip/SkyDrive/todo/todo.txt'
	LINES TERMINATED BY '\n'
	FROM list
	ORDER BY project,priority;

END;

$$

DELIMITER ;

/* list last 20 completed todos ascending */

DROP PROCEDURE IF EXISTS done;

DELIMITER $$

CREATE PROCEDURE done()
BEGIN
	SELECT id,priority,todo,project,date_completed
	FROM done
	ORDER BY date_completed DESC
	LIMIT 20;

END;

$$

DELIMITER ;

/* text search for completed tasks */

DROP PROCEDURE IF EXISTS find;

DELIMITER $$

CREATE PROCEDURE find(find_in text)
BEGIN
	SELECT id,priority,todo,project,date_completed 
	FROM done
	WHERE MATCH todo AGAINST (find_in IN BOOLEAN MODE)
	ORDER BY date_completed;


END;

$$

DELIMITER ;
