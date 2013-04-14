load_listener();
$(function(){
$("#add_friends_button").click(function(){
	big_load_listener();
});
});

function load_listener(){
	$(function(){
		$('.search_form').submit(function(){
			$('#loading').show().html($("<img>").attr("src", "assets/load.gif"));
			$('#restaurant_list').hide();
		});
	});	
}

function big_load_listener(){
	//$("#app_inner").empty().prepend('<img src = "/assets/load.gif"></img>');	
	$("#app_inner").empty();
	$("#big_loader").show();

}

