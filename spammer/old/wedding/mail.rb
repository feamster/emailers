#!/usr/bin/ruby

require 'net/smtp'

class MailList
  def initialize(list, contents)
    @emails = Array.new

    IO.foreach(list) { |l|
      @emails << l if (l !~ /^\#/)
    }
    @message = Hash.new
    @message['body'] = IO.readlines(contents)
    @message['reply-to'] = 'marshini+nick-wedding@gmail.com'
  end
  
  def send(from, subject, cc=nil)
    @message['from'] = from
    @message['subject'] = subject
    @message['cc'] = cc

    @emails.each { |t|
      t.chomp!

      name = t.split(/::/)[0]
      email = t.split(/::/)[1]
      id = t.split(/::/)[2]

      firstname = name.split(/\s+/)[0]

      @message['to'] = name + ' ' + email
    
      fullText = ["From: #{@message['from']}", 
		  "Reply-To: #{@message['reply-to']}", 
		  "To: #{@message['to']}",
		  "Cc: #{@message['cc']}", 
		  "Subject: #{@message['subject']}\n\n",
		  @message['body'].join("")].join("\n")
      fullText.gsub!(/\@NAME\@/, name);
      fullText.gsub!(/\@ID\@/, id);

      print "#{@message['to']}\n"

      Net::SMTP.start('localhost') do |smtp|
	smtp.send_message(fullText,
			  @message['from'],
			  [@message['to'], @message['cc'].split(/,/)].flatten)
      end

    }


  end
end

list = MailList.new("hike-list.txt", "hike-update.txt")
  list.send("Marshini Chetty and Nick Feamster <marshini+nick-wedding@gmail.com>",
	    "Marsh and Nick Wedding: Hike Information",
	    "Marshini Chetty <marshini@gmail.com>, Nick Feamster <feamster@gmail.com>")
