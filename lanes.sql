----------------------------------------
-- INPUTS
-- location: cambridge
----------------------------------------
UPDATE  cambridge_ways SET ft_lanes = NULL, tf_lanes = NULL;

-- forward
UPDATE  cambridge_ways
SET     ft_lanes = substring(osm."lanes:forward" FROM '\d+')::INT
FROM    cambridge_osm_full_line osm
WHERE   cambridge_ways.osm_id = osm.osm_id
AND     ft_lanes IS NULL
AND     osm."lanes:forward" IS NOT NULL;

-- backward
UPDATE  cambridge_ways
SET     tf_lanes = substring(osm."lanes:backward" FROM '\d+')::INT
FROM    cambridge_osm_full_line osm
WHERE   cambridge_ways.osm_id = osm.osm_id
AND     tf_lanes IS NULL
AND     osm."lanes:backward" IS NOT NULL;

-- all lanes (no direction given)
-- two way
UPDATE  cambridge_ways
SET     ft_lanes = floor(substring(osm.lanes FROM '\d+')::FLOAT / 2),
        tf_lanes = floor(substring(osm.lanes FROM '\d+')::FLOAT / 2)
FROM    cambridge_osm_full_line osm
WHERE   cambridge_ways.osm_id = osm.osm_id
AND     tf_lanes IS NULL
AND     ft_lanes IS NULL
AND     one_way_car NOT IN ('ft','tf')
AND     osm.lanes IS NOT NULL;

-- all lanes (no direction given)
-- one way
UPDATE  cambridge_ways
SET     ft_lanes = substring(osm.lanes FROM '\d+')::INT
FROM    cambridge_osm_full_line osm
WHERE   cambridge_ways.osm_id = osm.osm_id
AND     one_way_car = 'ft'
AND     ft_lanes IS NULL
AND     osm.lanes IS NOT NULL;
UPDATE  cambridge_ways
SET     tf_lanes = substring(osm.lanes FROM '\d+')::INT
FROM    cambridge_osm_full_line osm
WHERE   cambridge_ways.osm_id = osm.osm_id
AND     one_way_car = 'tf'
AND     tf_lanes IS NULL
AND     osm.lanes IS NOT NULL;