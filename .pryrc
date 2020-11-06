require "irb/completion"

Pry.config.editor = "vim"
if Pry.config.history.respond_to?(:file)
  Pry.config.history.file = "~/.irb_history"
else
  Pry.config.history_file = "~/.irb_history"
end

# alias
if defined?(PryByebug)
  Pry.config.commands.alias_command "n", "next"
  Pry.config.commands.alias_command "c", "continue"
end
