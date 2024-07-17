from fastapi import FastAPI
from pydantic import BaseModel 
import psycopg2
import json

app = FastAPI()
DB_URL = "postgresql://postgres:Mqpz7Mqpz7@db:5432/Company"

class EmplSearch(BaseModel):
    search_term: str
def getDBCon():
    conn = psycopg2.connect(DB_URL)
    return conn

@app.post("/newTables/")
async def newTables():
    conn = getDBCon()
    cur = conn.cursor()
    cur.execute('CALL "Create_Main_Tables"();')
    conn.commit()
    cur.close()
    conn.close()
    return {"message": "Таблицы созданы"}

@app.post("/impEmpl/")
async def impEmpl(filepath: str):
    conn = getDBCon()
    cur = conn.cursor()
    cur.execute('CALL "Create_Employees"(%s::text);',[filepath])
    conn.commit()
    cur.close()
    conn.close()
    return {"message": "Сотрудники импортированы"}

@app.post("/searchEmpl/")
async def searchEmpl(search: EmplSearch):
    conn = getDBCon()
    cur = conn.cursor()
    cur.execute('CALL "Search_Employee"(%s::text);',[search.search_term])
    result = cur.fetchone()[0]
    cur.close()
    conn.close()
    return json.loads(result)

@app.post("/impCoord/")
async def impCoord(filepath: str):
    conn = getDBCon()
    cur = conn.cursor()
    cur.execute('CALL "Cor_Import"(%s::text);',[filepath])
    conn.commit()
    cur.close()
    conn.close()
    return {"message": "Координаты импортированы"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)