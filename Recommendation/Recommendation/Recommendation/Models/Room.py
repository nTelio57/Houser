from dataclasses import dataclass
from DatabaseContext import db
import datetime
from Models.User import *

@dataclass
class Room(db.Model):
    __tablename__ = 'Rooms'
    Id: int = db.Column(db.Integer, primary_key=True)
    Title: str = db.Column(db.String)
    IsVisible: bool = db.Column(db.Boolean)
    UploadDate: datetime.datetime = db.Column(db.DateTime)
    City: str = db.Column(db.String)
    Address: str = db.Column(db.String)
    MonthlyPrice: float = db.Column(db.Float)
    UtilityBillsRequired: bool = db.Column(db.Boolean)
    Area: float = db.Column(db.Float)
    AvailableFrom: datetime.datetime = db.Column(db.DateTime)
    AvailableTo: datetime.datetime = db.Column(db.DateTime)
    FreeRoomCount: int = db.Column(db.Integer)
    TotalRoomCount: int = db.Column(db.Integer)
    BedCount: int = db.Column(db.Integer)
    RuleSmoking: bool = db.Column(db.Boolean)
    RuleAnimals: bool = db.Column(db.Boolean)
    AccommodationTv: bool = db.Column(db.Boolean)
    AccommodationWifi: bool = db.Column(db.Boolean)
    AccommodationAc: bool = db.Column(db.Boolean)
    AccommodationParking: bool = db.Column(db.Boolean)
    AccommodationBalcony: bool = db.Column(db.Boolean)
    AccommodationDisability: bool = db.Column(db.Boolean)
    UserId: str = db.Column(db.String, db.ForeignKey(User.Id))