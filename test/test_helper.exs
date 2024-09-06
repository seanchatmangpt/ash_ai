ExUnit.start()

# Ensure all modules in test/support are loaded
{:ok, _} = Application.ensure_all_started(:mock)
Enum.each(Path.wildcard("test/support/*.ex"), &Code.require_file/1)
