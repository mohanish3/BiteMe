import pyrebase
from getpass import getpass
from secret import getConfig

class FirebaseOps:
	db = None
	firebase = None
	auth = None
	adminId = None

	def __init__(self):
		config = getConfig()

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
		print(dbRef)
		dbRef.push(element, self.adminId)

	def update_element(self, pathList, element):
		dbRef = self.db
		for path in pathList:
			dbRef = dbRef.child(path)
		dbRef.update(element)
