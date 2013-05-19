#= require jquery_ujs
$(document).ready ->

	#secondary nav drop down animation
	$('#show_info a').click ->
		if $("#more_info").is(":hidden")
		  $("#more_info").slideDown "slow"
		  $('.navbar').animate
		  	top:120,
		  	"slow"
		  $("#show_info a").text "Close"
		else
		  $("#more_info").slideUp "slow"
		  $('.navbar').animate
		  	top:0,
		  	"slow"
		  $("#show_info a").text "Info"	  

	#tooltip initiation	  
	$('.tip').tooltip()

	#profile settings slider
	current_frequency = $('#slider').data "current"
	$ ->
	  $("#slider").slider
	    min: 1
	    max: 5
	    step: 1
	    value: current_frequency
	    animate: 'true'	
	    slide: (event, ui) ->
	     $("#user_email_frequency").val ui.value

	  $("#user_email_frequency").val $("#slider").slider("value")

	#popovers for buy and share
	$(".share, .buy").click ->
      $(this).toggleClass "active"

    $("body").on "click", ".popover a", ->
    	$(".share, .buy").each ->
	    	$(this).popover "hide"
		    $(this).removeClass "active"


	$("body").on "click", (e) ->
	  $(".share, .buy").each ->
	    if not ($(this).is(e.target) or $(this).has(e.target).length > 0) and $(this).siblings(".popover").length isnt 0 and $(this).siblings(".popover").has(e.target).length is 0
	      $(this).popover "hide"
	      $(this).removeClass "active"

	$('.image').click ->
		$('.front').toggleClass('front-flip')
		$('.back').toggleClass('back-flip')

	$(".share_sngtrkr").popover
		html: true
		content: $(".sngtrkr_pop").html();

	$(".share_artist").each ->
	  $elem = $(this)
	  art_id = $elem.attr("id")
	  $elem.popover
	    html: true
	    content: $(".art_pop_"+ art_id + "").html()

	$(".share_release").each ->
	  $elem = $(this)
	  rel_id = $elem.attr("id")
	  $elem.popover
	    html: true
	    content: $(".rel_pop_"+ rel_id + "").html()

	$(".buy").each ->
	  $elem = $(this)
	  buy_id = $elem.attr("id")
	  $elem.popover
	    html: true
	    content: $(".buy_pop_"+ buy_id + "").html()

	#handling multiple modals, closing others when a modal is triggered
	$('.signup').click ->
		$('#user_login').modal "hide"
		$('#forgot_password').modal "hide"
		$('.signup').children().addClass "active"

	$('.login').click ->
		$('#user_signup').modal "hide"
		$('#forgot_password').modal "hide"
		$(this).parent().addClass "active"

	$('#user_login').on "hidden", ->
		$('.login').parent().removeClass "active"

	$('#user_signup').on "hidden", ->
		$('.signup').children().removeClass "active"

	$('#user_login a').click ->
		$('#user_login').modal "hide"

	$('#forgot_password a').click ->
		$('#forgot_password').modal "hide"
		$('.login').parent().addClass "active"

	#alert animation
	$(".alert").removeClass("fadeOutUp").show().addClass "fadeInDown"
	window.setTimeout (->
	  $(".alert").removeClass("fadeInDown").addClass("fadeOutUp").one "webkitAnimationEnd animationend", ->
	  	$(this).remove();
	), 4000

	#allow anchor links for nav tabs
	url = document.location.toString()
	$(".nav-tabs a[href=#" + url.split("#")[1] + "]").tab "show"  if url.match("#")

	#homepage release animation
	$container = $("#releases")
	$releases = $container.children("a")
	timeout = undefined
	$releases.on "mouseenter", (event) ->
	  $single_release = $(this)
	  clearTimeout timeout
	  timeout = setTimeout(->
	    return false  if $single_release.hasClass("active")
	    $releases.not($single_release).removeClass("active").addClass "blur"
	    $single_release.removeClass("blur").addClass "active"
	  , 75)

	$container.on "mouseleave", (event) ->
	  clearTimeout timeout
	  $releases.removeClass "active blur"

	hide_sidebar = ->
	  if $(window).width() < 1200
	    $(".g_right_sidebar").hide()
	  else
	    $(".g_right_sidebar").show()
	hide_sidebar()


	#enable client side validation within modals  
	$('.modal').on 'shown', ->
	  $(this).find('input:visible:first').focus().end().find('form').enableClientSideValidations()

	#scrollable left sidebar
	$(window).load ->
	  scroll_height = $('.scrollable_inner').outerHeight() #grab height of inner scrollbar div
	  $('.scrollable_inner').css 'height', scroll_height #assign height to inner scrollbar div
	  window_height = $(window).height() #grab current window height
	  $('.scrollable').css 'height', window_height #set parent scrollbar div as window height
	  full_scroll_height = scroll_height + 81 #add page navbar and padding when calculating scroll start point in comparison to window height
	  #check and add scrollbar if required on page load
	  if window_height < full_scroll_height
	  	 $('.scrollable_inner').css 'height', window_height - 81 #then calculating the height of the scrollable content, subtract the page navbar and padding
	  else 
	  	 $('.scrollable_inner').css 'height', scroll_height #if window height is not less than scrollbar inner div height, assign its original height

	  #check and add scrollbar if required on window resizing in real time
	  $(window).resize -> 
	   hide_sidebar()
	   window_height = $(window).height()
	   $('.scrollable').css 'height', window_height
	   if window_height < full_scroll_height
	  	 $('.scrollable_inner').css 'height', window_height - 81 #then calculating the height of the scrollable content, subtract the page navbar and padding
	   else 
	  	 $('.scrollable_inner').css 'height', scroll_height

	#search query
	query = $('#tab3').data 'query'
	rel_last_load = new Date().getTime()
	rel_page = 2
	#release infinite scrolling
	$(".search-tab-content #tab3").bind "mousewheel", (event, delta) ->
      if delta < 0
	      if $(document).scrollTop() > ($(document).height() - 1500) and (new Date().getTime() - rel_last_load) > 1000
		      rel_last_load = new Date().getTime()
		      console.log "AJAX release page load: " + rel_page
		      url = "/search?utf8=✓&query=" + query + "&r_page=" + rel_page
		      console.log url
		      $.get url
		      rel_page++

	art_last_load = new Date().getTime()
	art_page = 2
#artist infinite scrolling   
	$(".search-tab-content #tab2").bind "mousewheel", (event, delta) ->
      if delta < 0
	      if $(document).scrollTop() > ($(document).height() - 1500) and (new Date().getTime() - art_last_load) > 1000
		      art_last_load = new Date().getTime()
		      console.log "AJAX artist page load: " + art_page
		      url = "/search?utf8=✓&query=" + query + "&a_page=" + art_page
		      console.log url
		      $.get url
		      art_page++

    user_id = $('#tab1').data 'user'
	trk_last_load = new Date().getTime()
	trk_page = 2
#artist_tracked list infinite scrolling   
	$(".profile-tab-content #tab1").bind "mousewheel", (event, delta) ->
      if delta < 0
	      if $(document).scrollTop() > ($(document).height() - 1500) and (new Date().getTime() - trk_last_load) > 1000
		      trk_last_load = new Date().getTime()
		      console.log "AJAX artist_tracked page load: " + trk_page
		      url = "/users/" + user_id + "?page=" + trk_page
		      console.log url
		      $.get url
		      trk_page++

 #    search_query = "sa"
	# 			# This example does an AJAX lookup and is in CoffeeScript
	# $('.search-query').typeahead(
	#     # source can be a function
	#   source: (typeahead, query) ->
	#       # this function receives the typeahead object and the query string
	#     $.ajax(
	#       url: "/search.json?utf8=✓&query=" + search_query
	#         # i'm binding the function here using CoffeeScript syntactic sugar,
	#         # you can use for example Underscore's bind function instead.
	#       data: 
	#       	query: search_query
	#       success: (data) =>
	#           # data must be a list of either strings or objects
	#         console.log data
	#         typeahead.process(data)
	#     )
	#     # if we return objects to typeahead.process we must specify the property
	#     # that typeahead uses to look up the display value
	#   property: "name"
	# )
	# $(".search-query").typeahead
	#   source: (typeahead, query) ->
	#     return_list = []
	#     $("li").each (i, v) ->
	#       return_list.push $(v).html()

	    
	#     # here I'm just returning a list of strings
	#     return_list

	  
	#   # typeahead calls this function when a object is selected, and
	#   # passes an object or string depending on what you processed, in this case a string
	#   onselect: (obj) ->
	#     alert "Selected " + obj

	# $(".search-query").typeahead
	#   source: (typeahead, query) ->
	    # $.ajax
	    #   url: "/search.json"
	    #   dataType: "json"
	    #   type: "POST"
	    #   data:
	    #     query: query

	#       success: (data) ->
	#         return  if data is null
	#         console.log data
	#         return_list = []
	#         # i = data.length

	#         while i--
	#           return_list[i] =
	#             id: data[i].id
	#             value: data[i].name
	#         typeahead.process return_list


	#   onselect: (obj) ->
	#     window.location = "/artists/" + obj.id
	$('.search-query').typeahead
		source: (query, process) ->

			$.ajax 
				url: "/search.json?utf8=✓&query=" + query
				dataType: "json"
				data:
					query: query

				success: (data) ->
					#generates empty array
					results = []
					#generates empty object
					map = {}
					#loops through json object called data
					$.each data, (i, result) ->
					#generates json syntax (with empty array and object) to assign the json property 'name' from each array row, to the results object
					  map[result.name] = result
					  results.push result.name

					#the typeahead process engine displays the results object
					process(results)

		updater: (item) ->
			selectedArtist = map[item].name
			return item

		matcher: (item) ->
			true  unless item.toLowerCase().indexOf(@query.trim().toLowerCase()) is -1

		sorter: (items) ->
			return items.sort()

		highlighter: (item) ->
			regex = new RegExp '(' + this.query + ')', 'gi'
			return item.replace regex, "<strong>$1</strong>"







	






