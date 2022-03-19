defmodule TapebasWeb.PageLive do
  @moduledoc false

  use TapebasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="w-1/2 mx-auto">
      <div class="p-6 mb-2 bg-white border border-gray-200 shadow-md rounded-md">
        <header class="w-2/5 mx-auto mb-12 text-center">
          <h1 class="mb-5 text-xl font-semibold text-gray-500">no events</h1>
          <p class="text-gray-500">Welcome to my Tapebas page. Please follow the instructions to add an event.</p>
        </header>
      </div>
    </section>
    """
  end
end
