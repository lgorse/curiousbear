$(document).ready(function(){

	if($('#relationship_list').length){
		$.ajax({
			type: 'GET',
			url: '/users/'+$('.user_info').attr("id"),
			dataType: 'json',
			success: function(response){
				$('#relationship_list').pageless({ url: '/reviews'
					, totalPages: response["count"]/5+1
					, loaderMsg: "loading"
					, params: {id: response["id"]}
					, complete: star_ratings
				});
			}
		});		

	}

});

$.fn.button_highlight = function(clicked_id){
	$(this).children('a').each(function(){
		if ($(this).attr("id") == clicked_id){
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


