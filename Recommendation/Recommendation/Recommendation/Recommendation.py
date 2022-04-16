from flask import Flask, request, jsonify
from dataclasses import dataclass
import datetime
from flask_sqlalchemy import SQLAlchemy
import json
from json import JSONEncoder
from types import SimpleNamespace
from numpy import dot
from numpy.linalg import norm

_binaryWeight = 2;
_floatWeight = 2;
_priceWeight = 0.35;
_eloWeight = 4;

app = Flask(__name__)
app.debug = True

username = 'root'
password = ''
server = 'localhost'
database = 'Houser'

app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+mysqlconnector://root:@localhost/Houser"

db = SQLAlchemy(app)

@dataclass
class OfferPrediction():
    id: int
    prediction: float

    def __init__(self, id, prediction):
        self.id = id
        self.prediction = prediction

@dataclass
class Offer(db.Model):
    Id: int
    Title: str
    IsVisible: bool
    UploadDate: datetime.datetime
    City: str
    Address: str
    MonthlyPrice: float
    UtilityBillsRequired: bool
    Area: float
    AvailableFrom: datetime.datetime
    AvailableTo: datetime.datetime
    FreeRoomCount: int
    TotalRoomCount: int
    BedCount: int
    RuleSmoking: bool
    RuleAnimals: bool
    AccommodationTv: bool
    AccommodationWifi: bool
    AccommodationAc: bool
    AccommodationParking: bool
    AccommodationBalcony: bool
    AccommodationDisability: bool
    UserId: str

    __tablename__ = 'Offers'
    Id = db.Column(db.Integer, primary_key=True)
    IsVisible = db.Column(db.Boolean)
    UploadDate = db.Column(db.DateTime)
    Title = db.Column(db.String)
    City = db.Column(db.String)
    Address = db.Column(db.String)
    MonthlyPrice = db.Column(db.Float)
    UtilityBillsRequired = db.Column(db.Boolean)
    Area = db.Column(db.Float)
    AvailableFrom = db.Column(db.DateTime)
    AvailableTo = db.Column(db.DateTime)
    FreeRoomCount = db.Column(db.Integer)
    TotalRoomCount = db.Column(db.Integer)
    BedCount = db.Column(db.Integer)
    RuleSmoking = db.Column(db.Boolean)
    RuleAnimals = db.Column(db.Boolean)
    AccommodationTv = db.Column(db.Boolean)
    AccommodationWifi = db.Column(db.Boolean)
    AccommodationAc = db.Column(db.Boolean)
    AccommodationParking = db.Column(db.Boolean)
    AccommodationBalcony = db.Column(db.Boolean)
    AccommodationDisability = db.Column(db.Boolean)
    UserId = db.Column(db.String)

@dataclass
class RoomFilter():
    Id: int
    UserId: str
    City: str
    MonthlyPrice: float
    Area: float
    AvailableFrom: datetime.datetime
    AvailableTo: datetime.datetime
    FreeRoomCount: int
    BedCount: int
    RuleSmoking: bool
    RuleAnimals: bool
    AccommodationTv: bool
    AccommodationWifi: bool
    AccommodationAc: bool
    AccommodationParking: bool
    AccommodationBalcony: bool
    AccommodationDisability: bool

def EuclideanDistance(a, b):
    return 1 - (abs(a-b)/(a+b))

def BoolToBinaryParse(x):
    if x == None:
        return 0
    if x == False:
        return -1
    else: 
        return 1

def CosineSimilarityBool(x, y):
    a = list(map(BoolToBinaryParse, x))
    b = list(map(BoolToBinaryParse, y))
    return dot(a, b)/(norm(a)*norm(b))

def CosineSimilarity(a, b):
    a = list(map(lambda x: float(x), a))
    b = list(map(lambda x: float(x), b))

    if norm(a) == 0 or norm(b) == 0:
        return 0

    return dot(a, b)/(norm(a)*norm(b))

def GetRoomRecommendation(filter):
    offerList = Offer.query.\
        filter_by(City=filter.City).\
        filter(Offer.AvailableFrom <= filter.AvailableFrom).\
        filter(Offer.AvailableTo >= filter.AvailableTo).\
        filter(Offer.IsVisible).\
        filter(Offer.UserId != filter.UserId).\
        all()

    predictions = []
    for offer in offerList:
        priceSimilarity = (EuclideanDistance(offer.MonthlyPrice, filter.MonthlyPrice))
        binarySimilarity = (CosineSimilarityBool((
            offer.RuleSmoking, 
            offer.RuleAnimals,
            offer.AccommodationTv,
            offer.AccommodationWifi,
            offer.AccommodationAc,
            offer.AccommodationParking,
            offer.AccommodationBalcony,
            offer.AccommodationDisability,
            ), 
            (
            filter.RuleSmoking, 
            filter.RuleAnimals,
            filter.AccommodationTv,
            filter.AccommodationWifi,
            filter.AccommodationAc,
            filter.AccommodationParking,
            filter.AccommodationBalcony,
            filter.AccommodationDisability
            )))
        floatSimilarity = (CosineSimilarity((offer.Area, offer.FreeRoomCount), (filter.Area, filter.FreeRoomCount)))
        eloSimilarity = (EuclideanDistance(offer.MonthlyPrice, filter.MonthlyPrice))

        prediction = priceSimilarity * _priceWeight + binarySimilarity * _binaryWeight + floatSimilarity * _floatWeight
        predictions.append(OfferPrediction(offer.Id, prediction))
        predictions.sort(key=lambda x: x.prediction, reverse=True)

    return predictions

@app.route('/room_recommendation', methods=['POST'])
def recommendation():
    filterString = json.dumps(request.get_json())
    filterJson = json.loads(filterString)
    filter = RoomFilter(**filterJson)

    rooms = GetRoomRecommendation(filter)
    print(rooms)
    return jsonify(rooms)

if __name__ == '__main__':
    app.run(port=5002)




