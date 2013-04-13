/*$(function(){
	if ($('#facebook_friends').length){
		$.ajax({ 
			type: 'GET',
			dataType: 'json',
			url: '/users/'+$('.user_info').attr("id")+'/facebook_friends',
			success: function(response){

				$('#facebook_friends').pageless({ url: '/users/'+response["id"]+'/facebook_friends_invite'
					, totalPages: response["count"]/50+1
					, loaderMsg: "loading"
					, params: {id: response["id"]}

				});

			}
		});

	}

});*/