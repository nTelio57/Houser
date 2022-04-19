from CalculationUtils import *
from Models.UserPrediction import *
from Models.RoomPrediction import *
from Models.User import *
from Models.Room import *
import datetime
from datetime import timedelta
from DatabaseContext import db

_binaryWeight = 2;
_floatWeight = 2;
_priceWeight = 0.35;
_eloWeight = 4;

def GetRoomQuery(filter):
    query = db.session.query(Room, User.Elo).join(User).filter(Room.IsVisible).filter(Room.UserId != filter.UserId)

    if(filter.AvailableFrom != None):
        query = query.filter(Room.AvailableFrom <= filter.AvailableFrom)
    if(filter.AvailableTo != None):
        query = query.filter(Room.AvailableTo >= filter.AvailableTo)
    if(filter.City != None):
        query = query.filter(Room.City == filter.City)

    return query

def GetRoomRecommendation(filter):

    roomList = GetRoomQuery(filter).all()
    
    predictions = []
    for room, elo in roomList:
        priceSimilarity = (EuclideanDistance(room.MonthlyPrice, filter.MonthlyPrice))
        binarySimilarity = (CosineSimilarityBool((
            room.RuleSmoking, 
            room.RuleAnimals,
            room.AccommodationTv,
            room.AccommodationWifi,
            room.AccommodationAc,
            room.AccommodationParking,
            room.AccommodationBalcony,
            room.AccommodationDisability,
            ), (
            filter.RuleSmoking, 
            filter.RuleAnimals,
            filter.AccommodationTv,
            filter.AccommodationWifi,
            filter.AccommodationAc,
            filter.AccommodationParking,
            filter.AccommodationBalcony,
            filter.AccommodationDisability
            )))
        floatSimilarity = (CosineSimilarity((room.Area, room.FreeRoomCount), (filter.Area, filter.FreeRoomCount)))
        eloSimilarity = (EuclideanDistance(elo, filter.Elo))

        prediction = priceSimilarity * _priceWeight + binarySimilarity * _binaryWeight + floatSimilarity * _floatWeight + eloSimilarity * _eloWeight
        predictions.append(RoomPrediction(room.Id, prediction))
        predictions.sort(key=lambda x: x.prediction, reverse=True)

    return predictions

def GetUserRecommendation(filter):

    today = datetime.date.today()
    ageFromDate = today.replace(today.year - filter.AgeFrom)
    ageToDate = today.replace(today.year - filter.AgeTo)

    userList = db.session.query(User).\
        filter(User.IsVisible).\
        filter(User.Sex == filter.Sex).\
        filter(User.BirthDate <= ageFromDate).\
        filter(User.BirthDate >= ageToDate).\
        filter(User.Id != filter.UserId).\
        all()
    
    predictions = []
    for user in userList:
        binarySimilarity = (CosineSimilarityBool((
            user.IsSmoking, 
            user.IsStudying,
            user.IsWorking,
            ), (
            filter.IsSmoking, 
            filter.IsStudying,
            filter.IsWorking,
            )))
        floatSimilarity = (CosineSimilarity((user.AnimalCount, user.GuestCount, user.PartyCount, user.SleepType), (filter.AnimalCount, filter.GuestCount, filter.PartyCount, filter.SleepType)))
        eloSimilarity = (EuclideanDistance(user.Elo, filter.Elo))

        prediction = binarySimilarity * _binaryWeight + floatSimilarity * _floatWeight + eloSimilarity * _eloWeight
        predictions.append(UserPrediction(user.Id, prediction))
        predictions.sort(key=lambda x: x.prediction, reverse=True)

    return predictions

