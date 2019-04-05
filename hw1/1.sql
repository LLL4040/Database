use university;
select T.ID, title, count(takes.ID)
from (select ID, ntile(10)over(order by salary desc)as s_rank
	  from instructor) as T, teaches, course, takes
where T.s_rank = 1 and T.ID = teaches.ID and teaches.course_id = course.course_id and course.course_id = takes.course_id
group by T.ID, title;
