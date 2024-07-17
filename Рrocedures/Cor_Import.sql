CREATE OR REPLACE PROCEDURE "Cor_Import"(filepath TEXT)
LANGUAGE plpgsql
AS $$ DECLARE
    coord_record RECORD;
BEGIN
    PERFORM 1 FROM pg_tables 
	WHERE tablename = 'Coord_Import';
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Coord_Import not found';
    END IF;

    EXECUTE format('COPY "Coord_Import"("Coordinate_X",
	"Coordinate_Y", "Box_Num") FROM %L 
	DELIMITER '';'' CSV HEADER', filepath);
    FOR coord_record IN 
        SELECT "Box_Num", "Coordinate_X", "Coordinate_Y"
        FROM "Coord_Import"
    LOOP
        INSERT INTO "Department_box"("Box_Num",
	"Box_Num_Jur", "Coordinate_X", "Coordinate_Y")
        VALUES (coord_record."Box_Num", NULL, 
                coord_record."Coordinate_X",
                coord_record."Coordinate_Y")
        ON CONFLICT DO NOTHING;
    END LOOP;
END; $$;