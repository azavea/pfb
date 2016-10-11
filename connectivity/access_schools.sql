----------------------------------------
-- INPUTS
-- location: cambridge
----------------------------------------
-- low stress access
UPDATE  cambridge_census_blocks
SET     schools_low_stress = (
            SELECT  COUNT(cbs.id)
            FROM    cambridge_connected_census_blocks_schools cbs
            WHERE   cbs.source_blockid10 = cambridge_census_blocks.blockid10
            AND     cbs.low_stress
        )
WHERE   EXISTS (
            SELECT  1
            FROM    cambridge_zip_codes zips
            WHERE   ST_Intersects(cambridge_census_blocks.geom,zips.geom)
            AND     zips.zip_code = '02138'
        );

-- high stress access
UPDATE  cambridge_census_blocks
SET     schools_high_stress = (
            SELECT  COUNT(cbs.id)
            FROM    cambridge_connected_census_blocks_schools cbs
            WHERE   cbs.source_blockid10 = cambridge_census_blocks.blockid10
        )
WHERE   EXISTS (
            SELECT  1
            FROM    cambridge_zip_codes zips
            WHERE   ST_Intersects(cambridge_census_blocks.geom,zips.geom)
            AND     zips.zip_code = '02138'
        );

-- low stress population shed for schools in neighborhood
UPDATE  cambridge_schools
SET     pop_low_stress = (
            SELECT  SUM(cb.pop10)
            FROM    cambridge_census_blocks cb,
                    cambridge_connected_census_blocks_schools cbs
            WHERE   cb.blockid10 = cbs.source_blockid10
            AND     cambridge_schools.id = cbs.target_school_id
            AND     cbs.low_stress
        )
WHERE   EXISTS (
            SELECT  1
            FROM    cambridge_zip_codes zips
            WHERE   ST_Intersects(cambridge_schools.geom_pt,zips.geom)
            AND     zips.zip_code = '02138'
        );

-- high stress population shed for schools in neighborhood
UPDATE  cambridge_schools
SET     pop_high_stress = (
            SELECT  SUM(cb.pop10)
            FROM    cambridge_census_blocks cb,
                    cambridge_connected_census_blocks_schools cbs
            WHERE   cb.blockid10 = cbs.source_blockid10
            AND     cambridge_schools.id = cbs.target_school_id
        )
WHERE   EXISTS (
            SELECT  1
            FROM    cambridge_zip_codes zips
            WHERE   ST_Intersects(cambridge_schools.geom_pt,zips.geom)
            AND     zips.zip_code = '02138'
        );