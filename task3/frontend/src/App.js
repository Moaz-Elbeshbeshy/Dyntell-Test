import React, { useState } from "react";
import TaskForm from "./components/TaskForm";
import TaskList from "./components/TaskList";
import "./App.css";

function App() {
  const [refreshKey, setRefreshKey] = useState(0);
  const refreshTasks = () => setRefreshKey(prev => prev + 1);

  return (
    <div className="min-h-screen bg-gray-100 flex flex-col items-center py-8">
      <div className="w-full max-w-2xl bg-white rounded-lg shadow-md p-6">
        <h1 className="text-2xl font-bold text-gray-800 mb-6 text-center">Task Management</h1>
        <TaskForm onTaskAdded={refreshTasks} />
        <TaskList refreshKey={refreshKey} />
      </div>
    </div>
  );
}

export default App;
