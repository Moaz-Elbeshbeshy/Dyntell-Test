import React from "react";

function TaskItem({ task, onUpdate, onDelete }) {
  const handleStatusChange = async () => {
    try {
      await fetch(`http://localhost:5000/api/tasks/${task.id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status: task.status === "pending" ? "completed" : "pending" }),
      });
      onUpdate();
    } catch (error) {
      console.error("Error updating task:", error);
    }
  };

  const handleDelete = async () => {
    try {
      await fetch(`http://localhost:5000/api/tasks/${task.id}`, {
        method: "DELETE",
      });
      onDelete();
    } catch (error) {
      console.error("Error deleting task:", error);
    }
  };

  return (
    <li className="task-item flex items-center justify-between p-3 border-b">
      <div className="flex items-center gap-2">
        <input
          type="checkbox"
          checked={task.status === "completed"}
          onChange={handleStatusChange}
          className="h-5 w-5 text-blue-500 rounded"
        />
        <span className={task.status === "completed" ? "line-through text-gray-500" : ""}>{task.title}</span>
      </div>
      <button onClick={handleDelete} className="px-3 py-1 bg-red-500 text-white rounded-md hover:bg-red-600">
        Delete
      </button>
    </li>
  );
}

export default TaskItem;
