
from flask import Flask , request , jsonify
from flask_sqlalchemy import SQLAlchemy
import os 

app = Flask(__name__) 

currentDirectory = os.getcwd() 
databasePath = os.path.join(currentDirectory , "database.db")

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///'+databasePath
db = SQLAlchemy(app) 

import routes , models 