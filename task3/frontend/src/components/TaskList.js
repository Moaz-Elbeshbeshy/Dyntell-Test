import React, { useState, useEffect } from "react";
import TaskItem from "./TaskItem";
import { API_BASE } from "../config";

function TaskList() {
  const [tasks, setTasks] = useState([]);
  const [error, setError] = useState(null);

  const fetchTasks = async () => {
    try {
      const response = await fetch(API_BASE, {
        headers: { "Cache-Control": "no-cache" },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      setTasks(data.tasks || []);
      setError(null);
    } catch (error) {
      console.error("Error fetching tasks:", error);
      setError("Failed to fetch tasks");
    }
  };

  useEffect(() => {
    fetchTasks();
  }, []);

  return (
    <div>
      {error && <p className="text-red-500">{error}</p>}
      <ul className="space-y-2">
        {tasks.map(task => (
          <TaskItem key={task.id} task={task} onUpdate={fetchTasks} onDelete={fetchTasks} />
        ))}
      </ul>
    </div>
  );
}

export default TaskList;
