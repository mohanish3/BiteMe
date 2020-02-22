from flask import Flask, request, redirect, url_for
from flask_restful import Resource, Api
from flask_jsonpify import jsonify
#from flask_cors import CORS, cross_origin
from firebase_ops import FirebaseOps

app = Flask(__name__)
api = Api(app)
#CORS(app)

@app.route('/m1', methods = ['GET'])
def m1():
	return jsonify({'hello':'world'})

if __name__ == '__main__':
	firebaseOps = FirebaseOps()
	firebaseOps.initialize()
	
	app.run(host = '0.0.0.0', debug=False, port=3000)