from CalculationUtils import *
from Models.UserPrediction import *
from Models.RoomPrediction import *
from Models.User import *
from Models.Offer import *
import datetime
from datetime import timedelta
from DatabaseContext import db

_binaryWeight = 2;
_floatWeight = 2;
_priceWeight = 0.35;
_eloWeight = 4;

def GetRoomQuery(filter):
    query = db.session.query(Offer, User.Elo).join(User).filter(Offer.IsVisible).filter(Offer.UserId != filter.UserId)

    if(filter.AvailableFrom != None):
        query.filter(offer.AvailableFrom <= filter.AvailableFrom)
    if(filter.AvailableTo != None):
        query.filter(offer.AvailableTo >= filter.AvailableTo)
    if(filter.City != None):
        Offer.City == filter.City

    return query

def GetRoomRecommendation(filter):

    offerList = GetRoomQuery(filter).all()
    
    predictions = []
    for offer, elo in offerList:
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
        floatSimilarity = (CosineSimilarity((offer.Area, offer.FreeRoomCount), (filter.Area, filter.FreeRoomCount)))
        eloSimilarity = (EuclideanDistance(elo, filter.Elo))

        prediction = priceSimilarity * _priceWeight + binarySimilarity * _binaryWeight + floatSimilarity * _floatWeight + eloSimilarity * _eloWeight
        predictions.append(RoomPrediction(offer.Id, prediction))
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

