from dataclasses import dataclass
import datetime

@dataclass
class RoomFilter():
    Id: int
    UserId: str
    Elo: int
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