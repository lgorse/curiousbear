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

	update_rating();
	new_rating();

});

function update_rate_button(response, button){
	var review_id = response["id"];
	action_string = "/reviews/"+review_id;
	button.attr({
		class: "rate_restaurant",
		id: "review_rating_"+review_id
});
	button.closest("form").attr("action", action_string);
	var new_input = $('<input>').attr('type','hidden').appendTo(button.closest("form"));
	new_input.attr({
		value: "put",
		name: "_method"
	});
	$(".new_review_detail").attr({
		action: '/reviews/'+review_id+"/edit",
		method: 'get'
	});
	$("#review_keywords").remove();
	$("#review_venue").remove();
}

function update_rating(){
	$(".rate_restaurant").change(function(e){
		e.preventDefault();
		var path = $(this).closest("form").attr("action");
			$.ajax({
				type: 'PUT',
				url: path,
				data: $(this).closest("form").serialize()
			});		
		
	});

}

function new_rating(){
	$(".new_rate_restaurant").change(function(e){
		alert("Hello");
		e.preventDefault();
		var path = $(this).closest("form").attr("action");
		button= $(this);
		alert($(this).closest("form").serialize());
		$.ajax({
			type: 'POST',
			url: path,
			data: $(this).closest("form").serialize(),
			dataType: 'json',
			success: function(response){
				alert(response);
				update_rate_button(response, button);

			}
		});		
		
	});

}



