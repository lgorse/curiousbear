$(function(){
	$(".rate_restaurant").ratings(5).bind('ratingchanged', function(event, data){
	});
});

$.fn.ratings = function(stars, initialRating){

	var elements = this;

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

			elements.triggerHandler('ratingchanged', {rating: this.rating});
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