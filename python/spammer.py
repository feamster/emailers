#!/usr/bin/env python

import os
import re
import smtplib
from email.mime.text import MIMEText


class Spammer(object):

    def __init__(self, maillist, messagefile, sender, subject, cc, bcc, panelfile, modfile, prefile):

        self.ml = {}

        self.sender = sender
        self.subject = subject
        self.cc = cc
        self.bcc = bcc

        # use Google as the SMTP server
        self.smtp = smtplib.SMTP("smtp.gmail.com", 587)
        self.smtp.ehlo()
        self.smtp.starttls()
        self.smtp.ehlo()
        self.smtp.login('feamster@gmail.com', 'xsebfafxfekqdpmf')
        

        # read the main mailing list                
        with open(maillist) as f:
            for line in f.readlines():
                first, last, inst, email, area, panel, moderator, pre, invited, accepted = line.strip('\r\n').split(',')
                if not re.match(r'.*@', email): continue
                self.ml[email] = (first,last,panel,moderator,pre,invited,accepted)

        # main message
        with open(messagefile) as f:
            self.message = f.read().rstrip('\n')

        # panelists
        with open(panelfile) as f:
            self.paneltext = f.read().rstrip('\n')

        # moderators
        with open(modfile) as f:
            self.modtext = f.read().rstrip('\n')

        # pre-workshop invitation
        with open(prefile) as f:
            self.pretext = f.read().rstrip('\n')
               

    def sendMessage(self, email):

        ######
        # return if they have been invited
        #if (self.ml[email][5] == '0'): return

        ######
        # prepare the message body

        msgtxt = re.sub(r'@FIRST@', self.ml[email][0], self.message)

        ########################################
        # Handle Panel and Moderator Text
        
        if (self.ml[email][3]=='1'):
            # moderator
            msgtxt = re.sub(r'@PANELTXT@', self.modtext,
                            msgtxt)
        else:
            if len(self.ml[email][2]) > 0:
                # panelist
                msgtxt = re.sub(r'@PANELTXT@', self.paneltext,
                                msgtxt)
            else:
                # regular invitee
                msgtxt = re.sub(r'\n@PANELTXT@\n', '', msgtxt)

        # replace panel topic
        msgtxt = re.sub(r'@TOPIC@',self.ml[email][2],msgtxt)

        
        ########################################
        # Handle Pre-Workshop
        # add the invitation for pre-workshop folks
        if (self.ml[email][4] == '1'):
            # replace text with preworkshop text
            msgtxt = re.sub(r'@PREWORKSHOP@', self.pretext, msgtxt)
            msgtxt = re.sub(r'@REPLYURL@', 'https://goo.gl/forms/K2pUkGdRzpDaKXTT2', msgtxt)
        else:
            # not invited to pre-workshop, so replace with blank text
            msgtxt =re.sub(r'\n@PREWORKSHOP@\n', '', msgtxt)
            msgtxt = re.sub(r'@REPLYURL@', 'https://goo.gl/forms/K2pUkGdRzpDaKXTT2', msgtxt)
            
                    
        #########################################
        # prepare the message subject line
        if (self.ml[email][4] == '1'):
            subject = re.sub(r'@DATE@', '21', self.subject)
            msgtxt = re.sub(r'@DATE@', '21', msgtxt)
        else:
            subject = re.sub(r'@DATE@', '21', self.subject)
            msgtxt = re.sub(r'@DATE@', '21', msgtxt)



        ########################################
        # prepare the message for sending
        msg = MIMEText(msgtxt)
        msg['From'] = self.sender
        msg['To'] = '{0} {1} <{2}>'.format(self.ml[email][0],
                                            self.ml[email][1],
                                            email)
        msg['Subject'] = subject
        if len(self.cc) > 0: msg['cc'] = self.cc 
        if len(self.bcc) > 0: msg['bcc'] = self.bcc

            
        ######
        # show what will be sent
        print msg

        ######
        # actually send the message - UNCOMMENT to Send
        # self.smtp.sendmail('feamster@cs.princeton.edu',email, msg.as_string())


    def sendMessages(self):
        for email in self.ml.keys():
            self.sendMessage(email)
            
    def printEmails(self):
        for email in self.ml.keys():
            print '{0} {1} <{2}>'.format(self.ml[email][0],
                                            self.ml[email][1],
                                            email)



                        
##################################################    
#     def __init__(self, maillist, messagefile, sender, subject, cc, bcc, panelfile, modfile, prefile):

sp = Spammer('admits.txt', 'admit-text.txt',
                'Nick Feamster <feamster@cs.princeton.edu>',
                'Congratulations on Princeton admission!',
                '',
                'Nick Feamster <feamster@gmail.com>',
                'panel-logistics.txt',
                'modtext.txt',
                'pre-logistics.txt',
                )

sp.sendMessages()

