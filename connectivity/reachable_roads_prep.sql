DROP TABLE IF EXISTS neighborhood_ways_bounded;

SELECT ways.*
INTO neighborhood_ways_bounded
FROM neighborhood_ways AS ways
INNER JOIN neighborhood_boundary AS bounds
ON (ST_Intersects(bounds.geom, ways.geom));

CREATE INDEX idx_neighborhood_ways_bounded_road_id ON neighborhood_ways_bounded (road_id);
ANALYZE neighborhood_ways (road_id);

DROP TABLE IF EXISTS neighborhood_ways_net_link_bounded;

SELECT net_link.*
INTO neighborhood_ways_net_link_bounded
FROM neighborhood_ways_net_link AS net_link
INNER JOIN neighborhood_boundary AS bounds
ON (ST_Intersects(bounds.geom, net_link.geom));

CREATE INDEX idx_neighborhood_net_link_bounded_road_id ON neighborhood_ways_bounded (road_id);
ANALYZE neighborhood_ways (road_id);

CREATE INDEX idx_neighborhood_ways_net_vert_road_id ON neighborhood_ways_net_vert (road_id);
CREATE INDEX idx_neighborhood_ways_net_vert_vert_id ON neighborhood_ways_net_vert (vert_id);
ANALYZE neighborhood_ways_net_vert (road_id, vert_id);
