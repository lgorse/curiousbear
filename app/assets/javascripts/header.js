$(function(){
	$(".add_friends_button").click(function(){
		big_load_listener();
	});
});

function big_load_listener(){
	//$("#app_inner").empty().prepend('<img src = "/assets/load.gif"></img>');	
	$("#app_inner").empty();
	$("#big_loader").show();
	$(window).load(function(){
		$("#big_loader").stop(true, true);
	});
	timeout01();
	
}

function timeout01(){
setTimeout(function(){
		var snarky = $("<p>Takes forever, doesn't it?<p>").fadeIn('slow');
		$('#big_loader').append(snarky);
		timeout02();
	},
	1500
	);
}

function timeout02(){
	setTimeout(function(){
			var snarky2 = $("<p>Who do you like to eat out with?</p>").fadeIn('slow');
			$('#big_loader').append(snarky2);
			timeout03();
		},
		2000
		);

}

function timeout03(){
	setTimeout(function(){
		var snarky3 = $('<p>Who gives you the best food tips?</p>').fadeIn('slow');
		$('#big_loader').append(snarky3);

	},
	2000
	);
}