// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require gmap3


$(document).ready(function(){
	$("#more_reviewers").click(function(e){
		$("#partial_reviewer_list").remove();
		$("#full_reviewer_list").show();
	});

	$(".rate_restaurant").change(function(e){
		e.preventDefault();
		var path = $(this).closest("form").attr("action");
			$.ajax({
				type: 'PUT',
				url: path,
				data: $(this).closest("form").serialize()
			});		
		
	});

	$(".new_rate_restaurant").change(function(e){
		e.preventDefault();
		var path = $(this).closest("form").attr("action");
		$.ajax({
			type: 'POST',
			url: path,
			data: $(this).closest("form").serialize(),
			success: function(response){
				alert(response);

			}
		});		
		
	});

});




