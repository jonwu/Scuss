# Jon Wu
class HomeController < ApplicationController
	require 'json'
	
	def index
		page_index = 1
		data = ApplicationHelper.airingtoday(page_index)
		airing_today = JSON.parse data

		@results = airing_today['results']
		page = airing_today["total_pages"].to_f

		while (page_index < page)
			page_index += 1
			data = ApplicationHelper.airingtoday(page_index)
			airing_today = JSON.parse data
			@results += airing_today['results']
		end
		p @results
		@favorites_size = 0
		
		new_results = HomeHelper.reorder_favorites(@results, current_user)
		@favorites_size = new_results[0]
		@results = new_results[1]
		
	end
	

		

end
