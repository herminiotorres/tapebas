# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tapebas.Repo.insert!(%Tapebas.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
require Logger

Faker.start()

alias Tapebas.Repo

alias Tapebas.Accounts
alias Tapebas.Events

alias Tapebas.Accounts.User

Repo.delete_all(User)

user_attrs = %{email: Faker.Internet.email(), password: "123456"}

Accounts.register_user(user_attrs)

users =
  1..10
  |> Enum.map(fn _ ->
    Accounts.register_user(%{email: Faker.Internet.email(), password: "123456"})
  end)
  |> Enum.map(fn {:ok, user} -> %{user_id: user.id} end)

events =
  1..30
  |> Enum.map(fn _ ->
    Events.create_event(%{
      title: Faker.Person.title(),
      description: Faker.StarWars.quote(),
      user_id: Enum.map(users, fn %{user_id: user_id} -> user_id end) |> Enum.random()
    })
  end)
  |> Enum.map(fn {:ok, event} -> %{event_id: event.id} end)

for %{event_id: event_id} <- events do
  1..10
  |> Enum.map(fn _ ->
    title = Faker.Person.title()

    Events.create_talk(%{
      title: title,
      slug: Slug.slugify(title),
      speaker: Faker.Person.name(),
      description: Faker.StarWars.quote(),
      type: Enum.random([:keynote, :general, :beginner, :advanced]),
      event_id: event_id
    })
  end)
  |> Enum.map(fn {:ok, talk} ->
    1..5
    |> Enum.map(fn _ ->
      Events.create_question(%{
        title: Faker.Person.title(),
        talk_id: talk.id,
        user_id: Enum.map(users, fn %{user_id: user_id} -> user_id end) |> Enum.random()
      })
    end)
  end)
end

{:ok, %{rows: question_ids}} = Repo.query("select id from questions")

for question_id <- List.flatten(question_ids) do
  1..5
  |> Enum.map(fn _ ->
    Events.create_comment(%{
      message: Faker.StarWars.quote(),
      question_id: question_id,
      user_id: Enum.map(users, fn %{user_id: user_id} -> user_id end) |> Enum.random()
    })
  end)
end

Logger.info("Use to login: #{inspect(user_attrs)}")
