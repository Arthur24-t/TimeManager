defmodule ApiWeb.ClockView do
  use ApiWeb, :view
  use Timex
  alias ApiWeb.ClockView

  def render("index.json", %{clocks: clocks}) do
    %{data: render_many(clocks, ClockView, "clock.json")}
  end

  def render("show.json", %{clock: clock}) do
    %{data: render_one(clock, ClockView, "clock.json")}
  end

  def render("clock.json", %{clock: clock}) do
    %{id: clock.id,
      time: Timex.format!(clock.time, "%Y-%m-%d %H:%M:%S", :strftime),
      status: clock.status}
  end
end
