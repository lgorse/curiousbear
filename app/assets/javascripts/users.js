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
								, complete: quick_rating
				});
			}
	});		

}


});

