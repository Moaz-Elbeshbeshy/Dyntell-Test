from flask import jsonify, Flask
import json

test1 = {"message": "Task created", "task": "new_task"}
json1 = json.dumps(test1)
print(type(json1))

app = Flask(__name__)
with app.app_context():
    test = {"message": "Task created", "task": "new_task"}
    json = jsonify(test)
    print(type(test))
    print(type(json.get_data(as_text=True)))
