defmodule Forensic.AlertChannel do
  use Forensic.Web, :channel

  def join("alerts:lobby", payload, socket) do
    {:ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (alert:lobby).
  def handle_in("new_report", payload, socket) do
    broadcast! socket, "new_report", payload
    {:noreply, socket}
  end
end
