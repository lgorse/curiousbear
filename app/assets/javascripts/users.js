$(document).ready(function(){

	if($('#relationship_list').length){
		var user_id = $(".user_bar").attr("id");
		var review_count = $(".user_reviews_button").attr("id");
		render_user_reviews(review_count, user_id);
	}

});

$.fn.button_highlight = function(clicked_id){
	$(this).find('a').each(function(){
		if ($(this).hasClass(clicked_id)){
			$(this).removeClass("not_highlighted highlighted").addClass("selected").unbind('mouseenter mouseleave');
		}else{
			$(this).removeClass("highlighted selected").addClass("not_highlighted").hover(function(){
				$(this).removeClass("not_highlighted").addClass("highlighted");
			},
			function(){
				$(this).removeClass("highlighted").addClass("not_highlighted");
			});
		}

	});
}

function render_user_reviews(review_count, user_id){
$('#relationship_list').pageless({ url: '/reviews'
					, totalPages: review_count/5+1
					, loaderMsg: "loading"
					, params: {user_id: user_id}
					, complete: star_ratings
				});	
}


