# using Slack # Commenting out for now.
# using Dates

function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

# NOTE: Use touch() to create a file in the pwd.

"""
    update_homepage(token::String)
Takes in a Slack OAuth token and then goes and updates the index page of the website with recent messages from Slack.
"""
function update_homepage(token::String)
    messages = getchannelhistory(token, "C6A044SQH") # "C6A044SQH" is channel ID for helpdesk

    # Open index.md in append mode.. Though we should likely do so in write mode...
    open("index.md", "w") do file

        # TODO: Enable this for write mode.
        write(file, "# Preview of Slack Helpdesk History \n \n ")

        # Loop through all of the messages to write them into a file.

        previous_sender = "None"
        for message in messages

            # If the message is not a thread...
            if typeof(message) != Array{Any,1}
                date = Dates.unix2datetime(tryparse(Float64, message.ts))

                # Last message was sent by same user as the current message... So hide full date time.
                # This should also be time dependant...
                if previous_sender == message.user

                    # Make it so we only see the username and date for a user's first message (just like on Slack)
                    # Can add in: "_$(Dates.hour(date)):$(Dates.minute(date))_ \n"
                    message.text = replace(message.text, "```" => "")
                    write(file, "\n```\n$(message.text)\n```\n")
                    previous_sender = message.user

                # The last message was sent by a different user than sent the current message
                else
                    message.text = replace(message.text, "```" => "")
                    write(file, "### User: $(message.user) Timestamp:_$(date)_: \n```\n$(message.text)\n```\n\n")
                    previous_sender = message.user
                end

            # The message is a thread
            else
                # Need to do a for loop
                message[1].text = replace(message[1].text, "```" => "")
                date = Dates.unix2datetime(tryparse(Float64, message[1].ts))

                # TODO: Need to create a new file in a specified folder which view thread will link too.
                write(file, "### User: $(message[1].user) Timestamp: $(date): \n```\n$(message[1].text)\n```\n[View Thread]()\n\n")
            end
        end
    end
end
