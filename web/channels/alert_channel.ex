defmodule Forensic.AlertChannel do
  use Forensic.Web, :channel

  alias Forensic.Report, as: R

  def join("alerts:lobby", payload, socket) do
    {:ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (alert:lobby).
  def handle_in("new_report", payload, socket) do
    params = payload
             |> Map.merge(%{"timestamps" => payload[:timestamps]})
             |> Map.drop([:timestamp])

    changeset = R.changeset(%R{}, params) |> Repo.insert
    # case Repo.insert(changeset) do
    #   {:ok, report} ->
    #     IO.inspect report
    #
    #   {:error, changeset} ->
    #     IO.inspect changeset
    #     IO.puts "ERROR"
    # end
    # broadcast! socket, "new_report", payload
    {:noreply, socket}
  end
end
