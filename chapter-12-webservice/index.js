$(document).ready(function() {
    $('#submit').click(function(event) {
        var val = $('#in').val();
        $.get('/datetime/' + val, function(response) {
            $('#result').append(
                '<li>Input: ' + val  +
                ', Result: ' + response['result'] +
                '</li>');
        });
        event.preventDefault();
    });
});
