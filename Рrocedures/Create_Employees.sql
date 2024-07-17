CREATE OR REPLACE PROCEDURE "Create_Employees"(filepath TEXT)
LANGUAGE plpgsql
AS $$ BEGIN
    PERFORM 1 FROM pg_tables WHERE tablename = 'Employees_Import';
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employees_Import not found';
    END IF;

    EXECUTE format('COPY "Employees_Import"("FIO", "Div_4_1", "Div_3_1",
        "Div_2_1", "Div_1_1", "Service_Num", "Employee_Position", "Phone_Num",
        "Email", "Inst_Name") FROM %L DELIMITER '';'' CSV HEADER', filepath);

    INSERT INTO "Institutes"("Inst_Name")
    SELECT DISTINCT "Inst_Name"
    FROM "Employees_Import"
    WHERE "Inst_Name" IS NOT NULL
    ON CONFLICT DO NOTHING;

    INSERT INTO "Departments"("Div_4_1", "Div_3_1", 
	"Div_2_1", "Div_1_1", "Dep_FullPath")
    SELECT DISTINCT "Div_4_1", "Div_3_1", "Div_2_1", "Div_1_1",
        CONCAT_WS(' > ', "Div_1_1", "Div_2_1", "Div_3_1", "Div_4_1")
    FROM "Employees_Import"
    WHERE "Div_4_1" IS NOT NULL OR "Div_3_1" IS NOT NULL
	OR "Div_2_1" IS NOT NULL OR "Div_1_1" IS NOT NULL
    ON CONFLICT DO NOTHING;

    INSERT INTO "Employee"("Employee_Name", "Service_Num", "Employee_Position", 
        "Phone_Num", "Email", "IsActive", "Dep_FullPath", "Inst_Id", "Box_Id")
    SELECT "FIO", "Service_Num", "Employee_Position", "Phone_Num", "Email", '1', 
        CONCAT_WS(' > ', "Div_1_1", "Div_2_1", "Div_3_1", "Div_4_1"), 
        (SELECT "Id" FROM "Institutes" WHERE "Inst_Name"
	    = "Employees_Import"."Inst_Name"),
        NULL
    FROM "Employees_Import"
    WHERE "FIO" IS NOT NULL AND "Service_Num" IS NOT NULL 
	AND "Employee_Position" IS NOT NULL;

    INSERT INTO "Departments_Mapping"("Department_Id", "Employee_Id") SELECT 
	(SELECT "Id" FROM "Departments" 
	WHERE COALESCE("Departments"."Div_4_1", '') 
	    = COALESCE("Employees_Import"."Div_4_1", '')
	AND COALESCE("Departments"."Div_3_1", '') 
	    = COALESCE("Employees_Import"."Div_3_1", '')
	AND COALESCE("Departments"."Div_2_1", '') 
	    = COALESCE("Employees_Import"."Div_2_1", '')
	AND COALESCE("Departments"."Div_1_1", '') 
	    = COALESCE("Employees_Import"."Div_1_1", '')),
       "Employee"."Id"
    FROM "Employees_Import"
    JOIN "Employee" ON "Employees_Import"."FIO" 
	= "Employee"."Employee_Name"
    WHERE ("Employees_Import"."Div_4_1" IS NOT NULL 
        OR "Employees_Import"."Div_3_1" IS NOT NULL 
	OR "Employees_Import"."Div_2_1" IS NOT NULL 
	OR "Employees_Import"."Div_1_1" IS NOT NULL)
	AND "Employees_Import"."FIO" IS NOT NULL;
END; $$;