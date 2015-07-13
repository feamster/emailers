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
    @message['reply-to'] = 'bismark-core@projectbismark.net'
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

list = MailList.new("bismark-list.txt", "update-letter.txt")
  list.send("Project BISmark <bismark-core@projectbismark.net>",
	    "BISmark router shipping to your house in one week! (Please confirm)",
	    "Nick Feamster <feamster@cc.gatech.edu>")
