
from flask import Flask , request , jsonify
from app import app , db
from models import User

@app.route('/') 
def home():
    return "Home" 


@app.route('/API/login', methods=['POST'])
def login():
    username = request.form.get('username')
    password = request.form.get('password')

    msg = ""
    if not username or not password : 
        msg = {"status" : { "type" : "failure" ,   "message" : "Missing Data"}}
        return jsonify(msg)
    
    user = User.query.filter_by(username=username).first() 
    if user is None or not user.check_password(password) :
        msg = {"status" : { "type" : "failure" ,   "message" : "Username or password incorrect"}}
    else:
        msg = {"status" : { "type" : "success" ,
                             "message" : "You logged in"} , 
               "data" : {"user" : user.getJsonData() }
        }

    return jsonify(msg)

@app.route('/API/register', methods=['POST'])
def register():
    username = request.form.get('username')
    fullname = request.form.get('fullname')
    password = request.form.get('password')
    email = request.form.get('email')

    msg = ""
    if not username or not password or not email or not fullname : 
        msg = {"status" : { "type" : "failure" ,   "message" : "missing data"}}
        return jsonify(msg)
    
    if User.query.filter_by(username=username).count() == 1 : 
        msg = {"status" : { "type" : "failure" ,   "message" : "username already taken"}}
        return jsonify(msg)
    
    if User.query.filter_by(email=email).count() == 1 : 
        msg = {"status" : { "type" : "failure" ,   "message" : "email already taken"}}
        return jsonify(msg)
    
    u = User()
    u.username = username 
    u.fullname = fullname
    u.email = email 
    u.set_password(password) 

    db.session.add(u)
    db.session.commit() 

    msg = {"status" : { "type" : "success" ,   "message" : "You have registered"}}
    return jsonify(msg)
