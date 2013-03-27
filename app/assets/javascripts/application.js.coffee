//= require jquery_ujs

$(document).ready ->
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
	$('.tip').tooltip()
	$ ->
	  $("#slider").slider
	    min: 0
	    max: 250
	    step: 50
	    #slide: (event, ui) ->
	    #  $("#amount").val "$" + ui.value

	#  $("#amount").val "$" + $("#slider").slider("value")
	$(".share_artist").popover
	  html: true
	  content: ->
	    $(".art_pop").html()

	$(".share_release").popover
	  html: true
	  content: ->
	    $(".rel_pop").html()

	$(".share, .buy").click ->
      $(this).toggleClass "active"

    $("body").on "click", ".popover a", ->
    	$(".share, .buy").each ->
	    	$(this).popover "hide"
		    $(this).removeClass "active"

    $(".buy").popover
      html: true
      content: ->
      	$(".buy_pop").html()

	$("body").on "click", (e) ->
	  $(".share, .buy").each ->
	    if not ($(this).is(e.target) or $(this).has(e.target).length > 0) and $(this).siblings(".popover").length isnt 0 and $(this).siblings(".popover").has(e.target).length is 0
	      $(this).popover "hide"
	      $(this).removeClass "active"

	$('.image').click ->
		$('.front').toggleClass('front-flip')
		$('.back').toggleClass('back-flip')

	$(".share_tracker").each ->
	  $elem = $(this)
	  share_id = $elem.attr("id")
	  $elem.popover
	    html: true
	    content: $(".art_pop_"+ share_id + "").html()



	



