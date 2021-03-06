USE version2;
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
