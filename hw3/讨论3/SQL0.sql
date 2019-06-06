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

/*
ALTER TABLE game_record DROP PRIMARY KEY , ADD PRIMARY KEY(id,time);
  */
ALTER TABLE game_record DROP FOREIGN KEY FKbbja9bo4bh2ovpueb601o2wpb;
ALTER TABLE game_record DROP FOREIGN KEY FKswr9evrdlbxlvc4wv3ipu780s;
ALTER TABLE game_record PARTITION BY RANGE (year(time))
(
  PARTITION p2009 VALUES LESS THAN (YEAR('2010-01-01')),
  PARTITION p2010 VALUES LESS THAN (YEAR('2011-01-01')),
  PARTITION p2011 VALUES LESS THAN (YEAR('2012-01-01')),
  PARTITION p2012 VALUES LESS THAN (YEAR('2013-01-01')),
  PARTITION p2013 VALUES LESS THAN (YEAR('2014-01-01')),
  PARTITION p2014 VALUES LESS THAN (YEAR('2015-01-01')),
  PARTITION p2015 VALUES LESS THAN (YEAR('2016-01-01')),
  PARTITION p2016 VALUES LESS THAN (YEAR('2017-01-01')),
  PARTITION p2017 VALUES LESS THAN (YEAR('2018-01-01')),
  PARTITION p2018 VALUES LESS THAN (YEAR('2019-01-01')),
  PARTITION p2019 VALUES LESS THAN MAXVALUE
);

ALTER TABLE game_record ADD INDEX (winner, time);
ALTER TABLE game_record ADD INDEX (loser, time);