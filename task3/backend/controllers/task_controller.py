from models.models import db, Task


def get_all_tasks():
    tasks = Task.query.all()
    return {"tasks": [task.to_dict() for task in tasks if task is not None]}, 200


def get_task_by_id(id):
    task = Task.query.get(id)
    if not task:
        return {"error": "Task not found"}, 404
    return {"task": task.to_dict()}, 200


def create_task(title, status="pending"):
    if not title:
        return {"error": "Title is required"}, 400

    if status not in Task.ALLOWED_STATUSES:
        return {"error": f"Status must be one of {list(Task.ALLOWED_STATUSES)}"}, 400

    task = Task(title=title, status=status)
    db.session.add(task)
    db.session.commit()
    return task.to_dict(), 201


def update_task(id, title, status):
    task = Task.query.get(id)
    if not task:
        return {"error": "Task not found"}, 404
    if not title:
        return {"error": "Title is required"}, 400
    if status and status not in Task.ALLOWED_STATUSES:
        return {"error": f"Status must be one of {list(Task.ALLOWED_STATUSES)}"}, 400
    task.title = title
    task.status = status if status else task.status
    db.session.commit()
    return task.to_dict(), 200


def delete_task(id):
    task = Task.query.get(id)
    if not task:
        return 404
    db.session.delete(task)
    db.session.commit()
    return 200
