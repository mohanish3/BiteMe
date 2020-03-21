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
		dbRef.set(element, self.adminId)

	def update_element(self, pathList, element):
		dbRef = self.db
		for path in pathList:
			dbRef = dbRef.child(path)
		dbRef.update(element)

	def get_element(self, pathList, queryParams):
		dbRef = self.db
		for path in pathList:
			dbRef = dbRef.child(path)
		for query in queryParams:
			if(query[0] == 'order_by_child'):
				dbRef = dbRef.order_by_child(query[1])
			elif(query[0] == 'equal_to'):
				dbRef = dbRef.equal_to(query[1])
			elif(query[0] == 'start_at'):
				dbRef = dbRef.start_at(query[1])
			elif(query[0] == 'end_at'):
				dbRef = dbRef.end_at(query[1])
			elif(query[0] == 'limit_to_first'):
				dbRef = dbRef.limit_to_first(query[1])
			elif(query[0] == 'limit_to_last'):
				dbRef = dbRef.limit_to_last(query[1])
			elif(query[0] == 'order_by_key'):
				dbRef = dbRef.order_by_key()
			elif(query[0] == 'order_by_value'):
				dbRef = dbRef.order_by_value()
		return dbRef.get().val()