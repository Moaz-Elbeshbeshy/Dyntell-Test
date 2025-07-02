import { useState, useEffect } from "react";
import type { Task } from "../types";
import TaskItem from "./TaskItem";
import { API_BASE } from "../config";
import React from "react";

interface TaskListProps {
  refreshKey: number;
}

const TaskList: React.FC<TaskListProps> = ({ refreshKey }) => {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [error, setError] = useState<string | null>(null);

  const fetchTasks = async () => {
    try {
      const response = await fetch(API_BASE, {
        headers: { "Cache-Control": "no-cache" },
      });

      if (!response.ok) {
        throw new Error(`HTTP error status: ${response.status}`);
      }

      const data: { tasks: Task[] } = await response.json();
      setTasks(Array.isArray(data.tasks) ? data.tasks.slice().reverse() : []);
      setError(null);
    } catch (error) {
      console.error("Error fetching tasks:", error);
      setError("Failed to fetch tasks");
    }
  };

  useEffect(() => {
    fetchTasks();
  }, [refreshKey]);

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
};

export default TaskList;
