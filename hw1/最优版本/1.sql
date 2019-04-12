use University;

DROP VIEW IF EXISTS
top_10_instr;
Drop VIEW IF EXISTS
course_teaches;

/* Find the instructor whose salary is top 10%  */
CREATE VIEW top_10_instr
AS
    SELECT id, name
    FROM instructor
    ORDER BY salary DESC
LIMIT 5;

/* Get the course they teach */
CREATE VIEW course_teaches
AS
	SELECT  name as teacher_name,
			title as course_name,
			id as teacher_id,
            course_id
	FROM (top_10_instr NATURAL JOIN teaches) 
			NATURAL JOIN course
;

/* Get the popularity of teachers */
SELECT teacher_name, course_name, count(*) as num_of_stu
FROM course_teaches NATURAL JOIN takes
GROUP BY teacher_name, course_name
;

/*
// Second solution
use University;
select T.name,course.title,count(takes.ID)
from (select distinct ID, name
		  from (select instructor.* ,@num :=@num + 1 as row_num
		            from instructor,(select @num := 0) as b
					order by salary desc) as base
		  where base.row_num <= (@num * 0.1)) as T,takes,teaches,course
where teaches.ID = T.ID and takes.course_id = teaches.course_id and takes.course_id = course.course_id
group by T.name,course.title;
*/
/*
// Third solution

use University;
select T.name, title, count(takes.ID)
from (select ID, name, ntile(10) over (order by salary desc)as s_rank
	  from instructor) as T, teaches, course, takes
where T.s_rank = 1 
	and T.ID = teaches.ID 
	and teaches.course_id = course.course_id 
	and course.course_id = takes.course_id
group by T.name, title;
*/