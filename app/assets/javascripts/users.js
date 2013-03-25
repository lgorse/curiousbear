$(document).ready(function(){
//click_to_user_listener();

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
				});
			}
	});		

	quick_rating();

}


});

/*function click_to_user_listener(){
	$(".user_name_link").click(function(){
		window.location = $(this).attr("href");
		});

}
*/
/*
function set_data(data){
count = data["count"];
}*/