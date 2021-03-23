# initialize...
#
BEGIN { stop = 0; incomment = 0 }

# start of JS block comment
#
/^[ \t]*\/\*/   {
                    incomment = 1
                }
         
# end of JS block comment
# 
/^[ \t]*\*\//   {
                    incomment = 0   # stop processing comment
                    print "# " $0   # output last comment line
                    next            # process next input line
                }

# in ruby, variables that are all CAPS are const
#
/^[ \t]*const trackers[ \t]*\=[ \t]*/   {

                                            # Change 'const trackers' to 'TRACKERS'
                                            #
                                            sub(/[ \t]*const trackers[ \t]*/, "TRACKERS")
                                            
                                            sub(/\=/, " = ")  # put whitespace arount '='
                                            print             # print the modified line
                                            next              # process next input line
                                        }
# process end of hash 
#
/^[ \t]*\}\;/   {
                    sub(/\;/, "")   # remove the ';'
                    print           # print the line
                    stop = 1        # set the stop flag -- don't care about
                                    #    any of the JS demo code that follows
                }

/^[ \t]*\/\/.*$/  { next }  # remove lines beginning with '<optional whitespace>//'...
                            #    these are not legal comments in Ruby    

# for every line not matched by one of the regexps above, do...
#
{
    if (stop == 1)          # if stopping, then exit
    {
        exit
    }
    else {                  # otherwise...
    
        if (incomment == 1)     # if processing block comment...
        {
            print "# " $0       #   prefix comment lines with the ruby comment marker
            
        } else {                # otherwise...
            
            sub(/\/\/.*$/, "")  #   turn lines like "blah blah blah // some comment"
                                #       into "blah blah blah" ... '// comment' is not
                                #       legal in ruby
                                
            gsub(/a-zA-Z0-9-/, "a-zA-Z0-9\\\\-") #  escape 'naked' dash -- legal in JS
                                                 #      but generates compile warnings
                                                 #      in ruby

            sub(/\:/, " =>") #   change ':' to the ruby hash operator ' =>'

            sub(/Unknown/, "\"Unknown\"") #    change 'Unknown' to '"Unknown"'
            
            print "     " $0    #   print the modified line to stdout
            
        }   # end of 'if (incomment == 1)...'
        
    }   # end of 'if (stop == 1)...'
    
}   # done
 