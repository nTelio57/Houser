from DatabaseContext import app
from RecommendationController import *

if __name__ == '__main__':
    if app.debug:
        app.run(port=5002)
    else:
        app.run()