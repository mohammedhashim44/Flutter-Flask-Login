import os 
from app import app , databasePath , db
from admin import admin

if not os.path.exists(databasePath):
    db.create_all() 

app.run(debug=True,host='0.0.0.0')