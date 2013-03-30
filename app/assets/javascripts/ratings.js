

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
		e.preventDefault();
		var path = $(this).closest("form").attr("action");
		button= $(this);
		$.ajax({
			type: 'POST',
			url: path,
			data: $(this).closest("form").serialize(),
			dataType: 'json',
			success: function(response){
				update_rate_button(response, button);
			}
		});		
		
	});

}

function quick_rating(){
	update_rating();
	new_rating();
}
