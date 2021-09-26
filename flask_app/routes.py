from flask import Flask, request, jsonify
from app import app, db
from models import User


@app.route('/')
def home():
    return "Home"


@app.route('/API/login', methods=['POST'])
def login():
    username = request.form.get('username')
    password = request.form.get('password')

    if not validate_string(username) or not validate_string(password):
        status = False
        message = "Invalid data"
        response = construct_response(status=status, message=message)
        return jsonify(response)

    user = User.query.filter_by(username=username).first()
    if user is None or not user.check_password(password):
        status = False
        message = "Username or password incorrect"
        response = construct_response(status=status, message=message)
        return jsonify(response)

    else:
        status = True
        message = "User logged in"
        data = user.getJsonData()
        response = construct_response(status=status, message=message, data=data)
        return jsonify(response)


@app.route('/API/register', methods=['POST'])
def register():
    username = request.form.get('username')
    fullname = request.form.get('fullname')
    password = request.form.get('password')
    email = request.form.get('email')

    valid_input = validate_list_of_strings([username, fullname, password, email])
    if not valid_input:
        status = False
        message = "Invalid data"
        response = construct_response(status=status, message=message)
        return jsonify(response)

    if User.query.filter_by(username=username).count() == 1:
        status = False
        message = "Username already taken"
        response = construct_response(status=status, message=message)
        return jsonify(response)

    if User.query.filter_by(email=email).count() == 1:
        status = False
        message = "Email already taken"
        response = construct_response(status=status, message=message)
        return jsonify(response)

    # Create new user
    u = User()
    u.username = username
    u.fullname = fullname
    u.email = email
    u.set_password(password)

    db.session.add(u)
    db.session.commit()

    status = True
    message = "You have been registered"
    response = construct_response(status=status, message=message)
    return jsonify(response)


# Helpers
def validate_string(input):
    if input is None or not input.strip():
        return False
    return True


def validate_list_of_strings(list):
    for i in list:
        if not validate_string(i):
            return False
    return True


def construct_response(status, message, data=None):
    return {
        "status": status,
        "message": message,
        "data": data
    }
