import pandas as pd
import numpy as np
from firebase_ops import FirebaseOps
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel
from sklearn.neighbors import NearestNeighbors

#Recommender engine that makes recommendations based on user interactions
class RecommenderEngine:
	data_matrix = None
	firebaseOps = None
	THRESHOLD = 0.3
	CONTENT_WEIGHT = [0.1, 0.9]
	#Each user action is assigned a value
	#Higher value indicates more level of interaction with the product
	ACTION_WEIGHT = {
		'bookmarks': 4,
		'viewedProducts': 1,
		'reviewedProducts': 5,
		'searchedProducts': 3
	}

	def __init__(self, firebaseOps):
		self.firebaseOps = firebaseOps

	#Gets all products
	def __get_products_data(self):
		data = self.firebaseOps.get_element(['products'], [])
		data_list = []

		for key, value in data.items():
			data_list.append([key, value['name'], value['description']])

		df = pd.DataFrame(data_list, columns=['id','title','description'])
		return df

	#Gets formatted user data with weights for each product
	def __get_users_data(self):
		data = self.firebaseOps.get_element(['users'], [])
		data_list = []

		for key, value in data.items():
			element = {'id':key}
			if('history' in value.keys()):
				for actions_key, products_acted in value['history'].items():
					for product in products_acted:
						if(product in element.keys()):
							element[product].append(self.ACTION_WEIGHT[actions_key])
						else:
							element[product] = [self.ACTION_WEIGHT[actions_key]]
			for key, value in element.items():
				if(key=='id'):
					continue
				element[key] = sum(value)/len(value)
			data_list.append(element)

		df = pd.DataFrame(data_list).set_index(['id'])
		df.fillna(0, inplace=True)
		self.data_matrix = df

	#Gets list of product similarities independent of user
	def recommend_content(self, userId):
		product_data = self.__get_products_data()
		tf = TfidfVectorizer(lowercase=True, analyzer='word', min_df=0, stop_words='english')
		tfidf_matrix_desc = tf.fit_transform(product_data['description'])
		tfidf_matrix_title = tf.fit_transform(product_data['title'])

		cosine_similarities_desc = linear_kernel(tfidf_matrix_desc, tfidf_matrix_desc)
		cosine_similarities_title = linear_kernel(tfidf_matrix_title, tfidf_matrix_title) 

		product_similarities = {}
		for idx, row in product_data.iterrows():
			similar_indices_desc = cosine_similarities_desc[idx].argsort()[:-100:-1]
			similar_indices_title = cosine_similarities_title[idx].argsort()[:-100:-1]
			similar_items = [(product_data['id'][i], cosine_similarities_title[idx][i] * self.CONTENT_WEIGHT[0] + cosine_similarities_desc[idx][i] * self.CONTENT_WEIGHT[1]) for i in similar_indices_desc][1:] 
			similar_items.sort(key = lambda x: x[1], reverse=True)
			product_similarities[row['id']] = similar_items
		
		product_query = self.data_matrix.nsmallest(n = 1, columns=userId).index.tolist()[0]
		return [product[0] for product in product_similarities[product_query] if product[1] >= self.THRESHOLD]

	#Gets list of product recommendations based on user similarity
	def recommend_collaborative(self, userId):
		self.__get_users_data()

		users_array = self.data_matrix.index.tolist()
		user_i = 0
		for i in range(len(users_array)):
			if(users_array[i] == userId):
				user_i = i

		kNN = NearestNeighbors(n_neighbors=3)
		kNN.fit(self.data_matrix)

		users_similar = np.array([x[1:] for x in kNN.kneighbors(self.data_matrix, return_distance=False)])
		
		self.data_matrix=self.data_matrix.transpose()
		recommended_products_list = set([])
		for similar_user in users_similar[user_i]:
			recommended_products_list = recommended_products_list | set(self.data_matrix.nlargest(n = 3, columns=users_array[similar_user]).index.tolist())
		recommended_products_list = list(recommended_products_list)
		return recommended_products_list

	#Combines the two techniques to get a single list
	def recommend(self):
		for user in self.firebaseOps.get_element(['users'], []).keys():
			print('Loading recommendations for user', user,'...')
			products_recommended = set(self.recommend_collaborative(user)) | set(self.recommend_content(user))
			products_recommended = list(products_recommended)
			products_recommended.sort()
			self.firebaseOps.create_element(['users', user, 'recommendations'], products_recommended)

#if (__name__ == '__main__'):
#	recommender = RecommenderEngine(FirebaseOps())
#=	recommender.recommend()