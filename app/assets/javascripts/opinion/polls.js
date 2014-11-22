// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(window).load(function () {
    show_poll(function (show) {
        if (show == true) {
            process_modal();
        }
    });
});

// TODO Comment me
function process_modal() {
    // shows poll on load.
    var opinion_poll_modal = $('#new_opinion_poll_modal');
    opinion_poll_modal.modal('show');

    // add logic to hide event of modal.
    opinion_poll_modal.on('hide.bs.modal', function () {
        // exists and .val = 'voted' when Vote button has been pressed.
        var voted_element = $('#poll_voter');
        // vote later element length = 1 means vote later button exists this can be double checked using the config
        var vote_later_element = $('button#vote_later');
        // retrieve config, refactor to function.
        var config = get_config(opinion_poll_modal);
        get_waiting_time(function (waiting_time) {
            if (vote_later_element.length == 0 && // no vote later button exists
                voted_element.val() != 'voted' && // there has not been voted
                config['vote_later_type'] == 'on_close' && // configured vote_later_type is on_close
                (waiting_time == null || waiting_time < 0)) // waiting_time is not set or ttl has expired
            {
                add_waiting_time();
            }
        });
    });
}

// action used for voting.
$(function () {
    $("button#vote").click(function () {
        var form = $('form.edit_poll');
        $.ajax({
            type: "POST",
            url: form.attr('action'),
            data: form.serialize(),
            success: function () {
                $('#poll_voted').val('voted');
                $("#new_opinion_poll_modal").modal('hide');
            },
            error: function () {
                if (!(event.status == 401 && event.statusText == 'Unauthorized '))
                {
                    alert('need to be signed in to be able to vote');
                }
                else {
                    alert('error seen in request ' + form.attr('action'));
                }
            }
        });
    });
});

// action used when 'vote later' button is pressed.
$(function () {
    $("button#vote_later").click(function () {
        $("#new_opinion_poll_modal").modal('hide');
        add_waiting_time();
    });
});

// Get waiting time.
// needs a function, because it might / 'probably will not' return before the function ajax requests is finished.
// function retrieves an null object when an error is seen in the request. for now we alert an message that an error is seen.
// function retrieves a data object when the get finishes executing.
function get_waiting_time(func) {
    $.ajax({
        type: "GET",
        url: "/polls/polls/waiting_times.json",
        ContentType: 'application/json',
        dataType: 'json',
        async: false,
        success: function (data) {
            if (func) {
                func.call(this, data);
            }
        },
        error: function (event) {
            if (!(event.status == 401 && event.statusText == 'Unauthorized '))
            {
                alert('need to be signed in to get_waiting_time');
            }
            else {
                alert('error seen in request of waiting-times');
            }
            if (func) {
                func.call(this, null);
            }
        }
    });
}

// Get whether to show polls.
// needs a function, because it might / 'probably will not' return before the function ajax requests is finished.
// function retrieves an null object when an error is seen in the request. for now we alert an message that an error is seen.
// function retrieves a data object when the get finishes executing.
function show_poll(func) {
    $.ajax({
        type: "GET",
        url: "/polls/polls/show_poll.json",
        ContentType: 'application/json',
        dataType: 'json',
        success: function (data) {
            if (func) {
                func.call(this, data);
            }
        },
        error: function (event) {
            // Show error when signed in (by devise) and error is seen.
            if (!(event.status == 401 && event.statusText == 'Unauthorized '))
            {
                alert('error seen in request of show_poll');
            }
            if (func) {
                func.call(this, null);
            }
        }
    });
}

// retrieve config.
// TODO config is stored in modal or plain div, this is very ugly.
// @param modal Result of jquery selector for new_opinion_poll_modal.
function get_config(modal) {
    if (modal.length) {
        return modal.data('config');
    }
    else {
        return $('#new_opinion_poll').data('config');
    }
}

// Add waiting time for signed-in user.
// When a function is supplied, the function will be called, otherwise the opinion pop-up modal will be hidden.
function add_waiting_time(func) {
    $.ajax({
        type: "POST",
        url: "/polls/polls/add_waiting_time.json",
        ContentType: 'application/json',
        dataType: 'json',
        success: function () {
            if (func) {
                func.call(this);
            }
            else {
                var modal = $("#new_opinion_poll_modal");
                modal.preventDefault(); // prevents that hide event will be called twice.
                modal.modal('hide');
            }
        },
        error: function (event) {
            if (!(event.status == 401 && event.statusText == 'Unauthorized '))
            {
                alert('need to be signed in to add_waiting_time');
            }
            else {
                alert('something went wrong in calling add_waiting_time');
            }
        }
    });
}
