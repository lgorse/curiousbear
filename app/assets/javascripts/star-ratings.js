$(function(){
star_ratings();
});

function star_ratings(){

	$(".rate_restaurant").each(function(){

if (!$(this).hasClass("checked")){


	$(this).ratings(5).bind('ratingchanged', function(event, data){

		var path = $(this).closest("form").attr("action");
		if (data.initialRating > 0){
			$.ajax({
				type: 'PUT',
				url: path,
				data: $(this).closest("form").serialize()
			});
		}else{
			var star_container = $(this);
			$.ajax({
			type: 'POST',
			url: path,
			data: $(this).closest("form").serialize(),
			dataType: 'json',
			beforeSend: function(){
				var add_button = star_container.parents(".flat_list").find(".new_review_detail");
				add_button.attr('disabled', true);
			},
			success: function(response){
				update_detail_button(response, star_container);
				}
			});	
		}
	});

}
	});// .each function ends here

}

function update_detail_button(response, star_element){
	var add_button = star_element.parents(".flat_list").find(".new_review_detail");
	var review_id = response["id"];
	var action_string = "/reviews/"+review_id+"/edit";
	add_button.attr({action: action_string,
						method: 'get'						
	});
	add_button.find(".new_review_submit_tag").attr("value", "Say more");

}


$.fn.ratings = function(stars){

	var elements = this;
	elements.toggleClass("checked");
	var review_rating = elements.find('#review_rating');
	var initialRating = review_rating.attr("value");


	return this.each(function(){

		if(!initialRating){
			initialRating = 0;
		}

		var containerElement = this;

		var container = $(this);

		var starsCollection = Array();

		containerElement.rating = initialRating;

		container.css('overflow', 'auto');


		for(var x = 0; x < stars; x++){

			var starElement = document.createElement('div');

			var star = $(starElement);

			starElement.rating = x +1;

			star.addClass('input_stars');

			if (x < initialRating){
				star.addClass('input_stars_full');

			}

		container.append(star);
		starsCollection.push(star);

		star.click(function(){
			containerElement.rating = this.rating;
			
			review_rating.attr("value", this.rating);
			elements.triggerHandler('ratingchanged', {rating: this.rating,
													initialRating: initialRating});
		});

		star.mouseenter(function(){

			for (var i = 0; i <this.rating; i++){
				starsCollection[i].addClass('input_stars_full');
			}

			for (var i = this.rating; i < stars; i++){
				starsCollection[i].removeClass('input_stars_full');
			}


		});

		container.mouseleave(function(){
			for (var i = 0; i <containerElement.rating; i++){
				starsCollection[i].addClass('input_stars_full');
			}

			for (var i = containerElement.rating; i < stars; i++){
				starsCollection[i].removeClass('input_stars_full');
			}


		});


		}//for loop ends here 
	});


};