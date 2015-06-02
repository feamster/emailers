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
    @message['reply-to'] = 'feamster@cs.princeton.edu'
  end
  
  def send(from, subject, cc=nil)
    @message['from'] = from
    @message['subject'] = subject
    @message['bcc'] = cc

    @emails.each { |t|
      t.chomp!

      name = t.split(/::/)[0]
      firstname = name.split(/\s+/)[0]
      email = t.split(/::/)[1]
      firstname = name.split(/\s+/)[0]
      topic = t.split(/::/)[2]
      
      @message['to'] = name + ' <' + email + '>'
    
      fullText = ["From: #{@message['from']}", 
		  "Reply-To: #{@message['reply-to']}", 
		  "To: #{@message['to']}",
		  "Bcc: #{@message['bcc']}", 
		  "Subject: #{@message['subject']}\n\n",
		  @message['body'].join("")].join("\n")

      fullText.gsub!(/\@NAME\@/, firstname);
      fullText.gsub!(/\@TOPIC\@/, topic);
      
      print "#{@message['to']}\n"
      print fullText
      
#      Net::SMTP.start('localhost') do |smtp|
#	smtp.send_message(fullText,
#			  @message['from'],
#			  [@message['to'], @message['cc'].split(/,/)].flatten)
#      end

    }


  end
end

list = MailList.new("maillist.txt", "letter.txt")
  list.send("Nick Feamster <feamster@cs.princeton.edu>",
	    "Interview for Coursera SDN Course?","Arpit Gupta <arpitg@cs.princeton.edu>")
