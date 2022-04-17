from dataclasses import dataclass

@dataclass
class RoomPrediction():
    id: int
    prediction: float

    def __init__(self, id, prediction):
        self.id = id
        self.prediction = prediction