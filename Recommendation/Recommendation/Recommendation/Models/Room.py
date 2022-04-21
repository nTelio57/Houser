from dataclasses import dataclass
from DatabaseContext import db
import datetime
from Models.User import *

@dataclass
class Room(db.Model):
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

    __tablename__ = 'Rooms'
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
    UserId = db.Column(db.String, db.ForeignKey(User.Id))
