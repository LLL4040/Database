use cardgame;
/* 用事务保护？ */
delimiter $$
drop procedure if exists recharge $$
create procedure recharge (
	username varchar(50), 
	amount integer)
begin
declare new_account integer;
declare this_time datetime;

/* 更新用户余额 */
select account into new_account
from playerinfo
where name = username;

set new_account = new_account + amount;

update playerinfo
set account = new_account
where name = username;

/* 添加账单记录 */
select now() into this_time;

insert into bill(name, datetime, amount)
values (username, this_time, amount);
end $$

delimiter $$
drop procedure if exists purchase $$
create procedure purchase (
	username varchar(50), 
	pname varchar(50))
begin
declare new_account integer;
declare amount integer;
declare this_time datetime;
declare this_month integer;
declare this_year integer;
declare recharge_amount integer;
declare c1, c2, c3, c4, c5 integer unsigned;

/* 更新用户余额 */
select account into new_account
from playerinfo
where name = username;

select price into amount
from cardpacket
where name = pname;

set new_account = new_account - amount;

update playerinfo
set account = new_account
where name = username;

/* 添加账单记录 */
select now() into this_time;

insert into bill(name, datetime, amount)
values (username, this_time, -amount);

/* 统计该月充值总额 */
select month(this_time) into this_month;

select year(this_time) into this_year;

select sum(amount) into recharge_amount
from bill
where name = username 
	and year(datetime) = this_year 
    and month(datetime) = this_month;

/* 根据充值总额抽出五张卡 */


/* 添加hascard记录 */
insert into hascard(name, card_id)
values (uasername, c1);

insert into hascard(name, card_id)
values (uasername, c2);

insert into hascard(name, card_id)
values (uasername, c3);

insert into hascard(name, card_id)
values (uasername, c4);

insert into hascard(name, card_id)
values (uasername, c5);
end $$