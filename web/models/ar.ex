defmodule Forensic.AR do
  defmacro __using__(opts) do
    quote do
      def all do
        Forensic.Repo.all __MODULE__
      end

      def find(id) do
        Forensic.Repo.get(__MODULE__, id)
      end

      def build(params \\ %{}) do
        struct = __MODULE__.__struct__
        __MODULE__.changeset(struct, params)
      end

      def save(changelog) do
        Forensic.Repo.insert changelog
      end
    end
  end
end
