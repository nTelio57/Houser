from CalculationUtils import *
from Models.UserPrediction import *
from Models.RoomPrediction import *
from Models.User import *
from Models.Room import *
from Models.Swipe import *
from Models.Match import *
import datetime
from sqlalchemy import exists, and_
from datetime import timedelta
from DatabaseContext import db

_binaryWeight = 2;
_floatWeight = 2;
_priceWeight = 0.35;
_eloWeight = 4;

def GetRoomQuery(filter):
    userSwipes = db.session.query(Swipe.RoomId).filter(Swipe.SwiperId == filter.UserId).filter(Swipe.FilterType == 0)
    matches = db.session.query(Match.RoomId).filter(Match.UserOffererId == filter.UserId)

    query = db.session.query(Room, User.Elo).join(User).\
        filter(Room.IsVisible).\
        filter(Room.UserId != filter.UserId).\
        filter(Room.Id.not_in(userSwipes)).\
        filter(Room.Id.not_in(matches))

    if(filter.AvailableFrom != None):
        query = query.filter(Room.AvailableFrom <= filter.AvailableFrom)
    if(filter.AvailableTo != None):
        query = query.filter(Room.AvailableTo >= filter.AvailableTo)
    if(filter.City != None and filter.City):
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

def GetUserQuery(filter):
    today = datetime.date.today()
    userSwipes = db.session.query(Swipe.UserTargetId).filter(Swipe.SwiperId == filter.UserId).filter(Swipe.FilterType == 1)
    matches = db.session.query(Match.UserOffererId).filter(Match.RoomOffererId == filter.UserId)

    query = db.session.query(User).\
        filter(User.IsVisible).\
        filter(User.Id != filter.UserId).\
        filter(User.Id.not_in(userSwipes)).\
        filter(User.Id.not_in(matches))

    if(filter.Sex != None):
        query = query.filter(User.Sex == filter.Sex)
    if(filter.AgeFrom != None):
        ageFromDate = today.replace(today.year - filter.AgeFrom)
        query = query.filter(User.BirthDate <= ageFromDate)
    if(filter.AgeTo != None):
        ageToDate = today.replace(today.year - filter.AgeTo)
        query = query.filter(User.BirthDate >= ageToDate)

    return query

def GetUserRecommendation(filter):

    userList = GetUserQuery(filter).all()
    
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

