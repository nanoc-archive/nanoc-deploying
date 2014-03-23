# encoding: utf-8

Nanoc::CLI.after_setup do
  filename = File.dirname(__FILE__) + "/commands/deploy.rb"
  cmd = Nanoc::CLI.load_command_at(filename)
  Nanoc::CLI.add_command(cmd)
end
