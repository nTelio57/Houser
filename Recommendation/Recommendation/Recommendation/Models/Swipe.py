from dataclasses import dataclass
from DatabaseContext import db
from Models.User import *
from Models.Room import *

@dataclass
class Swipe(db.Model):
    __tablename__ = 'Swipes'
    Id: int = db.Column(db.Integer, primary_key=True)
    SwipeType: int = db.Column(db.Integer)
    SwiperId: str = db.Column(db.String, db.ForeignKey(User.Id))
    UserTargetId: str = db.Column(db.String, db.ForeignKey(User.Id))
    RoomId: int = db.Column(db.Integer, db.ForeignKey(Room.Id), nullable=True)
    FilterType: int = db.Column(db.Integer)