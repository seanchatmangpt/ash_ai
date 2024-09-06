 ~/d/ash_ai   *…  iex -S mix                                                 9.1s  Thu Sep  5 23:32:47 2024
Erlang/OTP 27 [erts-15.0.1] [source] [64-bit] [smp:16:16] [ds:16:16:10] [async-threads:1] [jit]

Interactive Elixir (1.17.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> AshAi.instruct!("Test prompt", actions: [{Twitter.Support.User, :*}])
"An actor must be provided to fulfill this request."
iex(2)>     {:ok, test_user} =
...(2)>       Twitter.Support.User.create(
...(2)>         "test_user",
...(2)>         "test@example.com",
...(2)>         25
...(2)>       )

23:36:28.851 [debug] Creating Twitter.Support.User:

%{
  id: "30a1f460-a067-4ec3-88b1-e0942b7f127f",
  age: 25,
  email: "test@example.com",
  inserted_at: ~U[2024-09-06 06:36:28.837635Z],
  updated_at: ~U[2024-09-06 06:36:28.839335Z],
  username: "test_user"
}

{:ok,
 #Twitter.Support.User<
   tweets: #Ash.NotLoaded<:relationship, field: :tweets>,
   __meta__: #Ecto.Schema.Metadata<:loaded>,
   id: "30a1f460-a067-4ec3-88b1-e0942b7f127f",
   username: "test_user",
   email: "test@example.com",
   inserted_at: ~U[2024-09-06 06:36:28.837635Z],
   updated_at: ~U[2024-09-06 06:36:28.839335Z],
   age: 25,
   aggregates: %{},
   calculations: %{},
   ...
 >}
iex(3)> test_user
#Twitter.Support.User<
  tweets: #Ash.NotLoaded<:relationship, field: :tweets>,
  __meta__: #Ecto.Schema.Metadata<:loaded>,
  id: "30a1f460-a067-4ec3-88b1-e0942b7f127f",
  username: "test_user",
  email: "test@example.com",
  inserted_at: ~U[2024-09-06 06:36:28.837635Z],
  updated_at: ~U[2024-09-06 06:36:28.839335Z],
  age: 25,
  aggregates: %{},
  calculations: %{},
  ...
>
iex(4)> AshAi.instruct!("Test prompt",
...(4)>                actor: test_user,
...(4)>                actions: [{Twitter.Support.User, :*}],
...(4)>              )
warning: trailing commas are not allowed inside function/macro call arguments
└─ iex:6:53

"The test prompt has been acknowledged."
iex(5)> AshAi.instruct!("What is going on?", actor: test_user, actions: [{Twitter.Support.User, :*}])
"It appears you are using an application related to Twitter support, possibly for managing user accounts or interactions. You have access to various functions to read, create, update, or delete user information. If you have any specific actions you would like to perform or questions about the application, feel free to let me know!"
iex(6)> AshAi.instruct!("Create the Jane Doe account", actor: test_user, actions: [{Twitter.Support.User, :*}])
iex(6)> AshAi.instruct!("Create the Jane Doe account", actor: test_user, actions: [{Twitter.Support.User, :*}])

23:40:22.778 [debug] Creating Twitter.Support.User:

%{
  id: "746192d9-58d9-48b6-a843-7ca31917f599",
  age: 30,
  email: "jane.doe@example.com",
  inserted_at: ~U[2024-09-06 06:40:22.778553Z],
  updated_at: ~U[2024-09-06 06:40:22.778567Z],
  username: "jane_doe"
}

"The account for Jane Doe has been successfully created."
iex(7)>
nil
iex(8)> iex(6)> AshAi.instruct!("Create the Jane Doe account", actor: test_user, actions: [{Twitter.Support.User, :*}])
error: undefined function iex/1 (there is no such import)
└─ iex:8

** (CompileError) cannot compile code (errors have been logged)

iex(8)>
nil
iex(9)> 23:40:22.778 [debug] Creating Twitter.Support.User:
** (SyntaxError) invalid syntax found on iex:9:3:
    error: unexpected token: ":" (column 3, code point U+003A)
    │
  9 │ 23:40:22.778 [debug] Creating Twitter.Support.User:
    │   ^
    │
    └─ iex:9:3
    (iex 1.17.2) lib/iex/evaluator.ex:295: IEx.Evaluator.parse_eval_inspect/4
    (iex 1.17.2) lib/iex/evaluator.ex:187: IEx.Evaluator.loop/1
    (iex 1.17.2) lib/iex/evaluator.ex:32: IEx.Evaluator.init/5
    (stdlib 6.0.1) proc_lib.erl:329: :proc_lib.init_p_do_apply/3
iex(9)>
nil
iex(10)> %{
...(10)>   id: "746192d9-58d9-48b6-a843-7ca31917f599",
...(10)>   age: 30,
...(10)>   email: "jane.doe@example.com",
...(10)>   inserted_at: ~U[2024-09-06 06:40:22.778553Z],
...(10)>   updated_at: ~U[2024-09-06 06:40:22.778567Z],
...(10)>   username: "jane_doe"
...(10)> }
%{
  id: "746192d9-58d9-48b6-a843-7ca31917f599",
  age: 30,
  email: "jane.doe@example.com",
  inserted_at: ~U[2024-09-06 06:40:22.778553Z],
  updated_at: ~U[2024-09-06 06:40:22.778567Z],
  username: "jane_doe"
}
iex(11)>
nil
iex(12)> "The account for Jane Doe has been successfully created."
"The account for Jane Doe has been successfully created."
iex(13)> AshAi.instruct!("Update the Jane Doe account age to 30", actor: test_user, actions: [{Twitter.Support.User, :*}])
"The age for the Jane Doe account is already set to 30, so no update is needed. If you have any other requests or changes you would like to make, please let me know!"
iex(14)> AshAi.instruct!("Update the Jane Doe account age to 38", actor: test_user, actions: [{Twitter.Support.User, :*}])
"It appears the update operation could not be performed because it requires an atomic update, and the system can't match an attribute that is not changing.\n\nSince the age for Jane Doe is currently set to 30 and the update tries to set it to 38, it seems there's an issue with the update itself. \n\nWould you like me to try a different approach, or is there something else you'd like to do?"
iex(15)> AshAi.instruct!("Update the 746192d9-58d9-48b6-a843-7ca31917f599 account age to 38", actor: test_user, actions: [{Twitter.Support.User, :*}])

00:00:26.999 [debug] ETS: Updating Twitter.Support.User matching filter `id == "746192d9-58d9-48b6-a843-7ca31917f599"`:

%{
  id: if string_length(
      type("jane_doe", Ash.Type.String, [trim?: true, allow_empty?: false])
    ) < 3 do
    error(
      Ash.Error.Changes.InvalidAttribute,
      %{
        message: "must have length of at least %{min}",
        value: type(
          "jane_doe",
          Ash.Type.String,
          [trim?: true, allow_empty?: false]
        ),
        vars: %{min: 3},
        field: :username
      }
    )
  else
    type(
      if type(38, Ash.Type.Integer, []) < 13 do
        error(
          Ash.Error.Changes.InvalidAttribute,
          %{
            message: "must be greater than or equal to %{greater_than_or_equal_to}",
            value: type(38, Ash.Type.Integer, []),
            vars: %{field: :age, greater_than_or_equal_to: 13},
            field: :age
          }
        )
      else
        id
      end,
      Ash.Type.UUID,
      []
    )
  end,
  age: 38,
  email: "jane.doe@example.com",
  username: "jane_doe"
}

"The user's age has been successfully updated to 38, along with their existing email and username. Is there anything else you would like to do?"
iex(16)>