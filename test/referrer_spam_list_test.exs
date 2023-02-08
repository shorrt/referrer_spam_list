defmodule ReferrerSpamListTest do
  use ExUnit.Case, async: false
  import Mox

  setup [:set_mox_global, :verify_on_exit!]

  test "fetches a spam list form the repo" do
    expect(HTTPoison.BaseMock, :get, fn _ ->
      {:ok, %{status_code: 200, body: "dummy.org\n"}}
    end)

    ReferrerSpamList.start_link([])
    Process.sleep(1000)

    assert ReferrerSpamList.is_spammer?("dummy.org")
    refute ReferrerSpamList.is_spammer?("0-0.fr")
  end

  test "reads a spam list form the file" do
    expect(HTTPoison.BaseMock, :get, fn _ -> {:error, "error"} end)

    ReferrerSpamList.start_link([])
    Process.sleep(1000)

    assert ReferrerSpamList.is_spammer?("0-0.fr")
    refute ReferrerSpamList.is_spammer?("dummy.org")
  end
end
