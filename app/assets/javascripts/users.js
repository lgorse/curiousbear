$(document).ready(function(){

$(".user_reviews_button").bind("click", function(){
	see_user_reviews();
});
	$(".page_request").user_page_request();

});

function see_user_reviews(){
		var user_id = $(".user_bar").attr("id");
		var review_count = $(".user_reviews_button").attr("id");
		$("#relationship_list").empty();
		render_user_reviews(review_count, user_id);
	}


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

$.fn.user_page_request = function(){
	switch($(this).attr("id")){
		case 'trusted' : $('.followed_list_button').click(); break;
		case 'trusts' : $(".follows_list_button").click(); break;
		case 'reviews' : $(".user_reviews_button").click(); break;
		default : $(".wall_button").click();
	}
}


