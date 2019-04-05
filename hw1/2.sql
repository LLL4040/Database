use university;

drop function if exists course_ratio;
delimiter $$
create function course_ratio(d_name varchar(20))
returns decimal(3,1)
reads sql data
deterministic
begin
	declare done bool default false;
	declare num int;
	declare s_num int default 0;
    declare c_num int default 0;
    declare ratio decimal(3,1);
	declare c cursor for 
		select count(distinct course_id)
		from student natural join takes
		where dept_name = d_name
		group by ID;
    declare continue handler for not found set done = true;
	open c;
    repeat
		fetch c into num;
        set c_num = c_num + num;
        set s_num = s_num + 1;
	until done
    end repeat;
    close c;
    set ratio = c_num / s_num;
    return ratio;
end $$

delimiter ;
select dept_name, course_ratio(dept_name) 
from department;