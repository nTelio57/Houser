from DatabaseContext import app
from RecommendationController import *
import os

if __name__ == '__main__':
    port = os.environ.get("PORT", 5002)
    app.run(port=port)