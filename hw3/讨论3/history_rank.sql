use version2;
drop function if exists win_rate;
drop function if exists see_ranking;
drop function if exists day_win_rate;

delimiter $$
drop procedure if exists history_game $$
create procedure history_game(playname varchar(50))
begin
  	select time, winner, loser
    from game_record  
    where playname = loser;

    select time, winner, loser
    from game_record  
    where playname = winner;
END $$

delimiter $
create function see_ranking(playname varchar(50))
returns int
DETERMINISTIC
begin
  	declare user_ranking int default 0;
    select ranking into user_ranking 
    from player_status
    where name = playname;
    return user_ranking;
END;
$
delimiter ;

delimiter $
create function win_rate(playname varchar(50))
returns Decimal(5,4)
DETERMINISTIC
begin
	  declare rate Decimal(5,4) default 0.0;
    declare loses int default 0;
    declare wins int default 0;
    
    select count(*) into loses 
    from game_record 
    where loser = playname;
    select count(*) into wins 
    from game_record 
    where winner = playname;
    if(loses + wins <> 0) then set rate = (wins/(wins+loses));
    end if;
    
    return rate;
END;
$

delimiter $
create function day_win_rate(playname varchar(50), query_date datetime)
returns Decimal(5,4)
DETERMINISTIC
begin
	  declare rate Decimal(5,4) default 0.0;
    declare loses int default 0;
    declare wins int default 0;
    DECLARE d date DEFAULT date(query_date);
    
    select count(*) into loses  
    from game_record PARTITION (p2019)
    where loser = playname and time BETWEEN d AND d+1;
    select count(*) into wins  
    from game_record PARTITION (p2019)
    where winner = playname and time BETWEEN d AND d+1;
  
    if(loses + wins <> 0) then 
        set rate = (wins/(wins+loses));
    end if;
    
    return rate;
END;
$
delimiter ;

delimiter $$
drop procedure if exists month_rate $$
DROP TABLE IF EXISTS rate_per_month $$
create procedure month_rate(play_name varchar(50))
begin
  	DECLARE query_date datetime default now();
    /*
    DECLARE query_day int DEFAULT 30;
    DECLARE rate Decimal(5,4) DEFAULT 0;
  */
  
    DROP TABLE IF EXISTS rate_per_month;
    CREATE TEMPORARY TABLE IF NOT EXISTS rate_per_month(
    id int UNSIGNED AUTO_INCREMENT,
    rate Decimal(5,4) NOT NULL,
    PRIMARY KEY(id));
    ALTER TABLE rate_per_month AUTO_INCREMENT = 1;

    /*
    WHILE(query_day > 0)
    DO 
      SELECT day_win_rate(play_name, date_add(query_date,INTERVAL -query_day day)) INTO rate;
      INSERT INTO rate_per_month(rate) VALUES(rate);
      SET query_day = query_day - 1;
    END WHILE;
  */
  
   
    INSERT INTO rate_per_month(rate) VALUES
    (day_win_rate(play_name, query_date)),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -1 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -2 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -3 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -4 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -5 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -6 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -7 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -8 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -9 day)));
    INSERT INTO rate_per_month(rate) VALUES
    (day_win_rate(play_name, date_add(query_date,INTERVAL -10 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -11 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -12 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -13 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -14 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -15 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -16 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -17 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -18 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -19 day)));
    INSERT INTO rate_per_month(rate) VALUES
    (day_win_rate(play_name, date_add(query_date,INTERVAL -20 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -21 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -22 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -23 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -24 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -25 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -26 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -27 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -28 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -29 day))),
    (day_win_rate(play_name, date_add(query_date,INTERVAL -30 day)));
    
END $$

DELIMITER ;
/*
CALL month_rate("Toby3");
SELECT * FROM rate_per_month;
 */
