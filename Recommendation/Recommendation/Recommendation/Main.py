from DatabaseContext import app
from RecommendationController import *
import os

if __name__ == '__main__':
    port = os.environ.get("PORT", 5002)
    host = "0.0.0.0"
    app.run(host=host, port=port)