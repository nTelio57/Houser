from dataclasses import dataclass

@dataclass
class UserPrediction():
    id: str
    prediction: float

    def __init__(self, id, prediction):
        self.id = id
        self.prediction = prediction