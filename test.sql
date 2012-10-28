	SELECT id,todo,priority,project,context,date_completed
	FROM done
	WHERE todo LIKE '%sched%'
	ORDER BY date_completed;
	
	
	DROP PROCEDURE IF EXISTS find;

DELIMITER $$

CREATE PROCEDURE find(find_in text)
BEGIN
	SELECT id,todo,priority,project,context,date_completed 
	FROM done
	WHERE todo LIKE find_in
	ORDER BY date_completed;


END;

$$

DELIMITER ;




"%Y%m%d%H%i%s"

DROP PROCEDURE IF EXISTS skydrive;

DELIMITER $$

CREATE PROCEDURE skydrive()
BEGIN
	
	SELECT id,priority,todo,context,project 
	INTO OUTFILE '/Users/trip/SkyDrive/todo/"NOW()"todo.txt'
	LINES TERMINATED BY '\n'
	FROM list
	ORDER BY project,priority;

END;

$$

DELIMITER ;

CONCAT (
       "SELECT '	SELECT id,priority,todo,context,project 
	LINES TERMINATED BY '\n'
	FROM list
	ORDER BY project,priority;' into outfile '"
       , DATE_FORMAT( NOW(), '%Y%m%d')
       , ".txt'"
    );