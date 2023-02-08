ExUnit.start()
Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)
Application.put_env(:referrer_spam_list, :http_client, HTTPoison.BaseMock)
