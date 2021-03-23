
class TrackerBlocker
		
    private
		
        # instance variables
        #	
        #   private stuff
        #	
        @part    = nil
        @reg     = nil

        # accessible stuff -- can be returned by accessors
        #
        @tracker = nil  # <-- master list of trackers found
        @message = nil  # <-- modified email message
    
        # return a Set of trackers matched or nil
        #
        def trkmatch(s)
    
            set = SortedSet.new         # create an empty set
        
            @reg.keys.each do |k|       # loop through all the keys of the 
                                        #   tracker regexp hash
            
                if @reg[k].is_a?(Array)     # if the value is an array...
            
                    # loop through all the values & save the name of the tracker 
                    #   if there's a match
                    #
                    @reg[k].each { |t| set << k if s.to_s.match?(t) }    

                else
                
                    # the value is a single Regexp...save the name of the tracker
                    #   if there's a match
                    #
                    set << k if s.to_s.match?(@reg[k])
                    
                end
                
            end
        
            # if the set is empty return it, otherwise nil
            #
            return (set.empty?) ? nil : set
        
        end
    
        # return the "height" and "width" attributes of an <img> tag
        #
        def hw(elem)
        
            h = elem.attributes["height"].to_s.to_i
            w = elem.attributes["width"].to_s.to_i
        
            return h,w
        
        end
    	
        # Unleash the power of the 'mail' gem!
        #   
        #    Traverse each part of the message body...
        #
	def traverse
		  
	    # recurse if the body part is has multiple sub-parts...
	    #
            if @part.multipart?
            
                @part.parts.map.each { |p| @part = p; traverse }
                
            else

                # get the part's content type
                #
                ct = @part.content_type.split(';')

                # get the part's content
                #						        
                txt = @part.body.decoded

                # if the Content-Type is 'text/html'...
                #
                if ct.first.eql?("text/html")
                
                    # parse the part's content
                    #
                    #   this is powerful stuff!
                    #
                    doc = Nokogiri::HTML.parse(txt)
             
                    # for all the  <img> nodes
                    # do
                    #
                    doc.xpath('//img').each do |img|
                                            
                        # get the 'src=' attribute as a string
                        #
                        attr = img.attributes["src"].to_s
                        
                        # check it against known trackers
                        #
                        trk = trkmatch(attr)
                    
                        # if there were no matches then check the
                        #   "height" & "width" attributes
                        
                        if trk.nil?
                        
                            trk = SortedSet.new
                            h, w = hw(img)
                            
                            # it's an unknown tracker if the height & width
                            #   are both <= 1
                            #
                            trk << "unknown" if h <= 1 && w <= 1
                            
                        end
                    
                        # if there were trackers found...
                        #
                        unless trk.empty?
                        
                            img.remove          # remove the tracker <img>
                            
                            @tracker += trk     # add the names of the found trackers
                                                #   to the master list
                        end

                        @part.body = doc.to_s   # replace the part content with the 
                                                #   possibly modified content...
                    
                    end     # end of "doc.xpath('//img').each do |img|"
     
                end  # end of 'if ct.first.eql?("text/html")'
								
            end  # end of "if @part.multipart?; else"
			
		    end  # end of def
		
    # convert the TRACKERS hash of strings into a hash of Regexp's
    #
        def bldrgxp	

            # loop through all the keys of the TRACKERS hash
            #
            TRACKERS.keys.each do |k|
    
                # if the value is an array...
                #
                if TRACKERS[k].is_a?(Array)
    
                    # create an empty Array for the Regexp hash value
                    #
                    @reg[k] = []
        
                    # loop through all the TRACKER values, convert each to a Regexp
                    # n.b. the 'ix' suffix makes the Regexp EXTENDED and CASE-INSENSITIVE
                    #
                    TRACKERS[k].each { |t| @reg[k] << Regexp.new(/#{t}/ix) }
        
                else
    
                    # the value is a single string...create a Regexp from it
                    #
                    @reg[k] = Regexp.new(/#{TRACKERS[k]}/ix)
        
                end
    
            end  # end of 'TRACKERS.keys.each do |k|'

        end  # end of def
    
    public
		
        # accessors
        #
        attr_reader :message, :tracker
    
        # constructor
        #	
        def initialize(msg)
          
            @message = msg
            @part = @message
    
            @reg  = {}
            @tracker = SortedSet.new
            
            bldrgxp
    
        end

        # action
        #
        def block 
           
            traverse
    
            # add header if trackers were blocked
            #
            @message.header['X-Trackers-Blocked'] = @tracker.to_a.to_json \
                unless @tracker.empty?
                
        end
		
end  # end of 'class TrackerBlock'
