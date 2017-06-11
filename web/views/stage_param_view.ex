defmodule Forensic.StageParamView do
  use Forensic.Web, :view

  import Ecto.Query, only: [from: 2]
  alias Forensic.StageParam, as: SP
end
