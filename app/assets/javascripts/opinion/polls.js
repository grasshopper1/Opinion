// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// shows poll on load.
$(window).load(function(){
    $('#new_opinion_poll_modal').modal('show');
});

// action used for voting.
$(function() {
    $("button#vote").click(function(){
        var form = $('form.edit_poll');
        $.ajax({
            type: "POST",
            url: form.attr('action'),
            data: form.serialize(),
            success: function() {
                $("#new_opinion_poll_modal").modal('hide');
            },
            error: function(){
                alert('something went wrong')
            }
        });
    });
});
