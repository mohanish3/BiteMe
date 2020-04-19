import json
from firebase_ops import FirebaseOps

firebase = FirebaseOps()

#Used to load Firebase with data scraped.
with open('bite_me_scraping/bite_me_scraping/spiders/items.json') as json_file:
    data = json.load(json_file)
    for product in data:
        elem = {'name':product['name'], 'description':product['description'], 'image':product['imageUrl'], 'source':{
        	'flipkart':
        	{
        		'price':int(product['price'])
        	}
        }}
        firebase.create_element(['products'], elem, push=True)