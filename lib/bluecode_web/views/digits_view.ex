defmodule BluecodeWeb.DigitsView do
  use BluecodeWeb, :view

  def render("checksum.json", %{checksum: checksum}) do
    %{
      checksum: checksum
    }
  end

  def render("digits.json", %{digits: digits}) do
    %{
      digits: digits
    }
  end
end
