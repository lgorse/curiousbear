$(function(){
	if ($(".suggested_restaurant_photo").length){
		$(".suggested_restaurant_photo").each(function(){

			$(this).add_restaurant_photo($(this).attr("id"));
		});

	}

});

$.fn.add_restaurant_photo = function(restaurant_reference){
	var image = $(this);


	var lat = $("#map_"+restaurant_reference).siblings(".restaurant_lat").attr("id");
	var lng = $("#map_"+restaurant_reference).siblings(".restaurant_lng").attr("id");

	var map = new google.maps.Map(document.getElementById('map_'+restaurant_reference), {
		mapTypeId: google.maps.MapTypeId.ROADMAP,
		center: new google.maps.LatLng(lat, lng),
		zoom: 10,
		disableDefaultUI: true
	});

	var request = {
		reference: restaurant_reference
	};

	var service = new google.maps.places.PlacesService(map);

	service.getDetails(request, function(place, status){
		if (status == google.maps.places.PlacesServiceStatus.OK){
			var marker = new google.maps.Marker({
				map: map,
				position: place.geometry.location
			});

			if (place.photos){
				photo = place.photos[0].getUrl({'maxWidth': 75, 'maxHeight': 50});
				$(image).attr("src", photo);
			}else{
				$(image).attr("src", '/assets/fb-logo-75.png');

			}

		}
	});

}