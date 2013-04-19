load_listener();


function load_listener(){
	$(function(){
		$('.search_form').submit(function(){
			$('#loading').show().html($("<img>").attr("src", "/assets/load.gif"));
			$('#restaurant_list, #show_holder').hide();
			//$('#show_holder').hide();
		});
		
		$('.google_next_button').click(function(){
			$('#loading').show().html($("<img>").attr("src", "/assets/load.gif"));
			$('#restaurant_list').hide();
		});
	});	
}



