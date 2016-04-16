$(function() {
	$('#gamefic_controls form').submit(function(event) {
		event.preventDefault();
		Gamefic.update($('#gamefic_command').val());
	});
	Gamefic.onStart(function(response) {
		$('#gamefic_prompt').html(response.prompt);
	});
	Gamefic.onFinish(function(response) {
		$('#gamefic_command').val('');
		$('#gamefic_command').focus();
		window.scrollTo(0, document.body.scrollHeight);
	});
	Gamefic.handleResponse('Active', function(response) {
		if (response.input != null) {
			$('#gamefic_output').append('<p><kbd>' + response.prompt + ' ' + response.input + '</kbd></p>');
		}
		$('#gamefic_output').append(response.output);
	});
	Gamefic.handleResponse('Concluded', function(response) {
		if (response.input != null) {
			$('#gamefic_output').append('<p><kbd>' + response.prompt + ' ' + response.input + '</kbd></p>');
		}
		$('#gamefic_output').append(response.output);
		$('#gamefic_controls').hide();
	});
	Gamefic.start();
	$('#gamefic_command').focus();
});
