from dataclasses import dataclass
import datetime

@dataclass
class UserFilter():
    Id: int
    UserId: str
    FilterType: int
    Elo: int
    AgeFrom: int
    AgeTo : int
    Sex: int 
    AnimalCount: int 
    IsStudying: bool 
    IsWorking: bool 
    IsSmoking: bool 
    GuestCount: int  
    PartyCount: int  
    SleepType: int  