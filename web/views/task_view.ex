defmodule Forensic.TaskView do
  use Forensic.Web, :view

  def render("index.json", %{tasks: tasks}) do
    %{
      tasks: Enum.map(tasks, &task_json/1)
    }
  end

  def task_json(task) do
    %{
      title: task.title,
      description: task.description,
      script: task.script,
      updated_at: task.updated_at
    }
  end
end
