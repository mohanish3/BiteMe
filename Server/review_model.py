import numpy as np
import pandas as pd

import string
from random import randint

from keras import Sequential
from keras.models import Model
from tensorflow.keras.models import load_model
from keras.layers import Dense, Input, Dropout, LSTM, Activation
from keras.layers.embeddings import Embedding
from keras.preprocessing import sequence
from keras.preprocessing.text import Tokenizer, text_to_word_sequence
from keras.preprocessing.sequence import pad_sequences
from keras.initializers import glorot_uniform
from keras.utils import to_categorical

from nltk.corpus import stopwords

from nltk.stem import WordNetLemmatizer 
from nltk.tokenize import word_tokenize 

#Fix for reviews threading error
import keras.backend.tensorflow_backend as tb
tb._SYMBOLIC_SCOPE.value = True

class ReviewModel:
	lemmatizer = WordNetLemmatizer() 
	model = None
	word_index = None

	def __init__(self):
		self.init_model()
		#self.train_model()
		self.load_modelh5()
		#print(self.test_review('This is something I\'ve been using for the last year. A better product simply can\'t be found. Thank you Healthkart. Looking for such better products in the future. Healthy and delicious product that helps a lot. Looking forward for more products with such quality. The taste and health factor of the nutrients just makes it even better. Would buy again.'))
		#Gets rating 8/10 after training with 10000 samples

	def test_review(self, review):
		y = self.model.predict(pad_sequences([next(self.texts_to_sequences([review]))], maxlen=200))
		return int(np.argmax(y[0]))

	def load_modelh5(self):
		print("Loading model...")
		self.model = load_model('model.h5')

	def train_model(self):
		print('Loading data...')

		f = open('train.ft.txt')
		train_data = []
		TRAIN_SAMPLES = 10000
		sample_count = 0
		for line in f:
			if(sample_count == TRAIN_SAMPLES):
				break
			X = line[11:]
			label = int(line[9])
			y = randint((label-1) * 5, (label * 5) - 1)
			train_data.append([X, y])
			sample_count += 1
		f.close()

		train_df = pd.DataFrame(columns=["text", "quality"], data=train_data)
		clean_df = self.clean_data_dl(train_df, 'text')
		print(clean_df.head())

		#generate sequence for training
		sequence_gen = self.texts_to_sequences(clean_df['text'].values)
		X = []
		for x in sequence_gen:
			X.append(x)
		X = pad_sequences(X, maxlen=200)

		#generate output values
		y = to_categorical(np.array(clean_df['quality'].values), num_classes=10)

		self.model.fit(X, y, batch_size=128, epochs = 5)
		self.model.save('model.h5')

	def init_model(self):
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
		self.model.add(Dropout(0.3))
		self.model.add(LSTM(256, return_sequences=True, dropout=0.3, recurrent_dropout=0.2))
		self.model.add(LSTM(256, dropout=0.3, recurrent_dropout=0.2))
		self.model.add(Dense(10, activation='softmax'))

		self.model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
		

	def texts_to_sequences(self, texts):
	    for text in texts:
	        tokens = text_to_word_sequence(text)
	        yield [self.word_index.get(w) for w in tokens if w in self.word_index]

	def lemmatize_word(self, text): 
	    word_tokens = word_tokenize(text)  
	    lemmas = [self.lemmatizer.lemmatize(word, pos ='v') for word in word_tokens] 
	    return lemmas

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
	    #sw = stopwords.words('english')
	    #hd_df[col_name] = hd_df[col_name].apply(lambda x: " ".join(y for y in x.split() if y not in sw))

	    # Removing digits
	    hd_df[col_name] = hd_df[col_name].apply(lambda x: " ".join(y for y in x.split() if not y.isdigit()))

	    # Removing multiple spaces
	    hd_df[col_name] = hd_df[col_name].str.replace(' +',' ')

	    # Lemmatization (better than stemmatization imho)
	    hd_df[col_name] = hd_df[col_name].apply(lambda x: " ".join(self.lemmatize_word(x)))

	    return hd_df


if __name__ == '__main__':
	model = ReviewModel()
	