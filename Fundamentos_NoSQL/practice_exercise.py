from pymongo import MongoClient

# MongoDB credentials and connection URL
user = 'root'
password = 'yWzhFhntCfH5OuNhD5fcaXWY'
host = '172.21.5.83'
connecturl = "mongodb://{}:{}@{}:27017/?authSource=admin".format(user, password, host)

# Connect to MongoDB
client = MongoClient(connecturl)

# Select the database and collection
db = client.training
collection = db.mongodb_glossary

# Documents to insert
documents = [
    {"database": "a database contains collections"},
    {"collection": "a collection stores the documents"},
    {"document": "a document contains the data in the form of key value pairs."}
]

# Insert documents into the collection
collection.insert_many(documents)

# Query and print all documents in the collection
for doc in collection.find():
    print(doc)

# close the server connecton
print("Closing the connection.")
client.close()



