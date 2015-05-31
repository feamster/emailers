# read group file
gp_file = File.new(ARGV[1],"r")
re_gp = /([a-zA-Z0-9]{1,8}):\*:([0-9]+)/
tb_gp = Hash.new
while !gp_file.eof
  line = gp_file.readline  
  matches = line.scan(re_gp)[0]  
  if matches != nil
    gp = matches[0]
    gp_NO = matches[1]  
    if tb_gp[gp_NO] == nil
      tb_gp[gp_NO] = gp
    end
  end
end

# read password file
pw_file = File.new(ARGV[0],"r")
re_pw = /([a-zA-Z0-9]{1,8}):\*:([0-9]+)/
tb_pw = Hash.new

while !pw_file.eof
  line = pw_file.readline
  matches = line.scan(re_gp)[0]
  if matches != nil
    name = matches[0]
    pw = matches[1]
    if tb_pw[name] == nil
      tb_pw[name] = pw
    end
  end
end

abr_day = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']
abr_month = ['Jan','Feb','Mar','Apr','May','June','Jun', 'July','Jul','Aug','Sep','Sept', 'Oct','Nov','Dec']
month_days = Hash.new
month_days['Jan'] = 31
month_days['Feb'] = 29
month_days['Mar'] = 31
month_days['Apr'] = 30
month_days['May'] = 31
month_days['Jun'] = 30
month_days['June'] = 30
month_days['July'] = 31
month_days['Jul'] = 31
month_days['Aug'] = 31
month_days['Sep'] = 30
month_days['Sept'] = 30
month_days['Oct'] = 31
month_days['Nov'] = 30
month_days['Dec'] = 31

tb_login = Hash.new
tb_login_times = Hash.new
tb_groups_login_times = Hash.new
tb_duplicate_pair_name = Hash.new
tb_duplicate_pair_time = Hash.new
ay_logins = []
 
while (line = STDIN.gets())  
  line.rstrip!
  line.lstrip!
  line.gsub!('\t', ' ')
  tokens = line.split(' ')
    
  if tokens.size != 7
    next
  end

  name  = tokens[0]  
  day_abr = tokens[1]  
  month =  tokens[2]
  day = tokens[3].to_s.to_i
  time_start = tokens[4]
  duration = tokens[5]
  host = tokens[6] 
  
  login_hour_min_sec = time_start.scan(/(([0-9]{2}):([0-9]{2}):([0-9]{2}))/)
  str_start_time = login_hour_min_sec[0][0].to_s  
  start_hour = login_hour_min_sec[0][1].to_s
  start_min = login_hour_min_sec[0][2].to_s
  start_sec = login_hour_min_sec[0][3].to_s    

  du_hour_min_sec = duration.scan(/((([0-9]*)\+)?([0-9]{2}):([0-9]{2}):([0-9]{2}))/)
  str_du_time = du_hour_min_sec[0][0].to_s
  du_day =  du_hour_min_sec[0][2].to_s
  du_hour = du_hour_min_sec[0][3].to_s
  du_min = du_hour_min_sec[0][4].to_s
  du_sec = du_hour_min_sec[0][5].to_s     
  
  # check the validity of the input    
  if !abr_day.include?(day_abr) || !abr_month.include?(month) || day <= 0 || day > month_days[month] || 
    start_hour.to_i >24 || start_min.to_i >60 ||start_sec.to_i>60
    next
  end
  
  login_time = Time.local(2012,month,day,start_hour,start_min,start_sec)
  logout_time = login_time+du_sec.to_i+du_min.to_i*60+du_hour.to_i*3600+du_day.to_i*3600*24
  login_times = 1+(start_sec.to_i + du_sec.to_i + (start_min.to_i+du_min.to_i)*60 + (start_hour.to_i+du_hour.to_i)*3600)/(3600*24)+du_day.to_i  

  login = Hash.new
  login["name"] = name
  login["day_abr"] = day_abr
  login["month"] = month
  login["day"] = day
  login["str_start_time"] = str_start_time
  login["str_du_time"] = str_du_time
  login["login_time"] = login_time
  login["logout_time"] = logout_time
  login["login_times"] = login_times
  login["host"] = host    
  
  
  ay_logins = ay_logins + [login]  
    
              
  if tb_login[name] == nil    
    tb_login[name] = [login]
    tb_login_times[name] = login_times       
  else
    # duplicate login info categorized by user
    tb_login[name].each{|prior_login|           
      if (login_time<=>prior_login["login_time"])==1 and (login_time<=>prior_login["logout_time"])==-1 and host != prior_login["host"]
        if tb_duplicate_pair_name[name]== nil
          tb_duplicate_pair_name[name] = [[prior_login,login]]        
        else
          tb_duplicate_pair_name[name] = tb_duplicate_pair_name[name] + [[prior_login,login]]          
        end 
      end      
    }            
    
    # duplicate login info categorized by login time
    ay_logins.each{|prior_login|
      if (name == prior_login["name"]) and (login_time<=>prior_login["login_time"])>=0 and (login_time<=>prior_login["logout_time"])<=0 and host != prior_login["host"]
        if tb_duplicate_pair_time[prior_login["login_time"]] == nil
          tb_duplicate_pair_time[prior_login["login_time"]] = [[name,prior_login,login]]          
        else
          tb_duplicate_pair_time[prior_login["login_time"]] = tb_duplicate_pair_time[prior_login["login_time"]] + [[name,prior_login,login]]      
        end                                            
      end
    } 
    
    tb_login[name] = tb_login[name] + [login]
    tb_login_times[name] = tb_login_times[name] + login_times       
  end
  
  gp_name = tb_gp[tb_pw[name]]  
  if tb_groups_login_times[gp_name] == nil
    tb_groups_login_times[gp_name] = login_times
  else
    tb_groups_login_times[gp_name] = tb_groups_login_times[gp_name] + login_times
  end
end

#output
puts("Section #1:")
users = tb_login_times.keys().sort()
users.each{|name|
  STDOUT.puts("  #{name}: #{tb_login_times[name]} time(s).")
}
STDOUT.puts("")

puts("Section #2:")
groups = tb_groups_login_times.keys.sort()
groups.each{|group|
  STDOUT.puts("  #{group} group: #{tb_groups_login_times[group]} time(s).")
}
STDOUT.puts("")

puts("Section #3:")
=begin
tb_duplicate_pair.keys.each{|name|    
  tb_duplicate_pair[name].each{|dup|    
    STDOUT.puts("  #{name}:")    
    STDOUT.puts("    #{dup[0]["day_abr"]} #{dup[0]["month"]} #{dup[0]["day"]} #{dup[0]["str_start_time"]} #{dup[0]["str_du_time"]} #{dup[0]["host"]}")
    STDOUT.puts("    #{dup[1]["day_abr"]} #{dup[1]["month"]} #{dup[1]["day"]} #{dup[1]["str_start_time"]} #{dup[1]["str_du_time"]} #{dup[1]["host"]}")
    STDOUT.puts("")
  }  
}
=end
  tb_duplicate_pair_time.keys.sort.each{|login_time|
    dups = tb_duplicate_pair_time[login_time]   
    dups.each{|dup|      
      STDOUT.puts("  #{dup[0]}:")    
      STDOUT.puts("    #{dup[1]["day_abr"]} #{dup[1]["month"]} #{dup[1]["day"]} #{dup[1]["str_start_time"]} #{dup[1]["str_du_time"]} #{dup[1]["host"]}")
      STDOUT.puts("    #{dup[2]["day_abr"]} #{dup[2]["month"]} #{dup[2]["day"]} #{dup[2]["str_start_time"]} #{dup[2]["str_du_time"]} #{dup[2]["host"]}")
      STDOUT.puts("")
    }
  }  

