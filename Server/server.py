from flask import Flask, request, redirect, url_for
from flask_restful import Resource, Api
from flask_jsonpify import jsonify
from firebase_ops import FirebaseOps
from review_model import ReviewModel

app = Flask(__name__)
api = Api(app)


@app.route('/m1', methods = ['GET'])
def m1():
	return jsonify({'hello':'world'})

@app.route('/gradeReview', methods =['POST'])
def review_grade():
	user = request.args.get('user')
	product = request.args.get('product')
	review_text = request.args.get('review')
	print(user, product, review_text)

	review_rating = (review_model.test_review(review_text) + 1) * 100
	print('User', user, 'got', review_rating, 'for his review of product', product, '.')
	return str(review_rating)

if __name__ == '__main__':
	global review_model, firebaseOps

	firebaseOps = FirebaseOps()
	review_model = ReviewModel()
	
	app.run(host = '0.0.0.0', debug=False, port=3000)