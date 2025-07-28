Pry.config.commands.alias_command "c", "continue"
Pry.config.commands.alias_command "n", "next"
Pry.config.commands.alias_command "s", "step"
Pry.config.commands.alias_command "w", "watch"

Pry::Commands.command /^$/, "repeat last command" do
  _pry_.input = StringIO.new(Pry.history.to_a.last)
end
