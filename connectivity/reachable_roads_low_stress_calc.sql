----------------------------------------
-- INPUTS
-- location: neighborhood
-- maximum network distsance: 10560 ft
----------------------------------------
INSERT INTO generated.neighborhood_reachable_roads_low_stress (
    base_road,
    target_road,
    total_cost
)
SELECT  r1.road_id,
        v2.road_id,
        sheds.agg_cost
FROM    neighborhood_ways r1
        INNER JOIN neighborhood_ways_net_vert v1 ON (r1.road_id = v1.road_id),
        pgr_drivingDistance('
            SELECT     nl.link_id AS id,
                       nl.source_vert AS source,
                       nl.target_vert AS target,
                       nl.link_cost AS cost
            FROM       neighborhood_ways_net_link AS nl
            INNER JOIN neighborhood_boundary AS nb
            ON         ST_Intersects(nl.geom, nb.geom)
            WHERE      link_stress = 1',
            v1.vert_id,
            10560,
            directed := true
        ) sheds
        INNER JOIN neighborhood_ways_net_vert v2 ON (v2.vert_id = sheds.node)
WHERE r1.road_id % :thread_num = :thread_no
AND
EXISTS (
            SELECT  1
            FROM    neighborhood_boundary AS b
            WHERE   ST_Intersects(b.geom, r1.geom)
);
