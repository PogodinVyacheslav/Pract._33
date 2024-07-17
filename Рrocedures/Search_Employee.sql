CREATE OR REPLACE PROCEDURE "Search_Employee"(search_term TEXT)
LANGUAGE plpgsql
AS $$ DECLARE
    emp_info JSONB;
BEGIN
    emp_info := '[]'::JSONB;
    SELECT jsonb_agg(jsonb_build_array(
        jsonb_build_object('Id', "Id"),
        jsonb_build_object('Employee_Name', "Employee_Name"),
        jsonb_build_object('Service_Num', "Service_Num"),
        jsonb_build_object('Employee_Position', "Employee_Position"),
        jsonb_build_object('Phone_Num', "Phone_Num"),
        jsonb_build_object('Email', "Email"),
        jsonb_build_object('IsActive', "IsActive"),
        jsonb_build_object('Dep_FullPath', "Dep_FullPath"),
        jsonb_build_object('Inst_Id', "Inst_Id"),
        jsonb_build_object('Box_Id', "Box_Id")))
    INTO emp_info FROM "Employee"
    WHERE "Id"::TEXT ILIKE '%' || search_term || '%' OR
        "Employee_Name" ILIKE '%' || search_term || '%' OR
        "Service_Num"::TEXT ILIKE '%' || search_term || '%' OR
        "Employee_Position" ILIKE '%' || search_term || '%' OR
        "Phone_Num" ILIKE '%' || search_term || '%' OR
        "Email" ILIKE '%' || search_term || '%' OR
        "IsActive"::TEXT ILIKE '%' || search_term || '%' OR
        "Dep_FullPath" ILIKE '%' || search_term || '%' OR
        "Inst_Id"::TEXT ILIKE '%' || search_term || '%' OR
        "Box_Id"::TEXT ILIKE '%' || search_term || '%';
    RAISE NOTICE 'Результат: %', emp_info;
END; $$;