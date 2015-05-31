
def highlight(print_logue)
  prologue =
"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"
  \"http://www.w3.org/TR/html4/strict.dtd\">
<html>
<head>
<title>source file</title>
<style type=\"text/css\"><!--
BODY   { background: white; }
.KEY   { color: blue; font-weight: bold; }
.STR   { color: green; }
.INT   { color: red; }
.FLOAT { color: purple; }
.COMM  { color: green; font-style: italic; }
.CHAR  { color: fuchsia; }
.BOOL  { color: teal; font-weight: bold; }
.OPER  { color: aqua; }
.ID    { color: maroon; }
// more can be added
--></style>
</head>
<body>
<pre>
<tt>"

  epilogue =
"</tt>
</pre>
</body>
</html>
"

  re_key = /abstract|assert|boolean|break|byte|case|catch|char|class|const|continue|default|double|do|else|enum|extends|finally|final|float|for|goto|if|implements|import|instanceof|interface|int|long|native|new|package|private|protected|public|return|short|static|strictfp|super|switch|synchronized|this|throws|throw|transient|try|void|volatile|while/
  keys = ["abstract","assert","boolean","break","byte","case","catch","char","class","const","continue","default","do","double","else","enum","extends","final","finally","float","for","goto","if","implements",
    "import","instanceof","int","interface","long","native","new","package","private","protected","public","return","short","static","strictfp","super","switch","synchronized","this","throw","throws","transient",
    "try","void","volatile","while"];
  keys_table = Hash.new
  keys.each{|key|
    keys_table[key] = 1;
  }


  re_id = /[a-zA-Z_\$]+[\w_\$]*/
  re_int = /((0[xX][0-9a-fA-F]+|(0[0-7]+)|(0|[1-9][\d]*))[lL]?)/

  re_float_with_e = /((([\d]+\.?[\d]*)|([\d]*\.?[\d]+))[eE][+-]?[\d]+)/
  re_float_without_e = /([\d]*\.[\d]+|[\d]+\.[\d]*)/
  re_float = /(((([\d]+\.?[\d]*|[\d]*\.?[\d]+)(e|E)[+-]?[\d]+)|([\d]*\.[\d]+|[\d]+\.[\d]*))[fFdD]?)/

  re_bool = /(true|false)/
  bools_table = Hash.new
  bools_table["true"] = 1;
  bools_table["false"] = 1;

  re_char = /('(\\.|[^'])')/
  re_str = /("(\\.|[^"])*")/

  re_oper = /!=|!|%=|%|&&|&=|&|\*=|\*|\+\+|\+=|\+|--|-=|-|\/=|\/|:|<<=|<<|<=|<|==|=|>>>=|>>>|>>=|>>|>=|>|\?|\^=|\^|\|=|\|\||\||~/
  re_comm = /\/\/.*/

  res = [[re_key,"KEY"],[re_id,"ID"],[re_int,"INT"],[re_float,"FLOAT"],[re_bool,"BOOL"],[re_char,"CHAR"],[re_str,"STR"],[re_oper,"OPER"],[re_comm,"COMM"]]

  type_re = Hash.new
  res.each{|re,type|
    type_re[type]=re
  }


  # log = File.new("log","w")

  if print_logue
    STDOUT.print(prologue)
  end

  while line = STDIN.gets()
    sub_line = line[0,line.length-1];

    output_line = ""
    output_line_format = ""

    start = 0;
    while(start<line.length-1)
      sub_line = line[start, line.length]
      # log.puts("#{sub_line}")

      min_offset = sub_line.length

      type = "OTHER"; best_match_len = 0; best_match = ""

      type_re.keys.sort.each{|t|
        sub_line.scan(type_re[t]){|m|
          if m.class == Array
            m = m[0]
          end

          if (t != "ID") or (t == "ID" and !(keys_table[m]) and !(bools_table[m]))
              offset = $`.size
              # log.puts("#{t} \t" + " #{m} \t#{m.length} \t offset: #{offset}")

              if (offset < min_offset) or (offset == min_offset and m.length > best_match_len)
                min_offset = offset
                type = t
                best_match = m
                best_match_len = best_match.length
              end
          end
        }
      }

      start += min_offset + best_match.length

      if type=="OTHER"
        sub_line_format = sub_line.gsub("&","&amp;")
        sub_line_format.gsub!("<", "&lt;")
        sub_line_format.gsub!(">", "&gt;")
        sub_line_format.gsub!(/\"/, "&quot;")

        output_line += sub_line
        output_line_format += sub_line_format
      else
        best_match_format = best_match.to_s.gsub("&","&amp;")
        best_match_format.gsub!("<", "&lt;")
        best_match_format.gsub!(">", "&gt;")
        best_match_format.gsub!(/\"/, "&quot;")

        replace = "<span class=\"#{type}\">#{best_match}</span>"
        replace_format = "<span class=\"#{type}\">#{best_match_format}</span>"

        output_line += sub_line[0, min_offset + best_match_len].sub(best_match){replace}
        output_line_format += sub_line[0, min_offset + best_match_len].sub(best_match){replace_format}
      end

      # log.puts("best match\t: #{best_match} \nbest_match_len\t: #{best_match.length} \nmin_offset\t: #{min_offset}")
      # log.puts("final type\t: #{type}")
      # log.puts("---------------------------")
    end
    # log.puts("output:\t"+ "#{output_line}")
    # log.puts("============================")

    STDOUT.puts(output_line_format)
  end

  if print_logue
    STDOUT.puts(epilogue)
  end

  # log.close
  #STDIN.close
  #STDOUT.close
end

# read arguments
print_logue = true
ARGV.each {|arg|
  if arg == '-n'
    print_logue = false
  end
}
highlight(print_logue)

