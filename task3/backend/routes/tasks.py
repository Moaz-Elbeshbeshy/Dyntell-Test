from flask import Blueprint, jsonify, request
from controllers.task_controller import (
    get_all_tasks,
    get_task_by_id,
    create_task,
    update_task,
    delete_task,
)

tasks_bp = Blueprint("tasks", __name__)


@tasks_bp.route("/", methods=["GET"])
def get_tasks_route():
    tasks, status_code = get_all_tasks()
    return jsonify(tasks), status_code


@tasks_bp.route("/", methods=["POST"])
def create_task_route():
    data = request.get_json()
    title = data.get("title")
    status = data.get("status", "pending")  # default to pending if missing
    task, status_code = create_task(title, status)
    return jsonify(task), status_code


@tasks_bp.route("/<int:id>", methods=["GET"])
def get_task_route(id):
    task, status_code = get_task_by_id(id)
    return jsonify(task), status_code


@tasks_bp.route("/<int:id>", methods=["PUT"])
def update_task_route(id):
    data = request.get_json()
    title = data.get("title")
    status = data.get("status")
    task, status_code = update_task(id, title, status)
    return jsonify(task), status_code


@tasks_bp.route("/<int:id>/", methods=["DELETE"])
def delete_task_route(id):
    status_code = delete_task(id)
    return jsonify({"message": "Task deleted"}), status_code
