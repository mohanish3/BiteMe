import pyrebase
from getpass import getpass

class FirebaseOps:
	db = None
	firebase = None
	auth = None
	adminId = None

	def initialize(self):
		config = {
			'apiKey': "AIzaSyD8x5UUzscVOWpV6Fol2s840dW6P5wLOEo",
		    'authDomain': "biteme-1c46b.firebaseapp.com",
		    'databaseURL': "https://biteme-1c46b.firebaseio.com",
		    'projectId': "biteme-1c46b",
		    'storageBucket': "biteme-1c46b.appspot.com",
		    'messagingSenderId': "731893701791",
		    'appId': "1:731893701791:web:6466c7fa9b2795051496aa",
		    'measurementId': "G-98MLKKP9Y1"
		}

		self.firebase = pyrebase.initialize_app(config)
		self.auth = self.firebase.auth()
		self.db = self.firebase.database()

		self.authenticate()

	def authenticate(self):
		loggedIn = False
		while not loggedIn:
			print("Enter Admin Email: ")
			email = input()
			password = getpass()
			try:
				admin = self.auth.sign_in_with_email_and_password(email, password)
				admin = self.auth.refresh(admin['refreshToken'])
				self.adminId = admin['idToken']
				print()
				print('Logged in!')
				print()
				loggedIn = True
			except:
				print("Incorrect Password!")


	def create_element(self, pathList, element):
		dbRef = self.db
		for path in pathList:
			dbRef = dbRef.child(path)
		dbRef.push(element)

	def update_element(self, pathList, element):
		dbRef = self.db
		for path in pathList:
			dbRef = dbRef.child(path)
		dbRef.update(element)
