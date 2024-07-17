CREATE OR REPLACE PROCEDURE "Create_Main_Tables"()
LANGUAGE plpgsql
AS $$ BEGIN
    CREATE TABLE IF NOT EXISTS "Departments"(
        "Id" SERIAL PRIMARY KEY,
        "Div_4_1" VARCHAR(255),
        "Div_3_1" VARCHAR(255),
        "Div_2_1" VARCHAR(255),
        "Div_1_1" VARCHAR(255),
        "Dep_FullPath" VARCHAR(255)
    );
    CREATE TABLE IF NOT EXISTS "Coord_Import"(
        "Id" SERIAL PRIMARY KEY,
        "Box_Num" VARCHAR(255),
        "Coordinate_X" POINT,
        "Coordinate_Y" POINT,
        "Box_Num_Jur" VARCHAR(255)
    );
    CREATE TABLE IF NOT EXISTS "Employees_Import"(
        "Id" SERIAL PRIMARY KEY,
        "FIO" VARCHAR(255),
        "Div_4_1" VARCHAR(255),
        "Div_3_1" VARCHAR(255),
        "Div_2_1" VARCHAR(255),
        "Div_1_1" VARCHAR(255),
        "Service_Num" INTEGER,
        "Employee_Position" VARCHAR(255),
        "Phone_Num" VARCHAR(255),
        "Email" VARCHAR(255),
        "Inst_Name" VARCHAR(255)
    );
    CREATE TABLE IF NOT EXISTS "Department_box"(
        "Id" SERIAL PRIMARY KEY,
        "Box_Num" VARCHAR(255),
        "Box_Num_Jur" VARCHAR(255),
        "Coordinate_X" POINT,
        "Coordinate_Y" POINT
    );
    CREATE TABLE IF NOT EXISTS "Institutes"(
        "Id" SERIAL PRIMARY KEY,
        "Inst_Name" VARCHAR(255)
    );
    CREATE TABLE IF NOT EXISTS "Employee"(
        "Id" SERIAL PRIMARY KEY,
        "Employee_Name" VARCHAR(255),
        "Service_Num" INTEGER,
        "Employee_Position" VARCHAR(255),
        "Phone_Num" VARCHAR(255),
        "Email" VARCHAR(255),
        "IsActive" BIT,
        "Dep_FullPath" VARCHAR(255),
        "Inst_Id" INTEGER REFERENCES "Institutes"("Id"),
        "Box_Id" INTEGER REFERENCES "Department_box"("Id")
    );
    CREATE TABLE IF NOT EXISTS "Departments_Mapping"(
        "Id" SERIAL PRIMARY KEY,
        "Department_Id" INTEGER REFERENCES "Departments"("Id"),
        "Employee_Id" INTEGER REFERENCES "Employee"("Id")
    );
END; $$; 