defmodule ReferrerSpamList do
  alias ReferrerSpamList.Spammers

  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec init(any) :: {:ok, %{}, {:continue, :get_spam_list}}
  def init(_) do
    {:ok, %{}, {:continue, :get_spam_list}}
  end

  def is_spammer?(hostname) do
    GenServer.call(__MODULE__, {:is_spammer, hostname})
  end

  def handle_continue(:get_spam_list, _state) do
    spam_list = Spammers.fetch() || Spammers.read_from_file()
    schedule_update()
    {:noreply, %{spam_list: spam_list}}
  end

  def handle_call({:is_spammer, hostname}, _from, state) do
    is_spammer = MapSet.member?(state.spam_list, hostname)
    {:reply, is_spammer, state}
  end

  def handle_info(:update_list, state) do
    updated_spam_list = Spammers.fetch() || state.spam_list
    schedule_update()
    {:noreply, %{state | spam_list: updated_spam_list}}
  end

  # weekly update
  @update_interval_ms :timer.hours(24 * 7)

  defp schedule_update do
    Process.send_after(self(), :update_list, @update_interval_ms)
  end
end
