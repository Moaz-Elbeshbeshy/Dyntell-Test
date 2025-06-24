from flask import Flask, jsonify, request
from flask_cors import CORS
from models.models import db
from routes.tasks import tasks_bp

app = Flask(__name__)
CORS(app)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///tasks.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db.init_app(app)

app.register_blueprint(tasks_bp, url_prefix="/api/v1/tasks")

with app.app_context():
    db.create_all()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000, debug=True)
