from dataclasses import dataclass
from DatabaseContext import db
from Models.User import *
from Models.Room import *

@dataclass
class Match(db.Model):
    __tablename__ = 'Matches'
    Id: int = db.Column(db.Integer, primary_key=True)
    UserOffererId: str = db.Column(db.String, db.ForeignKey(User.Id))
    RoomOffererId: str = db.Column(db.String, db.ForeignKey(User.Id))
    RoomId: int = db.Column(db.Integer, db.ForeignKey(Room.Id), nullable=True)
    FilterType: int = db.Column(db.Integer)
