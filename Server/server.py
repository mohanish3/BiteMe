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

if __name__ == '__main__':
	global review_model, firebaseOps

	firebaseOps = FirebaseOps()
	review_model = ReviewModel()
	
	app.run(host = '0.0.0.0', debug=False, port=3000)