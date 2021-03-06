module UsaliaBot
  module Commands
    module Help
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      command(:help, description: 'Shows a list of all the commands available or displays help for a specific command.',
              usage: 'help <command>') do |event, command_name|
        if command_name
          if command = event.bot.commands[command_name.to_sym]
            desc = command.attributes[:description]
            usage = command.attributes[:usage]

            if usage
              result = "Usage: #{usage}"
              result += "\n\n#{desc}" if desc
              reply = event.message.reply("```\n#{result}\n```")
            else
              reply = event.message.reply("Help is not available for `#{command_name}`")
            end
          else
            reply = event.message.reply("I don't understand `#{command_name}`, plip!") unless command
          end

          delete_request(event.message, reply)
        else
          available_commands = event.bot.commands.values
            .reject { |c| !c.attributes[:help_available] }
            .sort_by(&:name)

          command_list = available_commands.reduce("For detailed usage: help <command>\n\n") do |memo, c|
            memo + "%-15s%s\n" % [c.name, c.attributes[:description] || '[No description available]']
          end

          event.user.pm("```\n#{command_list}\n```")
          event.message.delete unless event.channel.pm?
        end
      end
    end
  end
end
