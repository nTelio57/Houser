from flask_sqlalchemy import SQLAlchemy
from flask import Flask, request, jsonify
import os
from os import environ as env

connectionString = "mysql+mysqlconnector://root:@localhost/Houser"
debugMode = True

app = Flask(__name__)

if 'HOUSER_DB' in env:
    debugMode = False
    connectionString = env['HOUSER_DB']

app.debug = debugMode
app.config["SQLALCHEMY_DATABASE_URI"] = connectionString

db = SQLAlchemy(app)