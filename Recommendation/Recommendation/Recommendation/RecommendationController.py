from flask import Flask, request, jsonify
import json
from Models.UserFilter import *
from Models.RoomFilter import *
from RecommendationService import *
from DatabaseContext import app

@app.route('/room', methods=['POST'])
def roomRecommendation():
    filterString = json.dumps(request.get_json())
    filterJson = json.loads(filterString)
    filter = RoomFilter(**filterJson)

    predictions = GetRoomRecommendation(filter)
    return jsonify(predictions)

@app.route('/user', methods=['POST'])
def userRecommendation():
    filterString = json.dumps(request.get_json())
    filterJson = json.loads(filterString)
    filter = UserFilter(**filterJson)

    predictions = GetUserRecommendation(filter)
    return jsonify(predictions)