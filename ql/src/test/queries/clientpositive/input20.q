--! qt:dataset:src
CREATE TABLE dest1(key INT, value STRING) STORED AS TEXTFILE;

ADD FILE ../../data/scripts/input20_script.py;

EXPLAIN
FROM (
  FROM src
  MAP src.key, src.key 
  USING 'cat'
  DISTRIBUTE BY key, value
) tmap
INSERT OVERWRITE TABLE dest1
REDUCE tmap.key, tmap.value
USING 'python input20_script.py'
AS key, value;

FROM (
  FROM src
  MAP src.key, src.key
  USING 'cat' 
  DISTRIBUTE BY key, value
) tmap
INSERT OVERWRITE TABLE dest1
REDUCE tmap.key, tmap.value
USING 'python input20_script.py'
AS key, value;

SELECT * FROM dest1 ORDER BY key, value;
