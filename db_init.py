# initialization code
from pymongo import MongoClient
client = MongoClient()  
db = client.databass
products = db.products
users = db.users

# sample items
product1 = {
  'id': 1,
  'name': 'PROTIEN POWDER BEST MUSKLE',
  'company': 'BEST MUSKLE PVT LTD',
  'avg_rating': 1,
  'likes': 2,
  'sources': [
    {
      'id': 1,
      'name': 'Amazon',
      'cost': 1
    }
  ],
  'local_reviews': [
    {
      'id': 1,
      'user': 1,
      'rating': 1,
      'likes': 0,
      'timestamp': 20200218230933,
      'content': 'This is best protien powder for best muskle. great for protien. great mixability.',
      'comments': [
        {
          'id': 1,
          'user': 2,
          'timestamp': 20200218231627,
          'content': 'hi ladys myself sunny sharma pls pm 9890316359 m alone n lonely pls pm thx'
        }
      ]
    }
  ],
  'bahark_review' = [
    {
      'id': 1,
      'rating': 1,
      'likes': 0,
      'timestamp': 20200218230954,
      'content': 'Taste mein best, mummy aur everest.'
    }
  ],
  'related_products' = []
}

user1 = {
  'id': 1,
  'name': 'Vicky Soni',
  'username': 'vickypedia',
  'password': 'Loremipsumdolors',
  'history': [
    {
      'id': 1,
      'timestamp': 20200123192905,
      'time_spent': 4
    }
  ], # products visited by user
  'likes': [1], # products liked by user
  'bookmarks': [],
  'following': [1]
}

user2 = {
  'id': 2,
  'name': 'Sunny Sharma',
  'username': 'sunny_side_up',
  'password': '=Y&mYT-b9dt3k5{V',
  'history': [
    {
      'id': 1,
      'timestamp': 20200123193532,
      'time_spent': 4
    }
  ],
  'likes': [1],
  'bookmarks': [],
  'following': [1]
}

# insert sample items into db
products.insert_one(product)
users.insert_one(user1)
users.insert_one(user2)