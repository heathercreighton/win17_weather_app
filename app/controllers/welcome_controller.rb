class WelcomeController < ApplicationController
  def test
  		response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/CA/San_Francisco.json")


			puts "----------------------------------------------"  	
			puts response
			puts "----------------------------------------------"  



			@location = response['location']['city']
		  @temp_f = response['current_observation']['temp_f']
		  @temp_c = response['current_observation']['temp_c']
		  @weather_icon = response['current_observation']['icon_url']
		  @weather_words = response['current_observation']['weather'] 
		  @forecast_link = response['current_observation']['forecast_url']
		  @real_feel = response['current_observation']['feelslike_f']	

  end

  def index
		 @cities = Location.all
  	# Creates an array of states that our user can choose from on our index page
    @states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NB KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC).sort!

    # removes spaces from the 2-word city names and replaces the space with an underscore 
      
      if params[:city] != nil

					location_array = params[:city].split(" ")	

				puts "----------------------------------------------"  	
				puts location_array
				puts "----------------------------------------------"  

					location_array.each do |location|
						location.capitalize!
					end
					params[:city] = location_array.join(" ")					

          params[:city].gsub!(" ", "_")
      end

       puts "----------------------------------------------"  	
				puts params[:city]
				puts "----------------------------------------------"  

    #checks that the state and city params are not empty before calling the API
      # if params[:state] != "" && params[:city] != "" && params[:state] != nil && params[:city] != nil
      if params[:state].blank? &&  params[:city].blank? 
    	    @error = "Please enter a valid input. "  #+ results['response']['error']['description']

    	else    


      	found = false 
	      

			
	 			results = HTTParty.get("http://api.wunderground.com/api/#{Figaro.env.wunderground_api_key}/geolookup/conditions/q/#{params[:state]}/#{params[:city]}.json")

	 			puts "----------------------------------------------"  	
				puts results
				puts "----------------------------------------------"  

						
	 		
		  

           #if no error is returned from the call, we fill our instants variables with the result of the call
        if results['response']['error'] == nil || results['error'] ==""
    
        #Checks to see if the response contains an array (ambigous response for an invalid city/state combination) or a hash(valid response)
            if results.key?("location") 
		    	    @location = results['location']['city']
		        	    @temp_f = results['current_observation']['temp_f']
		    	    @temp_c = results['current_observation']['temp_c']
		    	    @weather_icon = results['current_observation']['icon_url']
		    	    @weather_words = results['current_observation']['weather']
		    	    @forecast_link = results['current_observation']['forecast_url']
		    	    @real_feel_f = results['current_observation']['feelslike_f']
		    	    @real_feel_c = results['current_observation']['feelslike_c']
					        
					    if @weather_words == "Sunny" || @weather_words == "Clear"
										@body_class = "sunny"
									elsif @weather_words == "Snow"
										@body_class = "snow"
									elsif @weather_words.include?('Rain') || @weather_words == "Shower"	
										@body_class = "rain"

									elsif @weather_words == "Overcast" || @weather_words == "Mostly Cloudy" || @weather_words == "Fog"
										@body_class = "cloudy"
									elsif @weather_words.include?('Fog') 	
										@body_class = "foggy"	
									elsif @weather_words == "Partly Cloudy" || @weather_words == "Partly Sunny"
										@body_class = "partly_sunny"	
								else
										@body_class = "default"		
								
										
							end


								 	
							@cities.each do |city|
				      	if city.city == params[:city] && city.state == params[:state]
				      		found = true
				      	end	
				      end

				      if found == false
					 			new_city = Location.create(city: params[:city], state: params[:state])
							end

		        else
    	    		@error = "City/State combination does not exist." 
    				end		
         
        end

		   
    	end
    		
    	@cities = Location.all
   
		end

end
