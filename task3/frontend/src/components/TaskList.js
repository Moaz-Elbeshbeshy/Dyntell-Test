import React, { useState, useEffect } from "react";
import TaskItem from "./TaskItem";
import { API_BASE } from "../config";

function TaskList() {
  const [tasks, setTasks] = useState([]);

  const fetchTasks = async () => {
    try {
      const response = await fetch(API_BASE);
      const data = await response.json();
      setTasks(data.tasks);
    } catch (error) {
      console.error("Error fetching tasks:", error);
    }
  };

  useEffect(() => {
    fetchTasks();
  }, []);

  return (
    <ul className="space-y-2">
      {tasks.map(task => (
        <TaskItem key={task.id} task={task} onUpdate={fetchTasks} onDelete={fetchTasks} />
      ))}
    </ul>
  );
}

export default TaskList;
