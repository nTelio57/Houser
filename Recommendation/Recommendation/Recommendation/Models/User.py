from dataclasses import dataclass
from DatabaseContext import db
import datetime

@dataclass
class User(db.Model):
    __tablename__ = 'Aspnetusers'
    Id: str = db.Column(db.String, primary_key=True)
    IsVisible: bool = db.Column(db.Boolean)
    Elo: int = db.Column(db.Integer)
    BirthDate: datetime.datetime = db.Column(db.DateTime)
    Sex: int = db.Column(db.Integer)
    AnimalCount: int = db.Column(db.Integer)
    GuestCount: int = db.Column(db.Integer)
    PartyCount: int= db.Column(db.Integer)
    IsStudying: bool = db.Column(db.Boolean)
    IsWorking: bool = db.Column(db.Boolean)
    IsSmoking: bool = db.Column(db.Boolean)
    SleepType: int = db.Column(db.Integer)