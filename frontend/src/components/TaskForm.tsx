import React, { useState } from "react";
import { API_BASE } from "../config";

interface TaskFormProps {
  onTaskAdded: () => void;
}

const TaskForm: React.FC<TaskFormProps> = ({ onTaskAdded }) => {
  const [title, setTitle] = useState("");

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (!title.trim()) return;

    try {
      const response = await fetch(API_BASE, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title, status: "pending" }),
      });

      if (!response.ok) {
        const errorData = response.json();
        console.error("Server Error", errorData);
        return;
      }

      if (response.status === 201) {
        setTitle("");
        onTaskAdded();
      }
    } catch (error) {
      console.error("Error adding task:", error);
    }
  };
  return (
    <form onSubmit={handleSubmit} className="mb-6">
      <input
        type="text"
        value={title}
        onChange={e => setTitle(e.target.value)}
        placeholder="Enter new task"
        className="p-2 border rounded-md"
      />
      <button type="submit" className="ml-2 px-4 py-2 bg-blue-500 text-white rounded-md">
        Add Task
      </button>
    </form>
  );
};

export default TaskForm;
