import React, { useState } from "react";
import type { Task } from "../types";

interface TaskItemProps {
  task: Task;
  onUpdate: () => void;
  onDelete: () => void;
}

const API_BASE = "http://localhost:5000/api/v1/tasks/";

const TaskItem: React.FC<TaskItemProps> = ({ task, onUpdate, onDelete }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [editTitle, setEditTitle] = useState(task.title);
  const [editStatus, setEditStatus] = useState(task.status);

  const handleStatusChange = async () => {
    const newStatus = task.status === "pending" ? "completed" : "pending";
    try {
      const response = await fetch(`${API_BASE}${task.id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title: task.title, status: newStatus }),
      });
      if (!response.ok) {
        console.error("Error updating task status");
        return;
      }
      onUpdate();
    } catch (error) {
      console.error("Error updating task:", error);
    }
  };

  const handleEditSave = async () => {
    if (!editTitle.trim()) {
      alert("Title cannot be empty");
      return;
    }
    try {
      const response = await fetch(`${API_BASE}${task.id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title: editTitle, status: editStatus }),
      });
      if (!response.ok) {
        console.error("Error saving task");
        return;
      }
      setIsEditing(false);
      onUpdate();
    } catch (error) {
      console.error("Network error saving task:", error);
    }
  };

  const handleDelete = async () => {
    try {
      const response = await fetch(`${API_BASE}${task.id}`, {
        method: "DELETE",
      });
      if (!response.ok) {
        console.error("Error deleting task");
        return;
      }
      onDelete();
    } catch (error) {
      console.error("Error deleting task:", error);
    }
  };

  return (
    <li className="flex items-center justify-between p-3 border-b">
      {isEditing ? (
        <div className="flex flex-col gap-2 w-full">
          <input
            type="text"
            value={editTitle}
            onChange={e => setEditTitle(e.target.value)}
            className="p-2 border rounded-md"
            placeholder="Task title"
          />
          <select
            value={editStatus}
            onChange={e => setEditStatus(e.target.value as "pending" | "completed")}
            className="p-2 border rounded-md">
            <option value="pending">Pending</option>
            <option value="completed">Completed</option>
          </select>
          <div className="flex gap-2">
            <button onClick={handleEditSave} className="px-3 py-1 bg-green-500 text-white rounded-md">
              Save
            </button>
            <button onClick={() => setIsEditing(false)} className="px-3 py-1 bg-gray-500 text-white rounded-md">
              Cancel
            </button>
          </div>
        </div>
      ) : (
        <>
          <div className="flex items-center gap-2">
            <input
              type="checkbox"
              checked={task.status === "completed"}
              onChange={handleStatusChange}
              className="h-5 w-5 text-blue-500 rounded"
            />
            <span className={task.status === "completed" ? "line-through text-gray-500" : ""}>
              {task.title} ({task.status})
            </span>
          </div>
          <div className="flex gap-2">
            <button onClick={() => setIsEditing(true)} className="px-3 py-1 bg-yellow-500 text-white rounded-md">
              Edit
            </button>
            <button onClick={handleDelete} className="px-3 py-1 bg-red-500 text-white rounded-md">
              Delete
            </button>
          </div>
        </>
      )}
    </li>
  );
};

export default TaskItem;
