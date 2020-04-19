from flask import Flask, request, redirect, url_for
from flask_restful import Resource, Api
from flask_jsonpify import jsonify
from firebase_ops import FirebaseOps
from review_model import ReviewModel
from recommender_engine import RecommenderEngine
from search_ops import SearchOps
from apscheduler.triggers.combining import OrTrigger
from apscheduler.triggers.cron import CronTrigger
from apscheduler.schedulers.background import BackgroundScheduler

app = Flask(__name__)
api = Api(app)

#Returns a score for the review
@app.route('/gradeReview', methods =['POST'])
def review_grade():
	user = request.args.get('user')
	product = request.args.get('product')
	review_text = request.args.get('review')
	print(user, product, review_text)

	#review_rating = 0
	review_rating = review_model.get_review_rating(review_text)
	print('User', user, 'got', review_rating, 'for his review of product', product, '.')
	return str(review_rating)

#Fires a search query and returns a list of products
@app.route('/searchProduct', methods =['GET'])
def search_query():
	query = request.args.get('query')
	return search_ops.search_query(query, ['products'])

if __name__ == '__main__':
	global review_model, firebaseOps, search_ops, recommender

	#Initializes firebase and logs admin in
	firebaseOps = FirebaseOps()
	firebaseOps.authenticate()

	#Initializes search engine and recommender engine
	search_ops = SearchOps(firebaseOps)
	recommender = RecommenderEngine(firebaseOps)

	#Sets trigger for every three hours to make recommendations
	trigger = OrTrigger([CronTrigger(hour=0, minute=0), CronTrigger(hour=3, minute=0), 
		CronTrigger(hour=6, minute=0), CronTrigger(hour=9, minute=0), CronTrigger(hour=12, minute=0), 
		CronTrigger(hour=15, minute=0), CronTrigger(hour=18, minute=0), CronTrigger(hour=21, minute=0)])

	#Sets the scheduler for every 3 hours of recommendations
	scheduler = BackgroundScheduler()
	scheduler.add_job(recommender.recommend, trigger) #Get recommendations every 3 hours
	scheduler.start()

	#Initializes the model that assigns credits based on reviews
	review_model = ReviewModel()
	
	app.run(host = '0.0.0.0', debug=False, port=3000)