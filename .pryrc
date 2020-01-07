require "irb/completion"

Pry.config.editor = "vim"
Pry.config.history.file = "~/.irb_history"

# alias
if defined?(PryByebug)
  Pry.config.commands.alias_command "n", "next"
  Pry.config.commands.alias_command "c", "continue"
end
