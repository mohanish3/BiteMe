import numpy as np
import pandas as pd

import string
from random import randint
import csv

#RNN imports
#from keras import Sequential
#from keras.models import Model
#from tensorflow.keras.models import load_model
#from keras.layers import Dense, Input, Dropout, LSTM, Activation
#from keras.layers.embeddings import Embedding
#from keras.optimizers import Adam

from keras.preprocessing import sequence
from keras.preprocessing.text import Tokenizer, text_to_word_sequence
from keras.preprocessing.sequence import pad_sequences
from keras.utils import to_categorical

#RandomForest imports
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

#nltk imports
import nltk
from nltk.corpus import stopwords
nltk.download('stopwords')

from nltk.stem import WordNetLemmatizer 
from nltk.tokenize import word_tokenize 

import pickle as pkl

#Fix for reviews threading error
import keras.backend.tensorflow_backend as tb
tb._SYMBOLIC_SCOPE.value = True

#The review model trains on Deceptive Reviews dataset from Amazon
#Returns amount of credits rewarded based on the review entered
class ReviewModel:
	lemmatizer = WordNetLemmatizer() 
	model = None
	word_index = None

	def __init__(self):
		self.init_model()
		#self.train_model()
		self.load_model_file()
		#print(self.test_review('This is something I\'ve been using for the last year. A better product simply can\'t be found. Thank you Healthkart. Looking for such better products in the future. Healthy and delicious product that helps a lot. Looking forward for more products with such quality. The taste and health factor of the nutrients just makes it even better. Would buy again.'))
		#Gets rating 8/10 after training with 10000 samples

	#Gets the credits being awarded
	def get_review_rating(self, review):
		#predict value for one sentence
		y = self.model.predict(pad_sequences([next(self.texts_to_sequences([review]))], maxlen=200))
		return (int(np.argmax(y[0])) * 6 + randint(1, 4)) * randint(1, 10)

	#Loads the saved model file
	def load_model_file(self):
		print("Loading model...")

		#load RandomForest model
		self.model = pkl.load(open('model.pkl', 'rb'))
		
		#load RNN model
		#self.model = load_model('model.h5')

	#Trains the model on the dataset
	def train_model(self):
		print('Loading training data...')

		#load data from file into an array
		train_data = []
		with open('train_data.txt') as f:
			reader = csv.reader(f, delimiter='\t')
			next(reader)
			for line in reader:
				if(line[1] == '__label1__'):
					train_data.append([line[8], 0])
				else:
					train_data.append([line[8], 1])

		#load data into a dataframe
		train_df = pd.DataFrame(columns=["text", "quality"], data=train_data)
		
		#clean data
		clean_df = self.clean_data_dl(train_df, 'text')
		
		#generate sequence for training
		sequence_gen = self.texts_to_sequences(clean_df['text'].values)
		X = []
		for x in sequence_gen:
			X.append(x)
		
		#pad sequences upto 200 words
		X = pad_sequences(X, maxlen=200)

		#generate output values
		y = to_categorical(np.array(clean_df['quality'].values), num_classes=2)

		print("Training model...")
		#train RandomForest model
		self.model.fit(X, y)
		pkl.dump(self.model, open('model.pkl', 'wb'))

		#train RNN Model
		#self.model.fit(X, y, batch_size=128, epochs = 3)
		#self.model.save('model.h5')

	#Initializes the model (RandomForest or LSTM)
	def init_model(self):
		
		self.model = RandomForestClassifier(n_estimators=140)
		
		embeddings_index = {}
		dims = 200
		glove_data = 'glove.6B.'+str(dims)+'d.txt'
		
		print("Loading glove data...")
		f = open(glove_data)
		for line in f:
		    values = line.split()
		    word = values[0]
		    value = np.asarray(values[1:], dtype='float32')
		    embeddings_index[word] = value
		f.close()

		self.word_index = {w: i for i, w in enumerate(embeddings_index.keys(), 1)}
		
		'''
		#create embedding matrix
		embedding_matrix = np.zeros((len(self.word_index) + 1, dims))
		for word, i in self.word_index.items():
		    embedding_vector = embeddings_index.get(word)
		    if embedding_vector is not None:
		        # words not found in embedding index will be all-zeros.
		        embedding_matrix[i] = embedding_vector[:dims]

		embedding_layer = Embedding(embedding_matrix.shape[0],
                        embedding_matrix.shape[1],
                        weights=[embedding_matrix],
                        input_length=200)

		print("Initializing model...")
		self.model = Sequential()
		self.model.add(embedding_layer)
		self.model.add(LSTM(64, return_sequences=False, dropout=0.25))
		self.model.add(Dense(2, activation='softmax'))

		self.model.compile(loss='categorical_crossentropy', optimizer=Adam(learning_rate=0.003, decay=0.0001), metrics=['accuracy'])
		'''

	#Changes strings to number sequences
	def texts_to_sequences(self, texts):
	    for text in texts:
	        tokens = text_to_word_sequence(text)
	        yield [self.word_index.get(w) for w in tokens if w in self.word_index]

	#Lemmatizes the word i.e. gets the root value of the word
	def lemmatize_word(self, text): 
	    word_tokens = word_tokenize(text)  
	    lemmas = [self.lemmatizer.lemmatize(word, pos ='v') for word in word_tokens] 
	    return lemmas

	#Cleans the review to remove any random non-characters and make the data uniform
	def clean_data_dl(self, hd_df, col_name):

	    #Converting to lower case
	    hd_df[col_name] = hd_df[col_name].apply(lambda x: " ".join(x.lower() for x in x.split()))

	    # Removing tags
	    hd_df[col_name] = hd_df[col_name].str.replace('<.*?>','')

	    # Removing possible mentions or urls (don't know if it's necessary but might be) 
	    hd_df[col_name] = hd_df[col_name].str.replace('@\w+','')
	    hd_df[col_name] = hd_df[col_name].str.replace('http.?://[^\s]+[\s]?','')

	    # Removing punctuation and symbols
	    hd_df[col_name] = hd_df[col_name].str.replace('[^\w\s]', '')
	    hd_df[col_name] = hd_df[col_name].apply(lambda x: " ".join(y for y in x.split() if y not in string.punctuation))

	    # Removing non alphabetical character
	    hd_df[col_name] = hd_df[col_name].apply(lambda x: " ".join(y for y in x.split() if y.isalpha()))

	    # Removing characters non longer than 1
	    hd_df[col_name] = hd_df[col_name].apply(lambda x: " ".join(y for y in x.split() if len(y) > 1))

	    # Removing stopwords
	    sw = stopwords.words('english')
	    hd_df[col_name] = hd_df[col_name].apply(lambda x: " ".join(y for y in x.split() if y not in sw))

	    # Removing digits
	    hd_df[col_name] = hd_df[col_name].apply(lambda x: " ".join(y for y in x.split() if not y.isdigit()))

	    # Removing multiple spaces
	    hd_df[col_name] = hd_df[col_name].str.replace(' +',' ')

	    # Lemmatization (better than stemmatization imho)
	    hd_df[col_name] = hd_df[col_name].apply(lambda x: " ".join(self.lemmatize_word(x)))

	    return hd_df


#if __name__ == '__main__':
#	model = ReviewModel()
	