USE version2;
delimiter $$
drop procedure if exists try_month_rate $$
create procedure try_month_rate()
BEGIN
  DECLARE i int DEFAULT 0;
  WHILE(i < 100)
  DO
    call month_rate("Toby3");
    SELECT * FROM rate_per_month;
    call month_rate("Adam57");
    SELECT * FROM rate_per_month;
    call month_rate("Fong687");
    SELECT * FROM rate_per_month;
    call month_rate("Dani6");
    SELECT * FROM rate_per_month;
    call month_rate("Wan2000");
    SELECT * FROM rate_per_month;
    SET i = i + 1;
  END WHILE;
END$$

DROP PROCEDURE IF EXISTS try_login $$
CREATE PROCEDURE try_login()
BEGIN
  DECLARE i int DEFAULT 0;
  WHILE(i < 100)
  DO
    SELECT login("Zoe9", "ZP");
    SELECT login("Abbie164", "L3S");
    SELECT login("Abbie1", "");
    SET i = i + 1;
  END WHILE;
END $$

DROP PROCEDURE IF EXISTS try_history_game $$
CREATE PROCEDURE try_history_game()
BEGIN
  DECLARE i int DEFAULT 0;
  WHILE(i < 100)
  DO
    CALL history_game("Wan2000");
    SET i = i + 1;
  END WHILE;
END $$