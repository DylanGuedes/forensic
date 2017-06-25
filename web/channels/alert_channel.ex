defmodule Forensic.AlertChannel do
  use Forensic.Web, :channel

  alias Forensic.Report, as: R

  def join("alerts:lobby", payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_avg", payload, socket) do
    broadcast! socket, "new_avg", payload
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (alert:lobby).
  def handle_in("new_report", payload, socket) do
    params = payload
             |> Map.merge(%{"timestamps" => payload[:timestamps]})
             |> Map.drop([:timestamp])

    changeset = R.changeset(%R{}, params) |> Repo.insert

    {:noreply, socket}
  end

  def handle_in(arg1, payload, socket) do
    {:noreply, socket}
  end
end
