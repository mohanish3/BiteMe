from fuzzywuzzy import fuzz
import pandas as pd

class SearchOps:
	firebaseOps = None

	def __init__(self, firebaseOps):
		self.firebaseOps = firebaseOps


	def search_query(self, query, pathList):
		productsOrderedDict = self.firebaseOps.get_element(pathList, [])
		
		productsList = []
		for key, value in productsOrderedDict.items():
			productsList.append([key, value['name'], 0])
		df = pd.DataFrame(productsList, columns=['id', 'name', 'ratio_score'])
		df['ratio_score'] = df.apply(lambda row: fuzz.token_set_ratio(query, row['name']), axis = 1)
		df = df.sort_values('ratio_score', ascending=False)
		df = df[df['ratio_score'] > 50]
		df = df['id'].tolist()

		productsList = []
		for key, value in productsOrderedDict.items():
			if(key in df):
				productsList.append({'key':key, 'value':value})
		return {'results':productsList}

# if(__name__ == '__main__'):
# 	search = SearchOps(FirebaseOps())
# 	print(search.search_query('Snick', ['products']))