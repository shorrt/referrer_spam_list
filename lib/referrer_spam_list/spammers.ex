defmodule ReferrerSpamList.Spammers do
  @source_url "https://raw.githubusercontent.com/matomo-org/referrer-spam-list/master/spammers.txt"

  def fetch do
    with {:ok, %{status_code: 200, body: body}} <- http_client().get(@source_url) do
      body
      |> String.split("\n")
      |> MapSet.new()
    else
      _ ->
        nil
    end
  end

  def read_from_file do
    spammers_filepath()
    |> File.read!()
    |> String.split("\n")
    |> MapSet.new()
  end

  defp http_client do
    Application.get_env(:referrer_spam_list, :http_client, HTTPoison)
  end

  defp spammers_filepath do
    Application.app_dir(:referrer_spam_list, "/priv/spammers.txt")
  end
end
