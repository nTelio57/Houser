from dataclasses import dataclass
from DatabaseContext import db
import datetime

@dataclass
class User(db.Model):
    Id: str
    IsVisible: bool
    Elo: int
    BirthDate: datetime.datetime
    Sex: int
    AnimalCount: int
    GuestCount: int
    PartyCount: int
    IsStudying: bool
    IsWorking: bool
    IsSmoking: bool
    SleepType: int

    __tablename__ = 'Aspnetusers'
    Id = db.Column(db.String, primary_key=True)
    IsVisible = db.Column(db.Boolean)
    Elo = db.Column(db.Integer)
    BirthDate = db.Column(db.DateTime)
    Sex = db.Column(db.Integer)
    AnimalCount = db.Column(db.Integer)
    GuestCount = db.Column(db.Integer)
    PartyCount = db.Column(db.Integer)
    IsStudying = db.Column(db.Boolean)
    IsWorking = db.Column(db.Boolean)
    IsSmoking = db.Column(db.Boolean)
    SleepType = db.Column(db.Integer)