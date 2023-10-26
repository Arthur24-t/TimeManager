defmodule ApiWeb.WorkingTimeView do
  use ApiWeb, :view
  use Timex
  alias ApiWeb.WorkingTimeView

  def render("index.json", %{working_times: working_times}) do
    %{data: render_many(working_times, WorkingTimeView, "working_time.json")}
  end

  def render("show.json", %{working_time: working_time}) do
    %{data: render_one(working_time, WorkingTimeView, "working_time.json")}
  end

  def render("working_time.json", %{working_time: working_time}) do
    %{id: working_time.id,
      start: Timex.format!(working_time.start, "%Y-%m-%d %H:%M:%S", :strftime),
      end: Timex.format!(working_time.end, "%Y-%m-%d %H:%M:%S", :strftime),}
  end
end
