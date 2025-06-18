import React, { useState } from "react";

function TaskForm() {
  const [title, setTitle] = useState("");

  const handleSubmit = async e => {
    e.preventDefault();
    if (!title.trim()) return;

    try {
      const response = await fetch("http://localhost:5000/api/v1/tasks", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title }),
      });
      if (response.ok) {
        setTitle("");
        window.location.reload(); // Refresh task list
      }
    } catch (error) {
      console.error("Error adding task:", error);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="mb-6">
      <div className="flex gap-2">
        <input
          type="text"
          value={title}
          onChange={e => setTitle(e.target.value)}
          placeholder="Enter new task"
          className="flex-1 p-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        <button type="submit" className="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600">
          Add Task
        </button>
      </div>
    </form>
  );
}

export default TaskForm;
