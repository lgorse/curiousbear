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

if ($('#facebook_friends').length){
$.ajax({ 
	type: 'GET',
	dataType: 'json',
	url: '/users/'+$('.user_info').attr("id")+'/facebook_friends',
	success: function(response){
		$('#facebook_friends').pageless({ url: '/users/'+response["id"]+'/facebook_friends_invite'
										, totalPages: response["count"]/20+1
										, loaderMsg: "loading"
										, params: {id: response["id"]}

		});

	}
});

}


});

